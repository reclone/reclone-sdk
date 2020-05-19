//
// Terc4Encoder4to10 - Serialize four HDMI data island bits into TMDS Error Reduction Coding (TERC4)
//
// This encoding is used during HDMI data island periods to convey data island packets.
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

module Terc4Encoder4to10
(
    input wire [3:0] d,
    output reg [9:0] q
);

always @ (d)
begin
    case(d)
        4'b0000: q = 10'b1010011100;
        4'b0001: q = 10'b1001100011;
        4'b0010: q = 10'b1011100100;
        4'b0011: q = 10'b1011100010;
        4'b0100: q = 10'b0101110001;
        4'b0101: q = 10'b0100011110;
        4'b0110: q = 10'b0110001110;
        4'b0111: q = 10'b0100111100;
        4'b1000: q = 10'b1011001100;
        4'b1001: q = 10'b0100111001;
        4'b1010: q = 10'b0110011100;
        4'b1011: q = 10'b1011000110;
        4'b1100: q = 10'b1010001110;
        4'b1101: q = 10'b1001110001;
        4'b1110: q = 10'b0101100011;
        4'b1111: q = 10'b1011000011;
    endcase
end

endmodule