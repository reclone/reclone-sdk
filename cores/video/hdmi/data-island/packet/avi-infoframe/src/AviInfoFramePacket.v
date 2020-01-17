//
// AviInfoFramePacket - Auxiliary information about the HDMI video stream
//
// This HDMI data island packet contains auxiliary information about the video stream.
// The Auxiliary Video Information (AVI) InfoFrame is not required for RGB sources with
// default colorimetry, etc., but it is recommended to be sent even when not required.
// AVI InfoFrame must be transmitted "at least once per two video fields".
//
// A brief summary of the interesting fields in the packet:
//      s   Scan Information            Set to 2'b10 - content composed for underscanned display
//      b   Bar Info Data Valid         Forced to zero; rarely useful, keeps checksum simpler
//      a   Active Video Info Present   Indicates whether Active Format (r) is valid
//      y   RGB or YCbCr                2'b00=RGB (default); 2'b1=YCbCr 4:2:2; 2'b2=YCbCr 4:4:4
//      r   Active Format Aspect Ratio  Specifies active video aspect ratio (vs. picture)
//      m   Picture Aspect Ratio        2'b00=No data; 2'b01=4:3; 2'b10=16:9
//      c   Colorimetry                 2'b00=No data; 2'b01=ITU601; 2'b10=ITU709; 2'b11=ec valid
//      sc  Non-Uniform Picture Scaling 2'b00=No known; 2'b01=horiz; 2'b10=vert; 2'b11=both
//      q   Quantization Range          2'b00=Default; 2'b01=Limited; 2'b10=Full
//      ec  Extended Colorimetry        3'b000=xvYCC_601; 3'b001=xvYCC_709
//      itc IT content                  1'b0=No data; 1'b1=IT content
//      vic Video Identification Code   7'd4=720p60; 7'd5=1080i60; etc. from CEA-861-D table 3
//      pr  Pixel Repetition Factor     4'd0=No repetition; otherwise repetition factor - 1
//      cn  Content Type                2'b00=Graphics/No data; 2'b01=Photo; 2'b10=Cinema; 2'b11=Game
//      yq  YCC Quantization Range      2'b00=Limited Range; 2'b01=Full Range
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

module AviInfoFramePacket
(
    input wire [1:0] s,
    input wire a,
    input wire [1:0] y,
    input wire [3:0] r,
    input wire [1:0] m,
    input wire [1:0] c,
    input wire [1:0] sc,
    input wire [1:0] q,
    input wire [2:0] ec,
    input wire itc,
    input wire [6:0] vic,
    input wire [3:0] pr,
    input wire [1:0] cn,
    input wire [1:0] yq,
    
    output wire [23:0] header,
    output wire [55:0] subpacket0,
    output wire [55:0] subpacket1,
    output wire [55:0] subpacket2,
    output wire [55:0] subpacket3
);

assign header[7:0] = 8'h82;     // packet type
assign header[15:8] = 8'h02;    // version
assign header[23:16] = 8'h0D;   // length

wire [1:0] b = 2'd0;

wire [7:0] infoFrameByte1 = {1'b0, y, a, b, s};
wire [7:0] infoFrameByte2 = {c, m, r};
wire [7:0] infoFrameByte3 = {itc, ec, q, sc};
wire [7:0] infoFrameByte4 = {1'b0, vic};
wire [7:0] infoFrameByte5 = {yq, cn, pr};

wire [7:0] checksum = 8'd1 + ~(header[7:0] + header[15:8] + header[23:16] + 
                               infoFrameByte1 + infoFrameByte2 + infoFrameByte3 +
                               infoFrameByte4 + infoFrameByte5);

assign subpacket0 = {8'd0, infoFrameByte5, infoFrameByte4, infoFrameByte3,
                     infoFrameByte2, infoFrameByte1, checksum};
assign subpacket1 = 56'd0;
assign subpacket2 = 56'd0;
assign subpacket3 = 56'd0;

endmodule
