//
// reclone-rise/ScalerTestPatternsTop - Top module for audio/video test patterns targeting Reclone Rise
//
// TODO description
//
// Copyright 2019 Reclone Labs <reclonelabs.com>
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

module ScalerTestPatternsTop
(
   input wire  CLK10M,
   output wire GPIO28,
   output wire GPIO29,
   output wire TmdsOutCh0P,
   output wire TmdsOutCh0N,
   output wire TmdsOutCh1P,
   output wire TmdsOutCh1N,
   output wire TmdsOutCh2P,
   output wire TmdsOutCh2N,
   output wire TmdsOutChCP,
   output wire TmdsOutChCN,
   output wire [4:0] VideoDac,
   output wire AudioDacLeft,
   output wire AudioDacRight
);

wire hdmiPixelClock;
wire hdmiDataLoadClock;
wire hdmiIoClock;
wire hdmiSerDesStrobe;

wire ntscClock;
wire palClock;

wire audioClock;

assign GPIO28 = 1'b1;

ClockGen clkGen
(
    .clk10m(CLK10M),
    .hdmiPixelClock(hdmiPixelClock),
    .hdmiDataLoadClock(hdmiDataLoadClock),
    .hdmiIoClock(hdmiIoClock),
    .hdmiSerDesStrobe(hdmiSerDesStrobe),
    .ntscClock(ntscClock),
    .palClock(palClock),
    .audioClock(audioClock)
);

wire [9:0] dviChannel0;
wire [9:0] dviChannel1;
wire [9:0] dviChannel2;
wire [9:0] dviChannelC;
wire audioSampleEnable;
ScalerTestPatterns #(.COUNTER_SIZE(25)) testPatterns
(
    .scalerClock(hdmiDataLoadClock),
    .pixelClock(hdmiPixelClock),
    .blink(GPIO29),
    .dviChannel0(dviChannel0),
    .dviChannel1(dviChannel1),
    .dviChannel2(dviChannel2),
    .dviChannelC(dviChannelC),
    
    .ntscClock(ntscClock),
    .palClock(palClock),
    .videoDac(VideoDac),
    
    .audioClock(audioClock),
    .audioSampleEnable(audioSampleEnable),
    .deltaSigmaRight(AudioDacRight),
    .deltaSigmaLeft(AudioDacLeft)
);

// Divide audio clock to get a 48 kHz sample clock enable signal
ClockEnableDivider audioClockDivider
(
    .clock(audioClock),
    .masterEnable(1'b1),
    .reset(1'b0),
    .numerator(16'd1),
    .denominator(16'd1875),
    .dividedEnable(audioSampleEnable)
);

wire tmdsFifoEmpty;
wire [39:0] tmdsData;
reg tmdsFifoReadEnable = 1'b1;
AsyncFifo #(.DATA_WIDTH(40), .ADDR_WIDTH(3)) tmdsFifo
(
    .asyncReset(1'b0),
    .writeClock(hdmiPixelClock),
    .writeEnable(1'b1),
    .writeData({dviChannelC, dviChannel2, dviChannel1, dviChannel0}),
    .full(),
    .readClock(hdmiDataLoadClock),
    .readEnable(tmdsFifoReadEnable),
    .empty(tmdsFifoEmpty),
    .readData(tmdsData)
);

reg [4:0] lvds0Data;
reg [4:0] lvds1Data;
reg [4:0] lvds2Data;
reg [4:0] lvdsCData;
always @ (posedge hdmiDataLoadClock) begin
    if (tmdsFifoEmpty == 1'b0) begin
        if (tmdsFifoReadEnable == 1'b1) begin
            lvdsCData <= tmdsData[39:35];
            lvds2Data <= tmdsData[29:25];
            lvds1Data <= tmdsData[19:15];
            lvds0Data <= tmdsData[9:5];
            tmdsFifoReadEnable <= 1'b0;
        end else begin
            lvdsCData <= tmdsData[34:30];
            lvds2Data <= tmdsData[24:20];
            lvds1Data <= tmdsData[14:10];
            lvds0Data <= tmdsData[4:0];
            tmdsFifoReadEnable <= 1'b1;
        end
    end
end

LvdsOut5Bit lvds0
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(lvds0Data),
    .lvdsOutputP(TmdsOutCh0P),
    .lvdsOutputN(TmdsOutCh0N)
);

LvdsOut5Bit lvds1
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(lvds1Data),
    .lvdsOutputP(TmdsOutCh1P),
    .lvdsOutputN(TmdsOutCh1N)
);

LvdsOut5Bit lvds2
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(lvds2Data),
    .lvdsOutputP(TmdsOutCh2P),
    .lvdsOutputN(TmdsOutCh2N)
);

LvdsOut5Bit lvdsC
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(lvdsCData),
    .lvdsOutputP(TmdsOutChCP),
    .lvdsOutputN(TmdsOutChCN)
);

endmodule