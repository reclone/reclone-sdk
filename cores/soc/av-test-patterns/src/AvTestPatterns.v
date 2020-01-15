//
// AvTestPatterns - Output audio and video test patterns
//
// TODO description
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

module AvTestPatterns # (parameter COUNTER_SIZE = 8)
(
    input wire pixelClock,
    output wire blink,
    output wire[9:0] dviChannel0,
    output wire[9:0] dviChannel1,
    output wire[9:0] dviChannel2,
    output wire[9:0] dviChannelC
);

wire[COUNTER_SIZE-1:0] count;

CountUp #(.SIZE(COUNTER_SIZE)) counter
(
    .clock(pixelClock),
    .increment(1'd1),
    .load(1'd0),
    .data(25'd0),
    .reset(1'd0),
    .out(count)
);

assign blink = count[COUNTER_SIZE-1];


wire dataEnable;
wire hSync;
wire vSync;
wire [11:0] hPos;
wire [10:0] vPos;

VideoFormatTiming hd720pTiming
(
    .clock(pixelClock),
    .reset(1'b0),
    .hFrontPorch(7'd110),
    .hSyncPulse(8'd40),
    .hBackPorch(8'd220),
    .hActive(11'd1280),
    .vFrontPorch(6'd5),
    .vSyncPulse(4'd5),
    .vBackPorch(6'd20),
    .vActive(11'd720),
    .syncIsActiveLow(1'b0),
    .isInterlaced(1'b0),
    .dataEnable(dataEnable),
    .hSync(hSync),
    .vSync(vSync),
    .hPos(hPos),
    .vPos(vPos)
);

DviEncoder dvi
(
    .pixelClock(pixelClock),
    .dataEnable(dataEnable),
    .hSync(hSync),
    .vSync(vSync),
    .blue(hPos[9:2]),
    .green(vPos[7:0]),
    .red(hPos[7:0]),
    .channel0(dviChannel0),
    .channel1(dviChannel1),
    .channel2(dviChannel2),
    .channelC(dviChannelC)
);


endmodule