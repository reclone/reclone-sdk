//
// VBlankDataIsland - Output AVI Infoframe and Audio Infoframe packets during vertical blanking
//
// The HDMI standard requires a source to transmit the AVI Infoframe and Audio Infoframe packets
// at least once per two video fields.  These packets tell the HDMI sink device how to handle
// the active video data and audio sample data, accordingly.
//
// This module watches the vertical sync and horizontal sync signals to determine when to send
// a data island during vertical blanking.  If VSync is active, the module waits for an inactive
// edge of HSync, then starts sending a data island.  On even lines, it will send an
// AVI Infoframe data island, whereas on odd lines it will send an Audio Infoframe data island.
//
// The dataIslandActive signal is asserted when a data island is being transmitted, to tell
// the encoder that it should send a data island period instead of a control period.
//
// The VBlankDataIsland must wait until HSync is inactive, to avoid potential timing conflicts
// with HBlankDataIsland.
//
// Because all supported timings include at least two VSync lines, we are guaranteed that each
// type of Infoframe will get sent at least once for each video field.
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

module VBlankDataIsland
(
    input wire pixelClock,
    input wire hSync,
    input wire vSync,
    input wire syncIsActiveLow,
    input wire [6:0] videoFormatCode,
    input wire [1:0] rgbOrYuvCode,
    input wire [1:0] yccQuantizationRange,
    
    output reg dataIslandActive = 1'b0,
    output reg [9:0] channel0 = 10'd0,
    output reg [9:0] channel1 = 10'd0,
    output reg [9:0] channel2 = 10'd0
);

reg hSyncLatched = 1'b0;

reg isFirstPacketClock = 1'b0;

reg [1:0] packetCount = 2'd0;
wire oddLine = packetCount[0];

reg [6:0] characterCount = 7'd0;

wire [9:0] ch0GuardBand;
Terc4Encoder4to10 ch0GuardBandEncoder
(
    .d({2'b11, vSync, hSync}),
    .q(ch0GuardBand)
);


wire [23:0] aviHeader;
wire [55:0] aviSubpacket0;
wire [55:0] aviSubpacket1;
wire [55:0] aviSubpacket2;
wire [55:0] aviSubpacket3;
AviInfoFramePacket aviPacket
(
    .s(2'b00),
    .a(1'b0),
    .y(rgbOrYuvCode),
    .r(4'b1000),
    .m(2'b10),
    .c(2'b00),
    .sc(2'b00),
    .q(2'b00),
    .ec(3'b000),
    .itc(1'b0),
    .vic(videoFormatCode),
    .pr(4'b0000),
    .cn(2'b00),
    .yq(yccQuantizationRange),

    .header(aviHeader),
    .subpacket0(aviSubpacket0),
    .subpacket1(aviSubpacket1),
    .subpacket2(aviSubpacket2),
    .subpacket3(aviSubpacket3)
);

wire [23:0] audioHeader;
wire [55:0] audioSubpacket0;
wire [55:0] audioSubpacket1;
wire [55:0] audioSubpacket2;
wire [55:0] audioSubpacket3;
AudioInfoFramePacket audioPacket
(
    .cc(3'd1),
    .ca(8'd0),
    .lsv(4'd0),
    .lfepbl(2'd0),

    .header(audioHeader),
    .subpacket0(audioSubpacket0),
    .subpacket1(audioSubpacket1),
    .subpacket2(audioSubpacket2),
    .subpacket3(audioSubpacket3)
);

wire [3:0] ch0PacketData;
wire [3:0] ch1PacketData;
wire [3:0] ch2PacketData;
DataIslandPacketSerializer serializer
(
    .clock(pixelClock),
    .isFirstPacketClock(isFirstPacketClock),
    .hsync(hSync),
    .vsync(vSync),
    .header(oddLine ? audioHeader : aviHeader),
    .subpacket0(oddLine ? audioSubpacket0 : aviSubpacket0),
    .subpacket1(oddLine ? audioSubpacket1 : aviSubpacket1),
    .subpacket2(oddLine ? audioSubpacket2 : aviSubpacket2),
    .subpacket3(oddLine ? audioSubpacket3 : aviSubpacket3),
    /*.header(24'h000000),
    .subpacket0(56'h00000000000000),
    .subpacket1(56'h00000000000000),
    .subpacket2(56'h00000000000000),
    .subpacket3(56'h00000000000000),*/
    .terc4channel0(ch0PacketData),
    .terc4channel1(ch1PacketData),
    .terc4channel2(ch2PacketData)
);

wire [9:0] ch0PacketDataEncoded;
Terc4Encoder4to10 ch0PacketDataEncoder
(
    .d(ch0PacketData),
    .q(ch0PacketDataEncoded)
);

wire [9:0] ch1PacketDataEncoded;
Terc4Encoder4to10 ch1PacketDataEncoder
(
    .d(ch1PacketData),
    .q(ch1PacketDataEncoded)
);

wire [9:0] ch2PacketDataEncoded;
Terc4Encoder4to10 ch2PacketDataEncoder
(
    .d(ch2PacketData),
    .q(ch2PacketDataEncoded)
);

wire [9:0] ch0PreambleDataEncoded;
CtlEncoder2to10 ch0PreambleEncoder
(
    .d({vSync, hSync}),
    .q(ch0PreambleDataEncoded)
);

wire [9:0] ch1PreambleDataEncoded;
CtlEncoder2to10 ch1PreambleEncoder
(
    .d(2'b01),
    .q(ch1PreambleDataEncoded)
);

wire [9:0] ch2PreambleDataEncoded;
CtlEncoder2to10 ch2PreambleEncoder
(
    .d(2'b01),
    .q(ch2PreambleDataEncoded)
);

wire [9:0] ch1GuardBand = 10'b0100110011;
wire [9:0] ch2GuardBand = 10'b0100110011;

always @ (posedge pixelClock) begin
    if (vSync ^ syncIsActiveLow) begin
        // VSync is active
        if ((hSync ^ syncIsActiveLow) && (packetCount < 2'd1)) begin
            // HSync is active; start data island period once HSync goes inactive
            hSyncLatched <= 1'b1;
            isFirstPacketClock <= 1'b0;
            characterCount <= 7'd0;
            dataIslandActive <= 1'b0;
            channel0 <= 10'd0;
            channel1 <= 10'd0;
            channel2 <= 10'd0;
        end else if (hSyncLatched && characterCount < 7'd42) begin
            // Wait 42 clocks after hsync is released to start the preamble
            hSyncLatched <= 1'b1;
            isFirstPacketClock <= 1'b0;
            characterCount <= characterCount + 7'd1;
            dataIslandActive <= 1'b0;
            channel0 <= 10'd0;
            channel1 <= 10'd0;
            channel2 <= 10'd0;
        end else if ((hSyncLatched || dataIslandActive) && characterCount < 7'd50) begin
            // 8 characters of preamble
            hSyncLatched <= 1'b0;
            isFirstPacketClock <= 1'b0;
            characterCount <= characterCount + 7'd1;
            dataIslandActive <= 1'b1;
            channel0 <= ch0PreambleDataEncoded;
            channel1 <= ch1PreambleDataEncoded;
            channel2 <= ch2PreambleDataEncoded;
        end else if (dataIslandActive &&
                     ((characterCount < 7'd52) || ((characterCount >= 7'd84) && (characterCount < 7'd86)))) begin
            // Data island leading or trailing guard band - 2 characters
            hSyncLatched <= 1'b0;
            isFirstPacketClock <= 1'b0;
            dataIslandActive <= 1'b1;
            characterCount <= characterCount + 7'd1;
            channel0 <= ch0GuardBand;
            channel1 <= ch1GuardBand;
            channel2 <= ch2GuardBand;
        end else if (dataIslandActive && (characterCount >= 7'd52) && (characterCount < 7'd84)) begin
            // Data island packet - 32 characters
            hSyncLatched <= 1'b0;
            isFirstPacketClock <= (characterCount == 7'd52) ? 1'b1 : 1'b0;
            packetCount <= packetCount + ((characterCount == 7'd83) ? 2'd1 : 2'd0);
            dataIslandActive <= 1'b1;
            characterCount <= characterCount + 7'd1;
            channel0 <= ch0PacketDataEncoded;
            channel1 <= ch1PacketDataEncoded;
            channel2 <= ch2PacketDataEncoded;
        end else begin
            // Finished sending the data island
            hSyncLatched <= 1'b0;
            isFirstPacketClock <= 1'b0;
            characterCount <= 7'd0;
            dataIslandActive <= 1'b0;
            channel0 <= 10'd0;
            channel1 <= 10'd0;
            channel2 <= 10'd0;
        end
    end else begin
        // Not in VSync
        hSyncLatched <= 1'b0;
        isFirstPacketClock <= 1'b0;
        characterCount <= 7'd0;
        packetCount <= 2'd0;
        dataIslandActive <= 1'b0;
        channel0 <= 10'd0;
        channel1 <= 10'd0;
        channel2 <= 10'd0;
    end
end


endmodule
