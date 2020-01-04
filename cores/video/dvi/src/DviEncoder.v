//
// DviEncoder - Encode a VGA-style video signal into DVI-D words suitable for output serialization
//
// This encoder takes a video signal (red, green, blue, hsync, vsync, data enable, pixel clock)
// and outputs 10-bit words.  During an active video region (dataEnable==1), the red, green, and
// blue values are encoded using a transition-minimized differential signalling (TMDS) algorithm,
// converting each 8-bit color component to 10 transition minimized and DC-balanced bits.  During
// a blanking region (dataEnable==0), 2-bit words (hsync and vsync values and control constants)
// are encoded to 10 bits using a transition-maximized signalling.
//
// The 10 output bits for each LVDS channel are typically serialized and transmitted on a
// pair of differential output pins.  This serialization and differential signalling is
// hardware-specific (depends on the selected FPGA), therefore it is not included this
// common module.
//
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

module DviEncoder
(
    input wire pixelClock,
    input wire dataEnable,
    input wire hSync,
    input wire vSync,
    input wire[7:0] blue,
    input wire[7:0] green,
    input wire[7:0] red,
    output reg[9:0] channel0,
    output reg[9:0] channel1,
    output reg[9:0] channel2,
    output wire[9:0] channelC
);

wire[9:0] ctlChannel0Out;
wire[9:0] ctlChannel1Out;
wire[9:0] ctlChannel2Out;

wire[9:0] rgbChannel0Out;
wire[9:0] rgbChannel1Out;
wire[9:0] rgbChannel2Out;

assign channelC = 10'b1111100000;

RgbEncoder8to10 rgbChannel0
(
    .clock(pixelClock),
    .reset(~dataEnable),
    .d(blue),
    .q(rgbChannel0Out)
);

RgbEncoder8to10 rgbChannel1
(
    .clock(pixelClock),
    .reset(~dataEnable),
    .d(green),
    .q(rgbChannel1Out)
);

RgbEncoder8to10 rgbChannel2
(
    .clock(pixelClock),
    .reset(~dataEnable),
    .d(red),
    .q(rgbChannel2Out)
);

CtlEncoder2to10 ctlChannel0
(
    .d({vSync, hSync}),
    .q(ctlChannel0Out)
);

CtlEncoder2to10 ctlChannel1
(
    .d(2'd0),
    .q(ctlChannel1Out)
);

CtlEncoder2to10 ctlChannel2
(
    .d(2'd0),
    .q(ctlChannel2Out)
);

always @ (posedge pixelClock) begin
    if (dataEnable == 1'b1) begin
        channel0 <= rgbChannel0Out;
        channel1 <= rgbChannel1Out;
        channel2 <= rgbChannel2Out;
    end else begin
        channel0 <= ctlChannel0Out;
        channel1 <= ctlChannel1Out;
        channel2 <= ctlChannel2Out;
    end
end

endmodule
