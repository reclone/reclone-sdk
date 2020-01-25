//
// RgbToYiq - Convert a pixel value from RGB888 to YIQ color space, for NTSC encoding
//
//
// https://www.eembc.org/techlit/datasheets/yiq_consumer.pdf
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

module RgbToYiq
(
    input wire[7:0] r,
    input wire[7:0] g,
    input wire[7:0] b,
    
    output wire[7:0] y//,
    //output wire[7:0] i,
    //output wire[7:0] q
);

// Y = 0.299*R + 0.587*G + 0.114*B
/* verilator lint_off UNUSED */
wire [15:0] rAddendOfY = ( 8'd77 * r) + 16'd128;
wire [15:0] gAddendOfY = (8'd150 * g) + 16'd128;
wire [15:0] bAddendOfY = ( 8'd29 * b) + 16'd128;
/* verilator lint_on UNUSED */

assign y = rAddendOfY[15:8] + gAddendOfY[15:8] + bAddendOfY[15:8];

endmodule
