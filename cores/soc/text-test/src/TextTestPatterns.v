//
// TextTestPatterns - Output text rendering test patterns
//
// TODO description
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

module TextTestPatterns # (parameter COUNTER_SIZE = 10)
(
    input wire pixelClock,
    input wire ntscClock,
    input wire palClock,
    output wire blink,
    output wire[9:0] dviChannel0,
    output wire[9:0] dviChannel1,
    output wire[9:0] dviChannel2,
    output wire[9:0] dviChannelC,
    output wire[4:0] videoDac
);

wire[COUNTER_SIZE-1:0] count;

CountUp #(.SIZE(COUNTER_SIZE)) counter
(
    .clock(pixelClock),
    .increment(1'd1),
    .load(1'd0),
    .data(25'd0),
    .reset(1'd0),
    .out(count)
);

assign blink = count[COUNTER_SIZE-1];


wire dataEnable;
wire hSync;
wire vSync;
wire [11:0] hPos;
wire [10:0] vPos;
wire activeVideoPreamble;
wire activeVideoGuardBand;
VideoFormatTiming hd720pTiming
(
    .clock(pixelClock),
    .reset(1'b0),
    .hFrontPorch(7'd110),
    .hSyncPulse(8'd40),
    .hBackPorch(8'd220),
    .hActive(11'd1280),
    .vFrontPorch(6'd5),
    .vSyncPulse(4'd5),
    .vBackPorch(6'd20),
    .vActive(11'd720),
    .isInterlaced(1'b0),
    .dataEnable(dataEnable),
    .hSync(hSync),
    .vSync(vSync),
    .hPos(hPos),
    .vPos(vPos),
    .activeVideoPreamble(activeVideoPreamble),
    .activeVideoGuardBand(activeVideoGuardBand)
);

wire [3:0] ntscPhase;
wire ntscBlank;
wire ntscSync;
wire ntscBurst;
wire [9:0] ntscHPos;
wire [9:0] ntscVPos;
NtscTiming ntscCompositeTiming
(
    .reset(1'b0),
    .phaseClock(ntscClock),
    .progressive(1'b0),
    .phase(ntscPhase),
    .blank(ntscBlank),
    .hSync(),
    .vSync(),
    .sync(ntscSync),
    .burst(ntscBurst),
    .hPos(ntscHPos),
    .vPos(ntscVPos)
);

/*wire [3:0] palPhase;
wire palBlank;
wire palSync;
wire palBurst;
wire palLinePhase;
wire palVSync;
wire [9:0] palHPos;
wire [9:0] palVPos;
PalTiming palCompositeTiming
(
    .reset(1'b0),
    .phaseClock(palClock),
    .progressive(1'b0),
    .phase(palPhase),
    .blank(palBlank),
    .hSync(),
    .vSync(palVSync),
    .sync(palSync),
    .burst(palBurst),
    .linePhase(palLinePhase),
    .hPos(palHPos),
    .vPos(palVPos)
);*/



wire signed [8:0] ntscY;
wire signed [8:0] ntscI;
wire signed [8:0] ntscQ;

/*wire signed [8:0] palY;
wire signed [8:0] palU;
wire signed [8:0] palV;*/

// 2-D Color Gradients
/* RgbToYiq ntscColorConverter
(
    .r({ntscVPos[6:0], 1'b0}),
    .g(ntscVPos[7:0]),
    .b(ntscHPos[7:0]),
    .y(ntscY),
    .i(ntscI),
    .q(ntscQ)
); */

// Grayscale Gradient
/* RgbToYiq ntscColorConverter
(
    .r(ntscHPos[8:1]),
    .g(ntscHPos[8:1]),
    .b(ntscHPos[8:1]),
    .y(ntscY),
    .i(ntscI),
    .q(ntscQ)
); */

// Color Bars
wire ntscBlankDelayed;
wire ntscSyncDelayed;
wire ntscBurstDelayed;
NtscColorBars colorBars
(
    .ntscClock(ntscClock),
    .hPos(ntscHPos),
    .vPos(ntscVPos),
    .blank(ntscBlank),
    .sync(ntscSync),
    .burst(ntscBurst),
    .y(ntscY),
    .i(ntscI),
    .q(ntscQ),
    .blankDelayed(ntscBlankDelayed),
    .syncDelayed(ntscSyncDelayed),
    .burstDelayed(ntscBurstDelayed)
);

/*wire palBlankDelayed;
wire palSyncDelayed;
wire palBurstDelayed;
wire palLinePhaseDelayed;
PalColorBars colorBars
(
    .palClock(palClock),
    .hPos(palHPos),
    .vPos(palVPos),
    .blank(palBlank),
    .sync(palSync),
    .burst(palBurst),
    .linePhase(palLinePhase),
    .y(palY),
    .u(palU),
    .v(palV),
    .blankDelayed(palBlankDelayed),
    .syncDelayed(palSyncDelayed),
    .burstDelayed(palBurstDelayed),
    .linePhaseDelayed(palLinePhaseDelayed)
);*/

NtscGenerator ntscGen
(
    .reset(1'b0),
    .phaseClock(ntscClock),
    .subcarrierPhase(ntscPhase),
    .blank(ntscBlankDelayed),
    .sync(ntscSyncDelayed),
    .burst(ntscBurstDelayed),
    .y(ntscY),
    .i(ntscI),
    .q(ntscQ),
    .dacSample(videoDac)
);

/*PalGenerator palGen
(
    .reset(1'b0),
    .phaseClock(palClock),
    .subcarrierPhase(palPhase),
    .blank(palBlankDelayed),
    .sync(palSyncDelayed),
    .burst(palBurstDelayed),
    .linePhase(palLinePhaseDelayed),
    .y(palY),
    .u(palU),
    .v(palV),
    .dacSample(videoDac)
);*/

wire glyphRamReadEnable;
wire [11:0] glyphRamAddress;
wire [7:0] glyphRamDataOut;
TextGlyphRam #(.MEM_INIT_FILE("CP437_8x14.mem")) glyphRam
(
    // Read-only Port A
    .clockA(pixelClock),
    .enableA(glyphRamReadEnable),
    .addressA(glyphRamAddress),
    .dataOutA(glyphRamDataOut),
    
    // Read/Write Port B
    .clockB(pixelClock),
    .enableB(1'b0),
    .writeEnableB(1'b0),
    .addressB(12'd0),
    .dataInB(8'd0),
    .dataOutB()
);

wire screenRamReadEnable;
wire [10:0] screenRamAddress;
wire [15:0] screenRamDataOut;
TextScreenRam #(.MEM_INIT_FILE("CharSet_ColorSet.mem")) screenRam
(
    // Read-only Port A
    .clockA(pixelClock),
    .enableA(screenRamReadEnable),
    .addressA(screenRamAddress),
    .dataOutA(screenRamDataOut),
    
    // Read/Write Port B
    .clockB(pixelClock),
    .enableB(1'b0),
    .writeEnableB(1'b0),
    .addressB(11'd0),
    .dataInB(16'd0),
    .dataOutB()
);

wire [7:0] dviR;
wire [7:0] dviG;
wire [7:0] dviB;
wire dataEnableDelayed;
wire hSyncDelayed;
wire vSyncDelayed;
wire activeVideoGuardBandDelayed;
wire activeVideoPreambleDelayed;

TextOverlayGenerator textOverlay
(
    .reset(1'b0),
    .pixelClock(pixelClock),
    .pixelEnable(1'b1),
    
    // Video timing info - inputs and delayed outputs
    .videoDataEnableIn(dataEnable),
    .hSyncIn(hSync),
    .vSyncIn(vSync),
    .hPosIn(hPos),
    .vPosIn(vPos),
    .activeVideoPreambleIn(activeVideoPreamble),
    .activeVideoGuardBandIn(activeVideoGuardBand),
    
    .videoDataEnableOut(dataEnableDelayed),
    .hSyncOut(hSyncDelayed),
    .vSyncOut(vSyncDelayed),
    .hPosOut(),
    .vPosOut(),
    .activeVideoPreambleOut(activeVideoPreambleDelayed),
    .activeVideoGuardBandOut(activeVideoGuardBandDelayed),
    
    // Upstream color which may be changed by overlay
    .upstreamRed(8'h10),
    .upstreamGreen(8'h00),
    .upstreamBlue(8'h10),
    
    // Output color which includes text overlay
    .red(dviR),
    .green(dviG),
    .blue(dviB),
    
    // Settings
    .blinkIsBackgroundIntensity(1'b1),
    .enableCursor(1'b1),
    .cursorScanLineStart(4'd11),
    .cursorScanLineEnd(4'd12),
    .cursorPositionColumn(7'd22),
    .cursorPositionRow(5'd11),
    .glyphHeight(5'd14),
    .hScaleFactor(3'd2),
    .vScaleFactor(3'd2),
    .leftPadding(11'd0),
    .topPadding(11'd10),
    .colorAlphas(32'hFFFFFFFF),
    .numColumns(7'd80),
    .numRows(5'd25),
    
    // Glyph RAM port
    .glyphRamEnable(glyphRamReadEnable),
    .glyphRamAddress(glyphRamAddress),
    .glyphRamData(glyphRamDataOut),
    
    // Screen RAM port
    .screenRamEnable(screenRamReadEnable),
    .screenRamAddress(screenRamAddress),
    .screenRamData(screenRamDataOut)
);

HdmiEncoder hdmi
(
    .pixelClock(pixelClock),
    .dataEnable(dataEnableDelayed),
    .hSync(hSyncDelayed),
    .vSync(vSyncDelayed),
    .activeVideoGuardBand(activeVideoGuardBandDelayed),
    .activeVideoPreamble(activeVideoPreambleDelayed),
    .useYCbCr(1'b0),
    .videoFormatCode(7'd4),
    .vendorName("Reclone"),
    .productDescription("SBRC"),
    .sourceDeviceInformation(8'h08),
    .blueOrCb(dviB),
    .greenOrY(dviG),
    .redOrCr(dviR),
    .n(20'd6144),
    .cts(20'd74250),
    .samplesPerRegenPacket(8'd48),
    .spdifCategoryCode(8'h40),  // Digital-digital converter
    .spdifSamplingFreq(4'd2),   // 48 kHz
    .spdifWordLength(4'd2),     // 16 bits
    .sampleFifoEmpty(1'b1),
    .sampleFifoReadData(32'd0),
    .sampleFifoReadEnable(),
    .channel0(dviChannel0),
    .channel1(dviChannel1),
    .channel2(dviChannel2),
    .channelC(dviChannelC)
);


endmodule