//
// GrayCounter - A counter that outputs Gray code sequences
//
// This is a counter, of parameterized width, such that only one bit changes at a time between
// consecutive count values.  Gray counters are useful for designing data structures (e.g. fifos)
// that can operate glitch-free in multiple different clock domains.
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

`default_nettype none

module GrayCounter #(parameter WIDTH = 4)
(
    input wire clock,
    input wire enable,
    input wire reset,
    output reg[WIDTH-1:0] grayCount = {WIDTH{1'b0}},
    output reg[WIDTH-1:0] grayCountNext = {{WIDTH-2{1'b0}}, 2'd1},
    output reg[WIDTH-1:0] grayCountNextNext = {{WIDTH-2{1'b0}}, 2'd3}
);

reg [WIDTH-1:0] binaryCount = {WIDTH{1'b0}};
wire [WIDTH-1:0] binaryCountNext = binaryCount + {{WIDTH-2{1'b0}}, 2'd1};
wire [WIDTH-1:0] binaryCountNextNext = binaryCount + {{WIDTH-2{1'b0}}, 2'd2};
wire [WIDTH-1:0] binaryCountNextNextNext = binaryCount + {{WIDTH-2{1'b0}}, 2'd3};

always @ (posedge clock) begin
    if (reset == 1'b1) begin
        binaryCount <= {WIDTH{1'b0}};
        grayCount <= {WIDTH{1'b0}};
        grayCountNext <= {{WIDTH-2{1'b0}}, 2'd1};
        grayCountNextNext <= {{WIDTH-2{1'b0}}, 2'd3};
    end else begin
        if (enable == 1'b1) begin
            binaryCount <= binaryCountNext;
            grayCount <= binaryCountNext ^ {1'b0, binaryCountNext[WIDTH-1:1]};
            grayCountNext <= binaryCountNextNext ^ {1'b0, binaryCountNextNext[WIDTH-1:1]};
            grayCountNextNext <= binaryCountNextNextNext ^ {1'b0, binaryCountNextNextNext[WIDTH-1:1]};
        end
    end
end

endmodule
