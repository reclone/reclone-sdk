//
// reclone-rise/BlinkyTop - Top module for the very simple Blinky SoC targeting Reclone Rise
//
// This is a target-specific module for a specific board, the Reclone Rise.
// Top modules like this should generally be a very basic "wiring-up" of common modules to the
// specific I/O pins and resources of the target platform (FPGA and the board on which it resides).
// HDL code that is common to all targets should be placed in common locations (e.g. soc/blinky/src).
//
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

module BlinkyTop
(
    input wire CLK10M,
    input wire GPIO28,
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

wire audioClock;

assign GPIO28 = 1'b1;
assign VideoDac = 5'bzzzzz;
assign AudioDacLeft = 1'bz;
assign AudioDacRight = 1'bz;

Blinky #(.COUNTER_SIZE(27)) blinky
(
    .clock(audioClock),
    .blink(GPIO29)
);

ClockGen clkGen
(
    .clk10m(CLK10M),
    .audioClock(audioClock)
);

OBUFDS lvds0(.I(1'b0),.O(TmdsOutCh0P),.OB(TmdsOutCh0N));
OBUFDS lvds1(.I(1'b0),.O(TmdsOutCh1P),.OB(TmdsOutCh1N));
OBUFDS lvds2(.I(1'b0),.O(TmdsOutCh2P),.OB(TmdsOutCh2N));
OBUFDS lvdsC(.I(1'b0),.O(TmdsOutChCP),.OB(TmdsOutChCN));

endmodule