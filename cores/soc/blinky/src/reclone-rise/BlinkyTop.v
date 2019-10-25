//
// reclone-rise/BlinkyTop - Top module for the very simple Blinky SoC targeting Reclone Rise
//
// The Blinky system-on-chip is intended to be an extremely simple example of using the 
// Reclone SDK to build an FPGA design.  Blinky takes a system clock as input, supplies it to a
// free-running counter, and outputs one of the counter's high bits for a human-visible blinking
// pattern, suitable for observation using a multimeter or an LED.  This can be used as an
// indicator that the FPGA can be properly configured.
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
   input CLK10M,
   input GPIO28,
   output GPIO29
);

wire[24:0] count;

assign GPIO29 = count[24];

CountUp #(.SIZE(25)) counter
(
    .clock(CLK10M),
    .increment(1'd1),
    .load(1'd0),
    .data(25'd0),
    .reset(1'd0),
    .out(count)
);

endmodule