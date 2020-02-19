//
// PalTiming - Generate timing signals required for a PAL composite video output
//
//
// PAL color burst frequency: 4.43361875 MHz
// Cycle period: 1000000 us/s  /  4433618.75 cyc/s  =  225.55 ns
//
// Four pixels per color burst cycle; one pixel is one quarter of the subcarrier cycle period
// 225.55 ns/cyc  /  4 pix/cyc  =  56.387 ns/pix
//
// Line period: 64 us = 283.75 color burst cycles = 1135 pixels
// Line-blanking interval: 11.7 to 12 us = 53 color burst cycles = 212 pixels
// Front porch: 1.5 to 1.8 us => 1.579 us = 7 color burst cycles = 28 pixels
// Synchronizing pulse: 4.5 to 4.9 us = 21 color burst cycles = 84 pixels
// Breezeway: 0.9 us = 4 color burst cycles = 16 pixels
// Sub-carrier burst: 2.25+-0.23 us => 10 color burst cycles = 40 pixels
// Back porch: 53 - 7 - 21 - 4 - 10 = 11 color burst cycles = 20 pixels
// Active video: 52.04552 us = 230.75 color burst cycles = 923 pixels
// Equalizing pulse: 2.35+-0.1 us = 42 pixels (occurs twice per line)
// Field-synchronizing pulse: 27.3 us = 121 pixels (occurs twice per line)
//
// Interlaced scanning:
// Frame period: 625 horizontal lines
// Field period: 312.5 lines
// Preequalization pulses: 2.5 lines
// Vertical synch pulses: 2.5 lines
// Postequalization pulses: 2.5 lines
// Vertical retrace settling time: 17.5 lines
// Active video: 287.5 lines per field
//
// "Fake progressive" scanning:
// Frame period: 312 horizontal lines
// Preequalization pulses: 2.5 lines
// Vertical synch pulses: 2.5 lines
// Postequalization pulses: 2.5 lines
// Vertical retrace settling time: 17.5 lines
// Active video: 287 lines
//
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

module PalTiming # (parameter PHASE_BITS = 4)
(
    input wire reset,
    input wire phaseClock,
    input wire progressive,
    
    output reg [PHASE_BITS-1:0] phase = {2'h1, {(PHASE_BITS-2){1'b0}}},
    output reg blank = 1'b1,
    output reg hSync = 1'b0,
    output reg vSync = 1'b0,
    output reg sync = 1'b0,
    output reg burst = 1'b0,
    output reg [9:0] hPos = 10'd0,
    output reg [9:0] vPos = 10'd0
);



endmodule