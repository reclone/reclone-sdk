//
// AudioSamplePacket - Contains zero to four audio samples and associated flags
//
// This HDMI data island packet packages audio samples along with various flags that allow the
// audio to be reproduced successfully by the sink device.  The packet has one of two layouts:
//      Layout 0    <=2 channels    <= 4 samples per packet (zero or one sample per subpacket)
//      Layout 1    <=8 channels    <= 1 sample per packet
//
// A 'present' flag indicates whether there is a sample present in the corresponding subpacket.
// A 'flat' flag indicates whether there was no useful audio data available during the sample(s)
// in the corresponding subpacket.  If 'present' or 'flat' are set, the sink should ignore the
// corresponding sample value(s).
//
// In each subpacket, "left" is considered the "first" sub-frame and is transmitted first,
// while "right" is considered the "second" sub-frame and is transmitted last.
//
// Audio sample packets also transmit frames of an IEC 60958 Channel Status block.  The frames
// are transmitted one bit per sample in the first (left channel) sub-frame, as the 'c' bit.
// The 'c' bit is duplicated in the second (right channel) sub-frame, as well.
// The 'B' flag indicates whether the a frame is the first of a 192-bit Channel Status block.
// The 'v' bit is an active-low validity flag that is always zero (valid) in this implementation.
// The 'u' bit is used to transmit user data, and is not implemented here, so it is always zero.
// The 'p' bit is an even parity flag, such that the 28-bit subframe has an even number of
// 1 and 0 bits.
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

module AudioSamplePacket
(
    input wire layout,
    input wire [3:0] present,
    input wire [3:0] flat,
    input wire [3:0] B,
    
    input wire [47:0] sample0,
    input wire [1:0] c0,
    
    input wire [47:0] sample1,
    input wire [1:0] c1,
    
    input wire [47:0] sample2,
    input wire [1:0] c2,
    
    input wire [47:0] sample3,
    input wire [1:0] c3,
    
    output wire [23:0] header,
    output wire [55:0] subpacket0,
    output wire [55:0] subpacket1,
    output wire [55:0] subpacket2,
    output wire [55:0] subpacket3
);

assign header[7:0] = 8'd2;
assign header[11:8] = present[3:0];
assign header[12] = layout;
assign header[15:13] = 3'd0;
assign header[19:16] = flat[3:0];
assign header[23:20] = B;

wire v0 = 1'b0; //~present[0];
wire [1:0] p0 = {(^sample0[47:24]) ^ v0 ^ c0[1], (^sample0[23:0]) ^ v0 ^ c0[0]};
assign subpacket0[47:0] = sample0[47:0];
assign subpacket0[48] = v0;
assign subpacket0[49] = 1'b0; //u0
assign subpacket0[50] = c0[0];
assign subpacket0[51] = p0[0];
assign subpacket0[52] = v0;
assign subpacket0[53] = 1'b0; //u0
assign subpacket0[54] = c0[1];
assign subpacket0[55] = p0[1];

wire v1 = 1'b0; //~present[1];
wire [1:0] p1 = {(^sample1[47:24]) ^ v1 ^ c1[1], (^sample1[23:0]) ^ v1 ^ c1[0]};
assign subpacket1[47:0] = sample1[47:0];
assign subpacket1[48] = v1;
assign subpacket1[49] = 1'b0; //u1
assign subpacket1[50] = c1[0];
assign subpacket1[51] = p1[0];
assign subpacket1[52] = v1;
assign subpacket1[53] = 1'b0; //u1
assign subpacket1[54] = c1[1];
assign subpacket1[55] = p1[1];

wire v2 = 1'b0; //~present[2];
wire [1:0] p2 = {(^sample2[47:24]) ^ v2 ^ c2[1], (^sample2[23:0]) ^ v2 ^ c2[0]};
assign subpacket2[47:0] = sample2[47:0];
assign subpacket2[48] = v2;
assign subpacket2[49] = 1'b0; //u2
assign subpacket2[50] = c2[0];
assign subpacket2[51] = p2[0];
assign subpacket2[52] = v2;
assign subpacket2[53] = 1'b0; //u2
assign subpacket2[54] = c2[1];
assign subpacket2[55] = p2[1];

wire v3 = 1'b0; //~present[3];
wire [1:0] p3 = {(^sample3[47:24]) ^ v3 ^ c3[1], (^sample3[23:0]) ^ v3 ^ c3[0]};
assign subpacket3[47:0] = sample3[47:0];
assign subpacket3[48] = v3;
assign subpacket3[49] = 1'b0; //u3
assign subpacket3[50] = c3[0];
assign subpacket3[51] = p3[0];
assign subpacket3[52] = v3;
assign subpacket3[53] = 1'b0; //u3
assign subpacket3[54] = c3[1];
assign subpacket3[55] = p3[1];


endmodule
