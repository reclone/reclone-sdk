//
// BchEccSingleBitEncoder - Calculate the running BCH ECC for an HDMI data island packet header
//
// HDMI data island packet headers transmit one bit per pixel clock.  Provide the pixel clock as
// input to this module.
// 
// This module is designed to be used in steps:
//  1. Provide the 24 header data bits on "data" in transmission order (LSbit first).
//     On the first data bit of the header, assert "isFirstDataBit" high (1'b1).
//  2. After the 24 header data bits are finished transmitting, hold the "data" input low (1'b0).
//     The next 8 "ecc" bits are the parity bits to be transmitted at the end of the header.
//  3. On the first bit of the next header, goto step 1.
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

module BchEccSingleBitEncoder
(
    input wire clock,
    input wire data,
    input wire isFirstDataClock,

    output wire ecc
);

reg [7:0] eccByte = 8'h00;
wire [7:0] eccNext;

assign ecc = eccByte[0];

BchEccStep bch
(
    .data(data),
    .ecc(isFirstDataClock ? 8'h00 : eccByte),
    .eccNext(eccNext)
);

always @ (posedge clock) begin
    eccByte <= eccNext;
end

endmodule
