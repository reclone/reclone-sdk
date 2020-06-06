//
// SpdInfoFramePacket - Source Product Description (SPD) InfoFrame packet for HDMI
//
// This HDMI data island packet contains a description of an HDMI source device.  The description
// can be displayed as a hint for the end-user when selecting sources in a television or receiver.
//
// The SPD InfoFrame has the following fields:
//      vn  Vendor Name                 Company whose name appears on the product
//      pd  Product Description         Model number of the product and/or a short description
//      sdi Source Device Information   Classification of source device
//                                          8'h00   unknown
//                                          8'h01   Digital STB
//                                          8'h02   DVD Player
//                                          8'h03   D-VHS
//                                          8'h04   HDD Videorecorder
//                                          8'h05   DVC
//                                          8'h06   DSC
//                                          8'h07   Video CD
//                                          8'h08   Game
//                                          8'h09   PC general
//                                          8'h0A   Blu-Ray Disc (BD)
//                                          8'h0B   Super Audio CD
//                                          8'h0C-8'hFF   Reserved
//
// Vendor Name and Product Description are 7-bit ASCII characters, left justified, with unused
// character positions populated with null (8'h00) bytes.
//
// It is recommended to transmit the SPD Infoframe once per second, but it can be transmitted
// as frequently as once per video field.
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

module SpdInfoFramePacket
(
    input wire [63:0] vn,
    input wire [127:0] pd,
    input wire [7:0] sdi,
    
    output wire [23:0] header,
    output wire [55:0] subpacket0,
    output wire [55:0] subpacket1,
    output wire [55:0] subpacket2,
    output wire [55:0] subpacket3
);

assign header[7:0] = 8'h83;     // packet type
assign header[15:8] = 8'h01;    // version
assign header[23:16] = 8'd25;   // length

// This is a long sum expression, but it should get optimized to a constant value
// if constant vn, pd, and sdi are used.
wire [7:0] checksum = 8'd1 + ~(header[7:0] + header[15:8] + header[23:16] + 
                               vn[63:56] + vn[55:48] + vn[47:40] + vn[39:32] +
                               vn[31:24] + vn[23:16] + vn[15:8] + vn[7:0] +
                               pd[127:120] + pd[119:112] + pd[111:104] + pd[103:96] +
                               pd[95:88] + pd[87:80] + pd[79:72] + pd[71:64] +
                               pd[63:56] + pd[55:48] + pd[47:40] + pd[39:32] +
                               pd[31:24] + pd[23:16] + pd[15:8] + pd[7:0] +
                               sdi);

assign subpacket0 = {vn[23:16], vn[31:24], vn[39:32], vn[47:40],
                     vn[55:48], vn[63:56], checksum};
assign subpacket1 = {pd[95:88], pd[103:96], pd[111:104], pd[119:112],
                     pd[127:120], vn[7:0], vn[15:8]};
assign subpacket2 = {pd[39:32], pd[47:40], pd[55:48], pd[63:56],
                     pd[71:64], pd[79:72], pd[87:80]};
assign subpacket3 = {8'd0, 8'd0, sdi, pd[7:0], pd[15:8], pd[23:16], pd[31:24]};

endmodule
