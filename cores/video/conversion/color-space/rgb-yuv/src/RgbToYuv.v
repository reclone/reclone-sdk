//
// RgbToYuv - Convert a pixel value from RGB888 to YUV color space, for PAL encoding
//
// https://en.wikipedia.org/wiki/YUV
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

module RgbToYuv
(
    input wire[7:0] r,
    input wire[7:0] g,
    input wire[7:0] b,
    
    output wire[7:0] y,
    output wire[8:0] u, /*signed*/
    output wire[8:0] v  /*signed*/
);

/* verilator lint_off UNUSED */

// Y = 0.299*R + 0.587*G + 0.114*B
wire [31:0] rAddendOfY = (24'd5016388 * r);
wire [31:0] gAddendOfY = (24'd9848226 * g);
wire [31:0] bAddendOfY = (24'd1912603 * b);
wire [31:0] ySum = (rAddendOfY + gAddendOfY + bAddendOfY + 32'h800000);

// U = -0.147*R - 0.289*G + 0.436*B
wire [31:0] rSubtrahendOfU = (24'd1233125 * r);
wire [31:0] gSubtrahendOfU = (24'd2424308 * g);
wire [31:0] bAddendOfU = (24'd3657433 * b);
wire [31:0] uSum = (-rSubtrahendOfU - gSubtrahendOfU + bAddendOfU + 32'h400000);

// V = 0.615*R - 0.515*G - 0.100*B
wire [31:0] rAddendOfV = (24'd5158994 * r);
wire [31:0] gSubtrahendOfV = (24'd4320133 * g);
wire [31:0] bSubtrahendOfV = (24'd838861 * b);
wire [31:0] vSum = (rAddendOfV - gSubtrahendOfV - bSubtrahendOfV + 32'h400000);

/* verilator lint_on UNUSED */

assign y = ySum[31:24];
assign u = uSum[31:23];
assign v = vSum[31:23];

endmodule
