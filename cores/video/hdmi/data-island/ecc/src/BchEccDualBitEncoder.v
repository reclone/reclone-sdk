//
// BchEccDualBitEncoder - Calculate the running BCH ECC for an HDMI data island subpacket
//
// HDMI data island subpackets transmit two bits per pixel clock.  Provide the pixel clock as
// input to this module.
// 
// This module is designed to be used in steps:
//  1. Provide the 56 subpacket bits on "data" in transmission order (LSbit first).
//     On the first clock of the subpacket, assert "isFirstDataClock" high (1'b1).
//  2. After the 28 data clocks are finished, hold the "data" input low (2'b00).
//     The next 4 "ecc" words are the parity bits to be transmitted at the end of the subpacket.
//  3. On the first bit of the next subpacket, goto step 1.
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

module BchEccDualBitEncoder
(
    input wire clock,
    input wire [1:0] data,
    input wire isFirstDataClock,

    output wire [1:0] ecc
);

reg [7:0] eccByte = 8'h00;
reg eccStage = 1'b0;
wire [7:0] eccNext;
wire [7:0] eccNextNext;

assign ecc = {eccByte[0], eccStage}; //TODO is this order correct?

BchEccStep bchFirst
(
    .data(data[0]),
    .ecc(isFirstDataClock ? 8'h00 : eccByte),
    .eccNext(eccNext)
);

BchEccStep bchSecond
(
    .data(data[1]),
    .ecc(eccNext),
    .eccNext(eccNextNext)
);

always @ (posedge clock) begin
    eccByte <= eccNextNext;
    eccStage <= eccNext[0];
end

endmodule
