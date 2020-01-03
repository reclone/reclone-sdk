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
// differential pair of output pins.  This serialization and differential signalling is
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
    output reg[9:0] channelC
);


endmodule
