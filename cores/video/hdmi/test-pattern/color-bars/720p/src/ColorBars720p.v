//
// ColorBars720p - SMPTE Color Bars test pattern for HDMI/DVI at 720p
//
// This test pattern is based on the description in the SMPTE color bars article in Wikipedia:
// https://en.wikipedia.org/wiki/SMPTE_color_bars
// Referencing the 720p rendering from Wikimedia:
// https://commons.wikimedia.org/wiki/File:SMPTE_Color_Bars_16x9.svg
//
//
// Copyright 2020 Reclone Labs <reclonelabs.com>
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

module ColorBars720p
(
    input wire pixelClock,
    input wire [11:0] hPos,
    input wire [10:0] vPos,
    input wire dataEnable,
    input wire hSync,
    input wire vSync,
    input wire activeVideoPreamble,
    input wire activeVideoGuardBand,
    
    output reg [7:0] r = 8'd0,
    output reg [7:0] g = 8'd0,
    output reg [7:0] b = 8'd0,
    output reg dataEnableDelayed,
    output reg hSyncDelayed,
    output reg vSyncDelayed,
    output reg activeVideoPreambleDelayed,
    output reg activeVideoGuardBandDelayed
);

// To divide by a constant, multiply by its reciprocal (with fixed point scaling)
/* verilator lint_off UNUSED */
wire [18:0] gradientLevelScaled = ({7'd0, hPos} - 19'd297) * 19'd637;
/* verilator lint_on UNUSED */
wire [7:0] gradientLevel = gradientLevelScaled[18:11];

always @ (posedge pixelClock) begin
    dataEnableDelayed <= dataEnable;
    hSyncDelayed <= hSync;
    vSyncDelayed <= vSync;
    activeVideoPreambleDelayed <= activeVideoPreamble;
    activeVideoGuardBandDelayed <= activeVideoGuardBand;

    if (vPos < 11'd420) begin
        // Main set of seven color bars and gray side bars
        // Gray bars on left and right sides are 160px wide
        // Color bars are 137ish pixels wide (center bar an extra pixel wide)
        if (hPos < 12'd160) begin
            // gray
            r <= 8'd102;
            g <= 8'd102;
            b <= 8'd102;
        end else if (hPos < 12'd297) begin
            // 75% white
            r <= 8'd191;
            g <= 8'd191;
            b <= 8'd191;
        end else if (hPos < 12'd434) begin
            // 75% yellow
            r <= 8'd191;
            g <= 8'd191;
            b <= 8'd0;
        end else if (hPos < 12'd571) begin
            // 75% cyan
            r <= 8'd0;
            g <= 8'd191;
            b <= 8'd191;
        end else if (hPos < 12'd709) begin
            // 75% green
            r <= 8'd0;
            g <= 8'd191;
            b <= 8'd0;
        end else if (hPos < 12'd846) begin
            // 75% magenta
            r <= 8'd191;
            g <= 8'd0;
            b <= 8'd191;
        end else if (hPos < 12'd983) begin
            // 75% red
            r <= 8'd191;
            g <= 8'd0;
            b <= 8'd0;
        end else if (hPos < 12'd1120) begin
            // 75% blue
            r <= 8'd0;
            g <= 8'd0;
            b <= 8'd191;
        end else begin
            // gray
            r <= 8'd102;
            g <= 8'd102;
            b <= 8'd102;
        end
    end else if (vPos < 11'd480) begin
        if (hPos < 12'd160) begin
            // 100% cyan
            r <= 8'd0;
            g <= 8'd255;
            b <= 8'd255;
        end else if (hPos < 12'd297) begin
            // -I
            r <= 8'd0;
            g <= 8'd33;
            b <= 8'd76;
        end else if (hPos < 12'd1120) begin
            // 75% white
            r <= 8'd191;
            g <= 8'd191;
            b <= 8'd191;
        end else begin
            // 100% blue
            r <= 8'd0;
            g <= 8'd0;
            b <= 8'd255;
        end
    end else if (vPos < 11'd540) begin
        if (hPos < 12'd160) begin
            // 100% yellow
            r <= 8'd255;
            g <= 8'd255;
            b <= 8'd0;
        end else if (hPos < 12'd297) begin
            // +Q
            r <= 8'd50;
            g <= 8'd0;
            b <= 8'd106;
        end else if (hPos < 12'd1120) begin
            // Grayscale gradient
            r <= gradientLevel;
            g <= gradientLevel;
            b <= gradientLevel;
        end else begin
            // 100% red
            r <= 8'd255;
            g <= 8'd0;
            b <= 8'd0;
        end
    end else begin
        if (hPos < 12'd160) begin
            // 15% gray
            r <= 8'd38;
            g <= 8'd38;
            b <= 8'd38;
        end else if (hPos < 12'd366) begin
            // black
            r <= 8'd0;
            g <= 8'd0;
            b <= 8'd0;
        end else if (hPos < 12'd640) begin
            // white
            r <= 8'd255;
            g <= 8'd255;
            b <= 8'd255;
        end else if (hPos < 12'd846) begin
            // black
            r <= 8'd0;
            g <= 8'd0;
            b <= 8'd0;
        end else if (hPos < 12'd892) begin
            // 2% black
            r <= 8'd5;
            g <= 8'd5;
            b <= 8'd5;
        end else if (hPos < 12'd937) begin
            // black
            r <= 8'd0;
            g <= 8'd0;
            b <= 8'd0;
        end else if (hPos < 12'd983) begin
            // 4% black
            r <= 8'd10;
            g <= 8'd10;
            b <= 8'd10;
        end else if (hPos < 12'd1120) begin
            // black
            r <= 8'd0;
            g <= 8'd0;
            b <= 8'd0;
        end else begin
            // 15% gray
            r <= 8'd38;
            g <= 8'd38;
            b <= 8'd38;
        end
    end
end

endmodule