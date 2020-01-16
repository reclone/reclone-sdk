//
// AudioClockRegenPacket - Information needed to regenerate the audio clock from the video clock
//
// This HDMI data island packet, calculated by the source device, tells the sink (receiver) device
// how it can derive the audio clock from the video pixel clock.
//
// If f_s is the audio sample frequency, and f_tmdsclk is the transmitted video pixel clock, then
// the relationship between the two clocks is:
//      128 * f_s = f_tmdsclk * N / CTS
//
// The packet sends two values, N and CTS:
//
//      N       Fixed clock divider used to generate an intermediate clock that is slower than
//              128*f_s by a factor of N.  Audio clock regen packets are transmitted at
//              this rate of 128 * f_s / N.
//              Required:  128 * f_s / 1500Hz <= N <= 128 * f_s / 300Hz
//              Optimally: 128 * f_s / N == 1kHz
//              Example: For f_s = 48 kHz, N = 128 * 48kHz / 1kHz = 6144
//
//      CTS     Cycle Time Stamp value that is normally determined by counting the number of TMDS
//              clocks in each of the 128 * f_s / N clocks.  However, if the audio sample rate is
//              reliable and well-known, the design could cheat and transmit a constant CTS value.
//              Example: For N = 6144, f_s = 48 kHz, and f_tmdsclk = 74.25 MHz, expect
//                       CTS = 74.25 MHz * 6144 / 128 / 48 kHz = 74250
//
// Each of the four subpackets contain the same N and CTS data.
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

module AudioClockRegenPacket
(
    input wire [19:0] n,
    input wire [19:0] cts,
    output wire [23:0] header,
    output wire [55:0] subpacket0,
    output wire [55:0] subpacket1,
    output wire [55:0] subpacket2,
    output wire [55:0] subpacket3
);

assign header = 24'd1; // Audio Clock Regeneration Packet

wire [55:0] subpacket;
assign subpacket0 = subpacket;
assign subpacket1 = subpacket;
assign subpacket2 = subpacket;
assign subpacket3 = subpacket;

// Transmitted most significant byte first, least significant bit first
assign subpacket[7:0] = 8'd0;
assign subpacket[15:8] = {4'd0, cts[19:16]};
assign subpacket[23:16] = cts[15:8];
assign subpacket[31:24] = cts[7:0];
assign subpacket[39:32] = {4'd0, n[19:16]};
assign subpacket[47:40] = n[15:8];
assign subpacket[55:48] = n[7:0];

endmodule

