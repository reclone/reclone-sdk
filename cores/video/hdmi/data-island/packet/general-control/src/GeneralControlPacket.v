//
// GeneralControlPacket - Flags for AV mute and deep color pixel packing
//
// This HDMI data island packet is sent by the source to periodically inform the sink of the
// audio/video mute state, the color depth, and pixel packing phase.
//
// The packet sends these values:
//
//      avmute  1 if the audio and/or video should be muted, or 0 for unmuted.  If supported by
//              the sink device, it will mute the audio and/or blank the video until unmuted.
//              This is useful to suppress artifacts while the pixel clock rate is changed, etc.
//
//      cd      Color Depth - specifies the number of bits per pixel, if deep color is used.
//              Set to zero if deep color is not supported by the source.
//
//      pp      Pixel Packing Phase - phase of the last transmitted packed pixel, if deep color
//              is being used.  This should be zero if cd is zero.
//
// defaultPhase 1 if the phase of the first pixel of each active video period is phase zero, or
//              0 if the pp bits and the phase of the first active pixel varies.
//
// Each of the four subpackets contain the same data.
//
// This implementation of General Control Packet either sets or clears AVMUTE each and every time.
// This packet, therefore, must be sent within 384 pixels of the active edge of VSync.
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

module GeneralControlPacket
(
    input wire avmute,
    input wire [3:0] cd,
    input wire [3:0] pp,
    input wire defaultPhase,
    
    output wire [23:0] header,
    output wire [55:0] subpacket0,
    output wire [55:0] subpacket1,
    output wire [55:0] subpacket2,
    output wire [55:0] subpacket3
);

assign header = 24'd3; // General Control Packet

wire [55:0] subpacket;
assign subpacket0 = subpacket;
assign subpacket1 = subpacket;
assign subpacket2 = subpacket;
assign subpacket3 = subpacket;

// Transmitted most significant byte first, least significant bit first
assign subpacket[7:0] = {3'd0, ~avmute, 3'd0, avmute};
assign subpacket[15:8] = {pp, cd};
assign subpacket[23:16] = {7'd0, defaultPhase};
assign subpacket[55:24] = 32'd0;

endmodule

