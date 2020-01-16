//
// NullDataIslandPacket - Placeholder packet with no data for an HDMI data island
//
// The null data packet is useful for when HDMI data islands occur on a fixed schedule, but there
// is sometimes no data ready for the scheduled packet type.
//
// For example, assume that an audio clock regeneration packet is scheduled to transmit during each
// horizontal blanking interval, but the packet should only be transmitted every 1 ms.  We can
// keep the fixed schedule, but sometimes transmit a null packet instead of the regen packet.
// This can help to simplify the system design.
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

module NullDataIslandPacket
(
    output wire [23:0] header;
    output wire [55:0] subpacket0;
    output wire [55:0] subpacket1;
    output wire [55:0] subpacket2;
    output wire [55:0] subpacket3;
);

assign header = 24'd0;
assign subpacket0 = 56'd0;
assign subpacket1 = 56'd0;
assign subpacket2 = 56'd0;
assign subpacket3 = 56'd0;

endmodule
