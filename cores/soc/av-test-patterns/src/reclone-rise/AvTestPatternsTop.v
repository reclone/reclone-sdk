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

module AvTestPatternsTop
(
   input  CLK10M,
   output GPIO28,
   output GPIO29
);

wire audioClock;

AvTestPatterns #(.COUNTER_SIZE(25)) blinky
(
    .clock(CLK10M),
    .blink(GPIO29)
);

ClockGen clkGen
(
    .clk10m(CLK10M),
    .audioClock(audioClock)
);

// Clock forwarding technique to output the clock
ODDR2 #(
.DDR_ALIGNMENT("NONE"),
.INIT(1'b0),
.SRTYPE("SYNC")
) ODDR2_inst (
.Q(GPIO28), // 1-bit DDR output data
.C0(audioClock), // 1-bit clock input
.C1(~audioClock), // 1-bit clock input
.CE(1'b1), // 1-bit clock enable input
.D0(1'b1), // 1-bit data input (associated with C0)
.D1(1'b0), // 1-bit data input (associated with C1)
.R(1'b0), // 1-bit reset input
.S(1'b0) // 1-bit set input
);

endmodule