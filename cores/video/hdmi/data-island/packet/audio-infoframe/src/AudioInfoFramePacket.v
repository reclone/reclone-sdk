//
// AudioInfoFramePacket - Information about the HDMI audio stream
//
// This HDMI data island packet contains basic information about the audio stream.  The Audio
// Infoframe must be transmitted "at least once per two video fields", and must be transmitted
// "no later than one video field following the first affected non-silent audio sample".
//
// A brief summary of the interesting fields:
//      cc      Channel Count - Number of channels MINUS ONE; zero is "refer to stream header"
//      ca      Channel/Speaker Allocation - How the audio channels are mapped to speaker positions
//      lsv     Level Shift Value - For downmixing
//      lfepbl  LFE Playback Level information - Sort of a "bass boost" setting
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

module AudioInfoFramePacket
(
    input [2:0] cc,
    input [7:0] ca,
    input [3:0] lsv,
    input [1:0] lfepbl,
    
    output wire [23:0] header,
    output wire [55:0] subpacket0,
    output wire [55:0] subpacket1,
    output wire [55:0] subpacket2,
    output wire [55:0] subpacket3
);

assign header[7:0] = 8'h84;     // packet type
assign header[15:8] = 8'h01;    // version
assign header[23:16] = 8'h0A;   // length

wire [7:0] infoFrameByte1 = {5'd0, cc[2:0]};
wire [7:0] infoFrameByte4 = ca[7:0];
wire [7:0] infoFrameByte5 = {1'b0, lsv[3:0], 1'b0, lfepbl[1:0]};
wire [7:0] checksum = 8'd1 + ~(header[7:0] + header[15:8] + header[23:16] + 
                               infoFrameByte1 + infoFrameByte4 + infoFrameByte5);

assign subpacket0 = {8'd0, infoFrameByte5, infoFrameByte4, 16'd0, infoFrameByte1, checksum};
assign subpacket1 = 56'd0;
assign subpacket2 = 56'd0;
assign subpacket3 = 56'd0;

endmodule
