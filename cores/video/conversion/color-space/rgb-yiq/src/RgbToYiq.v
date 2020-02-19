//
// RgbToYiq - Convert a pixel value from RGB888 to YIQ color space, for NTSC encoding
//
// https://www.eembc.org/techlit/datasheets/yiq_consumer.pdf
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

module RgbToYiq
(
    input wire[7:0] r,
    input wire[7:0] g,
    input wire[7:0] b,
    
    output wire[7:0] y,
    output wire signed[8:0] i,
    output wire signed[8:0] q
);

/* verilator lint_off UNUSED */

// Y = 0.299*R + 0.587*G + 0.114*B
wire [31:0] rAddendOfY = (24'd5016388 * r);
wire [31:0] gAddendOfY = (24'd9848226 * g);
wire [31:0] bAddendOfY = (24'd1912603 * b);
wire [31:0] ySum = (rAddendOfY + gAddendOfY + bAddendOfY + 32'h800000);

// I = 0.596*R – 0.275*G – 0.321*B
wire [31:0] rAddendOfI = (24'd4999610 * r);
wire [31:0] gSubtrahendOfI = (24'd2306867 * g);
wire [31:0] bSubtrahendOfI = (24'd2692743 * b);
wire signed[31:0] iSum = (rAddendOfI - gSubtrahendOfI - bSubtrahendOfI + 32'h400000);

// Q = 0.212*R – 0.523*G + 0.311*B 
wire [31:0] rAddendOfQ = (24'd1778385 * r);
wire [31:0] gSubtrahendOfQ = (24'd4387242 * g);
wire [31:0] bAddendOfQ = (24'd2608857 * b);
wire signed[31:0] qSum = (rAddendOfQ - gSubtrahendOfQ + bAddendOfQ + 32'h400000);

/* verilator lint_on UNUSED */

assign y = ySum[31:24];
assign i = iSum[31:23];
assign q = qSum[31:23];

endmodule
