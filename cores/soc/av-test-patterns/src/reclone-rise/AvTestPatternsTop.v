//
// reclone-rise/AvTestPatternsTop - Top module for audio/video test patterns targeting Reclone Rise
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

module AvTestPatternsTop
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
   output wire TmdsOutChCN
);

wire hdmiPixelClock;
wire hdmiDataLoadClock;
wire hdmiIoClock;
wire hdmiSerDesStrobe;

assign GPIO28 = 1'b1;

ClockGen clkGen
(
    .clk10m(CLK10M),
    .audioClock(),
    .hdmiPixelClock(hdmiPixelClock),
    .hdmiDataLoadClock(hdmiDataLoadClock),
    .hdmiIoClock(hdmiIoClock),
    .hdmiSerDesStrobe(hdmiSerDesStrobe)
);

AvTestPatterns #(.COUNTER_SIZE(25)) blinky
(
    .pixelClock(hdmiPixelClock),
    .blink(GPIO29)
);

LvdsOut5Bit lvds0
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(/*TODO*/ 5'd0),
    .lvdsOutputP(TmdsOutCh0P),
    .lvdsOutputN(TmdsOutCh0N)
);

LvdsOut5Bit lvds1
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(/*TODO*/ 5'd0),
    .lvdsOutputP(TmdsOutCh1P),
    .lvdsOutputN(TmdsOutCh1N)
);

LvdsOut5Bit lvds2
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(/*TODO*/ 5'd0),
    .lvdsOutputP(TmdsOutCh2P),
    .lvdsOutputN(TmdsOutCh2N)
);

LvdsOut5Bit lvdsC
(
    .clkLoad(hdmiDataLoadClock),
    .clkOutput(hdmiIoClock),
    .loadStrobe(hdmiSerDesStrobe),
    .serialData(/*TODO*/ 5'd0),
    .lvdsOutputP(TmdsOutChCP),
    .lvdsOutputN(TmdsOutChCN)
);

endmodule