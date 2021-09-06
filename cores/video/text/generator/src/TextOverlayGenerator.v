//
// TextOverlayGenerator - A VGA-like text generator that can overlay another video source
//
// This text overlay generator implements a way to show text onscreen.  The design intent is to
// implement some of the features of CGA/EGA/VGA text mode without going too crazy on resource
// utilization, because two of these might be running on the FPGA simultaneously.
// See https://en.wikipedia.org/wiki/VGA_text_mode for some background.
//
// This should be flexible enough to support 80 columns by 25ish rows of monospaced characters
// at a variety of resolutions like 640x240, 640x480, 1280x720, and 1920x1080.  Each character
// is eight pixels wide, making each row of a glyph take up exactly one byte (1 bpp).  To support
// 25 rows at all resolutions, each character may be 8, 14, or 16 pixels tall, therefore each
// glyph takes up 16 bytes.  With a total of 256 code points (supporting CP-437 character set),
// the glyph RAM is 4096 bytes in size.
//
// Each character glyph is rendered with a single foreground and background color, and glyphs can
// double or triple in height and/or width to fit 80x25 to a variety of display resolutions.
//
// Color palette:
//  Low intensity  - Black=0, Red=1, Green=2, Yellow=3, Blue=4, Magenta=5, Cyan=6, White=7
//  High intensity - Gray=8, BrRed=9, BrGreen=10, BrYellow=11, BrBlue=12, BrMagenta=13, BrCyan=14, BrWhite=15
//
// Like VGA, each location in screen RAM is 16 bits, containing character and attribute bytes:
//      | -------------- Attribute Byte -------------- | -- Character Byte --|
//      | Blink* | Background Color | Foreground Color |     Code Point      |
//     bit  15         14 13 12          11 10 9 8         7 6 5 4 3 2 1 0
// * The visual effect of bit 15 depends on the value of the blinkIsBackgroundIntensity flag:
//   blinkIsBackgroundIntensity=0 : text blinks if bit 15 set; background color limited to 0 - 7
//   blinkIsBackgroundIntensity=1 : no blinking; background color 0 - 15 including high intensity
//
// A blinking cursor can be enabled at a specific row/column cell position.  The cursor's size and
// position within the character cell can be adjusted via cursorScanLineStart and cursorScanLineEnd.
// If enabled, the on/off state of the cursor changes every 16 vertical frames by periodically
// drawing a rectangle of foreground color (http://www.osdever.net/FreeVGA/vga/textcur.htm).
// Blinking text blinks at half that rate; its foreground on/off state changes every 32 frames.
//
// The screen RAM supports a screen of 80x25 characters, so it must store 2000 16-bit words
// (4000 bytes).  Since this is very close to 2048 words (4096 bytes), the remaining
// 48 characters can be displayed on a partial line 26, for some creative visual effects.
// The last entry in screen RAM is repeated for the rightmost 33 characters of screen row 26.
// Consider 8x14 text being displayed at 720p resolution: if the characters are doubled in size
// to 16x28, that means 25 rows take up 700 pixels in height, leaving an extra 20 pixels of height
// to partially display our sneaky 26th row.
//
// Text can be overlayed into an upstream video feed through careful use of color.  Each of the
// 16 colors is configured with a 2-bit alpha channel, allowing for four levels of transparency.
// That is, a text pixel can be completely transparent, completely opaque, or partially transparent,
// depending on its color and the color's configured alpha value.
//
// To avoid the use of several expensive multipliers, this module is designed to be stateful and
// implements integer scaling and character cell tracking using counters.  To do this, several
// hacky assumptions are made about hPosIn and vPosIn like:
//      - vPosIn increments by 0 (within a scanline), 1 (progressive), or 2 (interlaced)
//      - If vPosIn changes by some other amount, we assume it is the start of a new frame/field
//      - hPosIn increments by 0 (within an inactive video region) or 1 (within an active scanline)
//      - If hPosIn changes by some other amount, we assume it is the start of a new scanline
//
//
// Copyright 2021 Reclone Labs <reclonelabs.com>
//
// Redistribution and use in source and binary forms, with or without modification, are permitted
// provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of
//    conditions and the following disclaimer in the documentation and/or other materials
//    provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
// OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

`default_nettype none

module TextOverlayGenerator
(
    input wire reset,
    input wire pixelClock,
    
    // Video timing info - inputs and delayed outputs
    input wire videoDataEnableIn,
    input wire hSyncIn,
    input wire vSyncIn,
    input wire [HACTIVE_BITS-1:0] hPosIn,
    input wire [VACTIVE_BITS-1:0] vPosIn,
    input wire activeVideoPreambleIn,
    input wire activeVideoGuardBandIn,
    
    output reg videoDataEnableOut,
    output reg hSyncOut,
    output reg vSyncOut,
    output reg [HACTIVE_BITS-1:0] hPosOut,
    output reg [VACTIVE_BITS-1:0] vPosOut,
    output reg activeVideoPreambleOut,
    output reg activeVideoGuardBandOut,
    
    // Upstream color which may be changed by overlay
    input wire [BITS_PER_COLOR_COMPONENT-1:0] upstreamRed,
    input wire [BITS_PER_COLOR_COMPONENT-1:0] upstreamGreen,
    input wire [BITS_PER_COLOR_COMPONENT-1:0] upstreamBlue,
    
    // Output color which includes text overlay
    output wire [BITS_PER_COLOR_COMPONENT-1:0] red,
    output wire [BITS_PER_COLOR_COMPONENT-1:0] green,
    output wire [BITS_PER_COLOR_COMPONENT-1:0] blue,
    
    // Settings
    input wire blinkIsBackgroundIntensity,
    input wire enableCursor,
    input wire [GLYPH_HEIGHT_BITS-1:0] cursorScanLineStart,
    input wire [GLYPH_HEIGHT_BITS-1:0] cursorScanLineEnd,
    input wire [HCELL_BITS-1:0] cursorPositionColumn,
    input wire [VCELL_BITS-1:0] cursorPositionRow,
    input wire [GLYPH_HEIGHT_BITS:0] glyphHeight,
    input wire [INTEGER_SCALE_BITS-1:0] hScaleFactor,
    input wire [INTEGER_SCALE_BITS-1:0] vScaleFactor,
    input wire [HACTIVE_BITS-1:0] leftPadding,
    input wire [VACTIVE_BITS-1:0] topPadding,
    input wire [ALPHA_SETTINGS_BITS-1:0] colorAlphas,
    
    // Glyph RAM port
    output wire glyphRamEnable,
    output wire [GLYPH_RAM_ADDR_WIDTH-1:0] glyphRamAddress,
    input wire [GLYPH_RAM_DATA_WIDTH-1:0] glyphRamData,
    
    // Screen RAM port
    output wire screenRamEnable,
    output wire [SCREEN_RAM_ADDR_WIDTH-1:0] screenRamAddress,
    input wire [SCREEN_RAM_DATA_WIDTH-1:0] screenRamData
);

localparam GLYPH_RAM_ADDR_WIDTH = 12;
localparam GLYPH_RAM_DATA_WIDTH = 8;
localparam SCREEN_RAM_ADDR_WIDTH = 11;
localparam SCREEN_RAM_DATA_WIDTH = 16;
localparam BITS_PER_COLOR_COMPONENT = 8;
localparam BITS_PER_PIXEL = BITS_PER_COLOR_COMPONENT * 3;
localparam GLYPH_HEIGHT_BITS = 4;
localparam MAX_GLYPH_HEIGHT = 1 << GLYPH_HEIGHT_BITS;
localparam GLYPH_WIDTH_BITS = 3;
localparam GLYPH_WIDTH = 1 << GLYPH_WIDTH_BITS;
localparam HCELL_BITS = 7;
localparam VCELL_BITS = 5;
localparam INTEGER_SCALE_BITS = 2;
localparam HACTIVE_BITS = 11;
localparam VACTIVE_BITS = 11;
localparam COLORNUM_BITS = 4;
localparam NUM_COLORS = 1 << COLORNUM_BITS;
localparam ALPHA_BITS = 2;
localparam ALPHA_SETTINGS_BITS = NUM_COLORS * ALPHA_BITS;
localparam DELAY_CLOCKS = 3;
localparam FRAME_COUNTER_BITS = 6;
localparam SCREEN_WIDTH_BITS = 7;
localparam SCREEN_HEIGHT_BITS = 5;
localparam SCREEN_MAX_WIDTH = 7'd80;
localparam SCREEN_MAX_HEIGHT = 5'd26;

// Always read something from the glyph and screen rams
assign glyphRamEnable = 1'b1;
assign screenRamEnable = 1'b1;

// Screen ram address is screenRow * 80 + screenColumn (saturating at 0x7FF)
wire [SCREEN_RAM_ADDR_WIDTH:0] screenRamAddressExtended =
    {{(SCREEN_RAM_ADDR_WIDTH-SCREEN_HEIGHT_BITS-6){1'b0}}, screenRow, 6'd0} + // screenRow*64
    {{(SCREEN_RAM_ADDR_WIDTH-SCREEN_HEIGHT_BITS-4){1'b0}}, screenRow, 4'd0} + // screenRow*16
    {{(SCREEN_RAM_ADDR_WIDTH-SCREEN_WIDTH_BITS){1'b0}}, screenColumn};
assign screenRamAddress = screenRamAddressExtended[SCREEN_RAM_ADDR_WIDTH] ?
                            11'h7FF : screenRamAddressExtended[SCREEN_RAM_ADDR_WIDTH-1:0];

// Glyph RAM address is the code point (from screen RAM) concatenated with the glyph row
assign glyphRamAddress = {screenRamData[7:0], glyphRow};

// Frame counter used to implement blink rates of text and cursor
reg [FRAME_COUNTER_BITS-1:0] frameCounter = {FRAME_COUNTER_BITS{1'b0}};

reg [BITS_PER_PIXEL-1:0] colorRom [0:NUM_COLORS-1];
initial begin
    $readmemh("Text16ColorPallette.mem", colorRom);
end

// Delayed signals (3 clock cycles)
reg [VACTIVE_BITS-1:0] vPosInDelayed [0:DELAY_CLOCKS-1];
reg [HACTIVE_BITS-1:0] hPosInDelayed [0:DELAY_CLOCKS-1];
reg [DELAY_CLOCKS-1:0] vSyncInDelayed = {DELAY_CLOCKS{1'b0}};
reg [DELAY_CLOCKS-1:0] hSyncInDelayed = {DELAY_CLOCKS{1'b0}};
reg [DELAY_CLOCKS-1:0] videoDataEnableInDelayed = {DELAY_CLOCKS{1'b0}};
reg [DELAY_CLOCKS-1:0] activeVideoPreambleInDelayed = {DELAY_CLOCKS{1'b0}};
reg [DELAY_CLOCKS-1:0] activeVideoGuardBandInDelayed = {DELAY_CLOCKS{1'b0}};
reg [BITS_PER_COLOR_COMPONENT-1:0] upstreamRedDelayed [0:DELAY_CLOCKS-1];
reg [BITS_PER_COLOR_COMPONENT-1:0] upstreamGreenDelayed [0:DELAY_CLOCKS-1];
reg [BITS_PER_COLOR_COMPONENT-1:0] upstreamBlueDelayed [0:DELAY_CLOCKS-1];

initial begin
    integer j;
    for(j = 0; j < DELAY_CLOCKS; j = j + 1) begin
        vPosInDelayed[j] = {VACTIVE_BITS{1'b1}};
        hPosInDelayed[j] = {HACTIVE_BITS{1'b1}};
    end
end

reg [INTEGER_SCALE_BITS-1:0] hScaleCounter = {INTEGER_SCALE_BITS{1'b0}};
reg [INTEGER_SCALE_BITS-1:0] vScaleCounter = {INTEGER_SCALE_BITS{1'b0}};
reg [GLYPH_WIDTH_BITS-1:0] hGlyphCounter = {GLYPH_WIDTH_BITS{1'b0}};
reg [GLYPH_HEIGHT_BITS-1:0] vGlyphCounter = {GLYPH_HEIGHT_BITS{1'b0}};
reg [SCREEN_WIDTH_BITS-1:0] screenColumn = {SCREEN_WIDTH_BITS{1'b0}};
reg [SCREEN_HEIGHT_BITS-1:0] screenRow = {SCREEN_HEIGHT_BITS{1'b0}};

reg [GLYPH_HEIGHT_BITS-1:0] glyphRow = {GLYPH_HEIGHT_BITS{1'b0}};
reg [GLYPH_WIDTH_BITS-1:0] glyphColumn = {GLYPH_WIDTH_BITS{1'b0}};
reg [GLYPH_WIDTH_BITS-1:0] glyphColumnReversed = {GLYPH_WIDTH_BITS{1'b0}};
reg isPaddingPixel = 1'b0;
reg isCursorPixel = 1'b0;

reg [COLORNUM_BITS-1:0] bgColorAttribute = {COLORNUM_BITS{1'b0}};
reg [ALPHA_BITS-1:0] bgAlpha = {ALPHA_BITS{1'b0}};
reg [COLORNUM_BITS-1:0] fgColorAttribute = {COLORNUM_BITS{1'b0}};
reg [ALPHA_BITS-1:0] fgAlpha = {ALPHA_BITS{1'b0}};
reg textForegroundIsVisible = 1'b0;
reg isVisibleCursorPixel = 1'b0;

function [BITS_PER_COLOR_COMPONENT-1:0] blend;
    input [BITS_PER_COLOR_COMPONENT-1:0] topColor;
    input [BITS_PER_COLOR_COMPONENT-1:0] bottomColor;
    input [ALPHA_BITS-1:0] topAlpha;
    
    begin
        if (topAlpha == 2'd3) begin
            // Only topColor
            blend = topColor;
        end else if (topAlpha == 2'd2) begin
            // 50% topColor, 50% bottomColor
            blend = {1'b0, topColor[BITS_PER_COLOR_COMPONENT-1:1]} + {1'b0, bottomColor[BITS_PER_COLOR_COMPONENT-1:1]};
        end else if (topAlpha == 2'd1) begin
            // 25% topColor, 75% bottomColor
            blend = {2'b00, topColor[BITS_PER_COLOR_COMPONENT-1:2]} +
                    {1'b0, bottomColor[BITS_PER_COLOR_COMPONENT-1:1]} +
                    {2'b00, bottomColor[BITS_PER_COLOR_COMPONENT-1:2]};
        end else begin
            // Only bottomColor
            blend = bottomColor;
        end
    end
endfunction

wire [ALPHA_BITS-1:0] colorAlphasByNumber [0:NUM_COLORS-1];
assign colorAlphasByNumber[0] = colorAlphas[1:0];
assign colorAlphasByNumber[1] = colorAlphas[3:2];
assign colorAlphasByNumber[2] = colorAlphas[5:4];
assign colorAlphasByNumber[3] = colorAlphas[7:6];
assign colorAlphasByNumber[4] = colorAlphas[9:8];
assign colorAlphasByNumber[5] = colorAlphas[11:10];
assign colorAlphasByNumber[6] = colorAlphas[13:12];
assign colorAlphasByNumber[7] = colorAlphas[15:14];
assign colorAlphasByNumber[8] = colorAlphas[17:16];
assign colorAlphasByNumber[9] = colorAlphas[19:18];
assign colorAlphasByNumber[10] = colorAlphas[21:20];
assign colorAlphasByNumber[11] = colorAlphas[23:22];
assign colorAlphasByNumber[12] = colorAlphas[25:24];
assign colorAlphasByNumber[13] = colorAlphas[27:26];
assign colorAlphasByNumber[14] = colorAlphas[29:28];
assign colorAlphasByNumber[15] = colorAlphas[31:30];

integer k;

always @ (posedge pixelClock or posedge reset) begin
    if (reset) begin
        videoDataEnableOut <= 1'b0;
        hSyncOut <= 1'b0;
        vSyncOut <= 1'b0;
        hPosOut <= {HACTIVE_BITS{1'b1}};
        vPosOut <= {VACTIVE_BITS{1'b1}};
        activeVideoPreambleOut <= 1'b0;
        activeVideoGuardBandOut <= 1'b0;
        
        vSyncInDelayed <= {DELAY_CLOCKS{1'b0}};
        hSyncInDelayed <= {DELAY_CLOCKS{1'b0}};
        videoDataEnableInDelayed <= {DELAY_CLOCKS{1'b0}};
        activeVideoPreambleInDelayed <= {DELAY_CLOCKS{1'b0}};
        activeVideoGuardBandInDelayed <= {DELAY_CLOCKS{1'b0}};
        for(k = 0; k < DELAY_CLOCKS; k = k + 1) begin
            vPosInDelayed[k] <= {VACTIVE_BITS{1'b1}};
            hPosInDelayed[k] <= {HACTIVE_BITS{1'b1}};
            upstreamRedDelayed[k] <= {BITS_PER_COLOR_COMPONENT{1'b0}};
            upstreamGreenDelayed[k] <= {BITS_PER_COLOR_COMPONENT{1'b0}};
            upstreamBlueDelayed[k] <= {BITS_PER_COLOR_COMPONENT{1'b0}};
        end
        
        frameCounter <= {FRAME_COUNTER_BITS{1'b0}};
        
        hScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
        vScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
        hGlyphCounter <= {GLYPH_WIDTH_BITS{1'b0}};
        vGlyphCounter <= {GLYPH_HEIGHT_BITS{1'b0}};
        screenColumn <= {SCREEN_WIDTH_BITS{1'b0}};
        screenRow <= {SCREEN_HEIGHT_BITS{1'b0}};
        glyphRow <= {GLYPH_HEIGHT_BITS{1'b0}};
        glyphColumn <= {GLYPH_WIDTH_BITS{1'b0}};
        glyphColumnReversed <= {GLYPH_WIDTH_BITS{1'b0}};
        
        isPaddingPixel <= 1'b0;
        isCursorPixel <= 1'b0;
        
        bgColorAttribute <= {COLORNUM_BITS{1'b0}};
        fgColorAttribute <= {COLORNUM_BITS{1'b0}};
        
        textForegroundIsVisible <= 1'b0;
        isVisibleCursorPixel <= 1'b0;
    end else begin
        
        // STAGE 1 - Calculate positions
        
        // Update hScaleCounter, vScaleCounter, hGlyphCounter, vGlyphCounter, screenColumn, screenRow
        // (This will also update screenRamAddress via combinatorial logic)
        if (vPosIn == (vPosInDelayed[0] + {{(VACTIVE_BITS-1){1'b0}},1'b1})) begin //FIXME interlaced?
            // vPos has incremented by 1 (progressive) or is the second line after padding (interlaced); assume start of new line
            hScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
            hGlyphCounter <= {GLYPH_WIDTH_BITS{1'b0}};
            screenColumn <= {SCREEN_WIDTH_BITS{1'b0}};
            
            // If vPos is past the top padding, increment the vertical counters
            if (vPosIn > topPadding) begin
                if ({1'b0, vScaleCounter} + {{(INTEGER_SCALE_BITS){1'b0}}, 1'b1} == {1'b0, vScaleFactor}) begin
                    // Scale counter has reached the scale factor, so zero out vScaleCounter and increment vGlyphCounter
                    vScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
                    if ({1'b0, vGlyphCounter} + {{(GLYPH_HEIGHT_BITS){1'b0}}, 1'b1} == glyphHeight) begin
                        // Glyph counter has reached the glyph height, so zero out vGlyphCounter and increment screenRow
                        vGlyphCounter <= {GLYPH_HEIGHT_BITS{1'b0}};
                        screenRow <= screenRow + {{(SCREEN_HEIGHT_BITS-1){1'b0}}, 1'b1};
                    end else begin
                        // Increment vGlyphCounter
                        vGlyphCounter <= vGlyphCounter + {{(GLYPH_HEIGHT_BITS-1){1'b0}}, 1'b1};
                    end
                end else begin
                    // Increment vScaleCounter
                    vScaleCounter <= vScaleCounter + {{(INTEGER_SCALE_BITS-1){1'b0}}, 1'b1};
                end
            end
            
        end else if (vPosIn == (vPosInDelayed[0] + {{(VACTIVE_BITS-2){1'b0}},2'b10})) begin
            // vPos has incremented by 2 (interlaced); assume start of new line
            hScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
            hGlyphCounter <= {GLYPH_WIDTH_BITS{1'b0}};
            screenColumn <= {SCREEN_WIDTH_BITS{1'b0}};
            
            // If vPos is past the top padding, increment the vertical counters
            if (vPosIn > topPadding) begin
                if (vScaleCounter == 2'd0 && vScaleFactor == 2'd3) begin
                    // Increment vScaleCounter by 2
                    vScaleCounter <= 2'd2;
                end else begin
                    // Scale counter has reached the scale factor, so roll over vScaleCounter
                    vScaleCounter <= vScaleCounter + 2'd2 - vScaleFactor;
                    
                    if ({1'b0, vGlyphCounter} + {{(GLYPH_HEIGHT_BITS-1){1'b0}}, 2'b10} >= glyphHeight) begin
                        // Glyph counter has reached the glyph height, so roll over vGlyphCounter and increment screenRow
                        vGlyphCounter <= vGlyphCounter + {{(GLYPH_HEIGHT_BITS-2){1'b0}}, 2'b10} - glyphHeight[GLYPH_HEIGHT_BITS-1:0];
                        screenRow <= screenRow + {{(SCREEN_HEIGHT_BITS-1){1'b0}}, 1'b1};
                    end else begin
                        // Increment vGlyphCounter
                        vGlyphCounter <= vGlyphCounter + {{(GLYPH_HEIGHT_BITS-2){1'b0}}, 2'b10};
                    end
                end
            end
            
        end else if (vPosIn != vPosInDelayed[0]) begin
            // vPos has changed by something other than +1 or +2... assume we are starting new frame
            hScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
            hGlyphCounter <= {GLYPH_WIDTH_BITS{1'b0}};
            vScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
            vGlyphCounter <= {GLYPH_HEIGHT_BITS{1'b0}};
            screenRow <= {SCREEN_HEIGHT_BITS{1'b0}};
            screenColumn <= {SCREEN_WIDTH_BITS{1'b0}};
            
        end else if (hSyncIn) begin
            // Horizontal sync asserted, so reset all horizontal counters
            hScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
            hGlyphCounter <= {GLYPH_WIDTH_BITS{1'b0}};
            screenColumn <= {SCREEN_WIDTH_BITS{1'b0}};
            
        end else if (hPosIn == (hPosInDelayed[0] + {{(HACTIVE_BITS-1){1'b0}}, 1'b1})) begin
            // vPos has remained the same, hPos has incremented by 1
            
            // If hPos is past the left padding, increment the horizontal counters
            if (hPosIn > leftPadding) begin
                if ({1'b0, hScaleCounter} + {{(INTEGER_SCALE_BITS){1'b0}}, 1'b1} == {1'b0, hScaleFactor}) begin
                    // Scale counter has reached the scale factor, so zero out hScaleCounter and increment hGlyphCounter
                    hScaleCounter <= {INTEGER_SCALE_BITS{1'b0}};
                    if (hGlyphCounter == {GLYPH_WIDTH_BITS{1'b1}}) begin
                        // Glyph counter has reached the glyph width, so zero out hGlyphCounter and increment screenColumn
                        hGlyphCounter <= {GLYPH_WIDTH_BITS{1'b0}};
                        screenColumn <= screenColumn + {{(SCREEN_WIDTH_BITS-1){1'b0}}, 1'b1};
                    end else begin
                        // Increment hGlyphCounter
                        hGlyphCounter <= hGlyphCounter + {{(GLYPH_WIDTH_BITS-1){1'b0}}, 1'b1};
                    end
                end else begin
                    // Increment hScaleCounter
                    hScaleCounter <= hScaleCounter + {{(INTEGER_SCALE_BITS-1){1'b0}}, 1'b1};
                end
            end
        end //else don't touch the counters
        
        // Increment frame counter on each positive edge of vSyncIn
        if (vSyncIn && !vSyncInDelayed[0]) begin
            frameCounter <= frameCounter + {{(FRAME_COUNTER_BITS-1){1'b0}}, 1'b1};
        end
        
        
        // STAGE 2 - Fetching from screen RAM
        
        // Determine if this is a padding pixel
        isPaddingPixel <= (hPosInDelayed[0] < leftPadding || vPosInDelayed[0] < topPadding ||
                           screenColumn >= SCREEN_MAX_WIDTH || screenRow >= SCREEN_MAX_HEIGHT);
        
        // Determine if this is a visible cursor pixel
        isCursorPixel <= (screenColumn == cursorPositionColumn) && (screenRow == cursorPositionRow) &&
                         (vGlyphCounter >= cursorScanLineStart) && (vGlyphCounter <= cursorScanLineEnd) &&
                         enableCursor;
        
        // Save pixel position within glyph for next stage
        glyphColumn <= hGlyphCounter;
        glyphRow <= vGlyphCounter;
        
        
        // STAGE 3 - Fetching from glyph RAM
        
        // Save foreground color and background color attributes for next stage
        bgColorAttribute <= blinkIsBackgroundIntensity ? screenRamData[15:12] : {1'b0, screenRamData[14:12]};
        fgColorAttribute <= screenRamData[11:8];
        
        // Determine alpha values, which are forced to zero if this is a padding pixel
        bgAlpha <= isPaddingPixel ? {ALPHA_BITS{1'b0}} :
            colorAlphasByNumber[blinkIsBackgroundIntensity ? screenRamData[15:12] : {1'b0, screenRamData[14:12]}];
        fgAlpha <= isPaddingPixel ? {ALPHA_BITS{1'b0}} : colorAlphasByNumber[screenRamData[11:8]];
        
        // Determine whether text foreground should be visible (text might be blinking)
        textForegroundIsVisible <= frameCounter[5] || !screenRamData[15] || blinkIsBackgroundIntensity;
        
        // Determine whether this is a visible cursor pixel
        isVisibleCursorPixel <= isCursorPixel && frameCounter[4];
        
        // Delay glyphColumn so that we can select foreground vs. background in next stage
        glyphColumnReversed <= {GLYPH_WIDTH_BITS{1'b1}} - glyphColumn;
        
        
        // STAGE 4 - Determine final pixel color and write outputs
        
        // Blend the foreground or background color with the upstream color
        if (isVisibleCursorPixel ||
            (textForegroundIsVisible && glyphRamData[glyphColumnReversed])) begin
            // Foreground pixel
            red <= blend(colorRom[fgColorAttribute][23:16], upstreamRedDelayed[2], fgAlpha);
            green <= blend(colorRom[fgColorAttribute][15:8], upstreamGreenDelayed[2], fgAlpha);
            blue <= blend(colorRom[fgColorAttribute][7:0], upstreamBlueDelayed[2], fgAlpha);
        end else begin
            // Background pixel
            red <= blend(colorRom[bgColorAttribute][23:16], upstreamRedDelayed[2], bgAlpha);
            green <= blend(colorRom[bgColorAttribute][15:8], upstreamGreenDelayed[2], bgAlpha);
            blue <= blend(colorRom[bgColorAttribute][7:0], upstreamBlueDelayed[2], bgAlpha);
        end
        
        // Delayed video signals
        
        vPosInDelayed[0] <= vPosIn;
        vPosInDelayed[1] <= vPosInDelayed[0];
        vPosInDelayed[2] <= vPosInDelayed[1];
        vPosOut <= vPosInDelayed[2];
        
        hPosInDelayed[0] <= hPosIn;
        hPosInDelayed[1] <= hPosInDelayed[0];
        hPosInDelayed[2] <= hPosInDelayed[1];
        hPosOut <= hPosInDelayed[2];
        
        videoDataEnableInDelayed[0] <= videoDataEnableIn;
        videoDataEnableInDelayed[1] <= videoDataEnableInDelayed[0];
        videoDataEnableInDelayed[2] <= videoDataEnableInDelayed[1];
        videoDataEnableOut <= videoDataEnableInDelayed[2];
        
        hSyncInDelayed[0] <= hSyncIn;
        hSyncInDelayed[1] <= hSyncInDelayed[0];
        hSyncInDelayed[2] <= hSyncInDelayed[1];
        hSyncOut <= hSyncInDelayed[2];
        
        vSyncInDelayed[0] <= vSyncIn;
        vSyncInDelayed[1] <= vSyncInDelayed[0];
        vSyncInDelayed[2] <= vSyncInDelayed[1];
        vSyncOut <= vSyncInDelayed[2];
        
        activeVideoPreambleInDelayed[0] <= activeVideoPreambleIn;
        activeVideoPreambleInDelayed[1] <= activeVideoPreambleInDelayed[0];
        activeVideoPreambleInDelayed[2] <= activeVideoPreambleInDelayed[1];
        activeVideoPreambleOut <= activeVideoPreambleInDelayed[2];
        
        activeVideoGuardBandInDelayed[0] <= activeVideoGuardBandIn;
        activeVideoGuardBandInDelayed[1] <= activeVideoGuardBandInDelayed[0];
        activeVideoGuardBandInDelayed[2] <= activeVideoGuardBandInDelayed[1];
        activeVideoGuardBandOut <= activeVideoGuardBandInDelayed[2];
        
        upstreamRedDelayed[0] <= upstreamRed;
        upstreamRedDelayed[1] <= upstreamRedDelayed[0];
        upstreamRedDelayed[2] <= upstreamRedDelayed[1];
        
        upstreamGreenDelayed[0] <= upstreamGreen;
        upstreamGreenDelayed[1] <= upstreamGreenDelayed[0];
        upstreamGreenDelayed[2] <= upstreamGreenDelayed[1];
        
        upstreamBlueDelayed[0] <= upstreamBlue;
        upstreamBlueDelayed[1] <= upstreamBlueDelayed[0];
        upstreamBlueDelayed[2] <= upstreamBlueDelayed[1];
        
    end
end

endmodule

