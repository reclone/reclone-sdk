//
// VBlankDataIsland - Output Infoframes and other infrequent packets during vertical blanking
//
// These HDMI data island packets are sent once per video field, during vertical blanking:
//
//  General Control             AV Mute and deep color control
//                              Must be sent near start of vertical blanking
//
//  Audio Infoframe             Describes format of the audio stream being sent in sample packets
//                              Must be sent at least once per two video fields
//
//  AVI Infoframe               Specifies video format and color space
//                              Must be sent at least once per two video fields
//
//  SPD Infoframe               Describes vendor, model, and category of the source device
//                              Sent at least once per second
//
//  Audio Content Protection    Specifies what type of audio copy protection is employed (if any)
//                              Must be sent at least every 300ms if audio protection is being used
//
// This module watches the vertical sync and horizontal sync signals to determine when to send
// a data island during vertical blanking.  Once VSync is active, the module waits for an active
// edge of HSync, delays until HBlankDataIsland is done sending, then starts sending a data island.
// After the active edge of VSync, one data island packet will get sent per line until all required
// packets are sent.
//
// The dataIslandActive signal is asserted when a data island is being transmitted, to tell
// the encoder that it should send a data island period instead of a control period.
//
// The VBlankDataIsland must wait until HSync is inactive, to avoid potential timing conflicts
// with HBlankDataIsland.
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
    input wire [6:0] videoFormatCode,
    input wire [1:0] rgbOrYCbCrCode,
    input wire [1:0] yccQuantizationRange,
    input wire [63:0] vendorName,
    input wire [127:0] productDescription,
    input wire [7:0] sourceDeviceInformation,
    
    output reg dataIslandActive = 1'b0,
    output reg [9:0] channel0 = 10'd0,
    output reg [9:0] channel1 = 10'd0,
    output reg [9:0] channel2 = 10'd0
);

localparam NUM_VBLANK_ISLANDS = 3'd5;
localparam [7:0] PREAMBLE_START = 8'd100;
localparam [7:0] LEADING_GUARD_BAND_START = PREAMBLE_START + 8'd8;
localparam [7:0] PACKET_START = LEADING_GUARD_BAND_START + 8'd2;
localparam [7:0] TRAILING_GUARD_BAND_START = PACKET_START + 8'd32;
localparam [7:0] ISLAND_FINISHED = TRAILING_GUARD_BAND_START + 8'd2;

reg hSyncArmed = 1'b0;
reg vSyncLatched = 1'b0;

reg [2:0] packetCount = 3'd0;

reg [7:0] characterCount = ISLAND_FINISHED;

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
    .s(2'b10),
    .a(1'b1),
    .y(rgbOrYCbCrCode),
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

wire [23:0] spdHeader;
wire [55:0] spdSubpacket0;
wire [55:0] spdSubpacket1;
wire [55:0] spdSubpacket2;
wire [55:0] spdSubpacket3;
SpdInfoFramePacket spdPacket
(
    .vn(vendorName),
    .pd(productDescription),
    .sdi(sourceDeviceInformation),

    .header(spdHeader),
    .subpacket0(spdSubpacket0),
    .subpacket1(spdSubpacket1),
    .subpacket2(spdSubpacket2),
    .subpacket3(spdSubpacket3)
);

wire [23:0] gcHeader;
wire [55:0] gcSubpacket0;
wire [55:0] gcSubpacket1;
wire [55:0] gcSubpacket2;
wire [55:0] gcSubpacket3;
GeneralControlPacket gcPacket
(
    .avmute(0),
    .cd(0),
    .pp(0),
    .defaultPhase(0),

    .header(gcHeader),
    .subpacket0(gcSubpacket0),
    .subpacket1(gcSubpacket1),
    .subpacket2(gcSubpacket2),
    .subpacket3(gcSubpacket3)
);

wire [23:0] acpHeader;
wire [55:0] acpSubpacket0;
wire [55:0] acpSubpacket1;
wire [55:0] acpSubpacket2;
wire [55:0] acpSubpacket3;
AudioContentProtectionPacket acpPacket
(
    .header(acpHeader),
    .subpacket0(acpSubpacket0),
    .subpacket1(acpSubpacket1),
    .subpacket2(acpSubpacket2),
    .subpacket3(acpSubpacket3)
);

wire [3:0] ch0PacketData;
wire [3:0] ch1PacketData;
wire [3:0] ch2PacketData;
reg [23:0] serializeHeader;
reg [55:0] serializeSubpacket0;
reg [55:0] serializeSubpacket1;
reg [55:0] serializeSubpacket2;
reg [55:0] serializeSubpacket3;
DataIslandPacketSerializer serializer
(
    .clock(pixelClock),
    .isFirstPacketClock(characterCount == PACKET_START),
    .isFirstIslandPacket(1'b1),
    .hsync(hSync),
    .vsync(vSync),
    .header(serializeHeader),
    .subpacket0(serializeSubpacket0),
    .subpacket1(serializeSubpacket1),
    .subpacket2(serializeSubpacket2),
    .subpacket3(serializeSubpacket3),
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

always @ (*) begin
    // Determine which packet to serialize based on packetCount
    case (packetCount)
        3'd0 : begin
            serializeHeader = gcHeader;
            serializeSubpacket0 = gcSubpacket0;
            serializeSubpacket1 = gcSubpacket1;
            serializeSubpacket2 = gcSubpacket2;
            serializeSubpacket3 = gcSubpacket3;
        end
        3'd1 : begin
            serializeHeader = audioHeader;
            serializeSubpacket0 = audioSubpacket0;
            serializeSubpacket1 = audioSubpacket1;
            serializeSubpacket2 = audioSubpacket2;
            serializeSubpacket3 = audioSubpacket3;
        end
        3'd2 : begin
            serializeHeader = aviHeader;
            serializeSubpacket0 = aviSubpacket0;
            serializeSubpacket1 = aviSubpacket1;
            serializeSubpacket2 = aviSubpacket2;
            serializeSubpacket3 = aviSubpacket3;
        end
        3'd3 : begin
            serializeHeader = spdHeader;
            serializeSubpacket0 = spdSubpacket0;
            serializeSubpacket1 = spdSubpacket1;
            serializeSubpacket2 = spdSubpacket2;
            serializeSubpacket3 = spdSubpacket3;
        end
        3'd4 : begin
            serializeHeader = acpHeader;
            serializeSubpacket0 = acpSubpacket0;
            serializeSubpacket1 = acpSubpacket1;
            serializeSubpacket2 = acpSubpacket2;
            serializeSubpacket3 = acpSubpacket3;
        end
        default : begin
            serializeHeader = {24{1'bx}};
            serializeSubpacket0 = {56{1'bx}};
            serializeSubpacket1 = {56{1'bx}};
            serializeSubpacket2 = {56{1'bx}};
            serializeSubpacket3 = {56{1'bx}};
        end
    endcase
end

always @ (posedge pixelClock) begin
    if (vSync || vSyncLatched) begin
        // VSync is active, or was active
        
        if (!hSync) begin
            // HSync deasserted; start data island on next active edge of HSync
            hSyncArmed <= 1'b1;
        end
        
        if (vSyncLatched && (packetCount >= NUM_VBLANK_ISLANDS)) begin
            // Done sending all of the data islands
            vSyncLatched <= 1'b0;
        end else if (hSyncArmed && hSync && (packetCount < NUM_VBLANK_ISLANDS)) begin
            // HSync asserted; start data island asap by resetting characterCount
            hSyncArmed <= 1'b0;
            characterCount <= 8'd0;
            dataIslandActive <= 1'b0;
            channel0 <= 10'd0;
            channel1 <= 10'd0;
            channel2 <= 10'd0;
            if (vSync) begin
                // VSync is active
                vSyncLatched <= 1'b1;
            end
        end else if (characterCount < PREAMBLE_START) begin
            // After HSync goes active, wait PREAMBLE_START cycles before starting the preamble
            characterCount <= characterCount + 8'd1;

        // Sending a data island (including preamble and guard bands)
        end else if (characterCount < LEADING_GUARD_BAND_START) begin
            characterCount <= characterCount + 8'd1;
            // Indicate to HdmiEncoder that it should start using my channel0..2 outputs
            dataIslandActive <= 1'b1;
            // 8 characters of preamble
            channel0 <= ch0PreambleDataEncoded;
            channel1 <= ch1PreambleDataEncoded;
            channel2 <= ch2PreambleDataEncoded;
        end else if (characterCount < PACKET_START ||
                     (characterCount >= TRAILING_GUARD_BAND_START && characterCount < ISLAND_FINISHED)) begin
            characterCount <= characterCount + 8'd1;
            // Data island leading or trailing guard band - 2 characters
            channel0 <= ch0GuardBand;
            channel1 <= ch1GuardBand;
            channel2 <= ch2GuardBand;
            packetCount <= packetCount + ((characterCount == TRAILING_GUARD_BAND_START) ? 3'd1 : 3'd0);
        end else if (characterCount < TRAILING_GUARD_BAND_START) begin
            characterCount <= characterCount + 8'd1;
            // Data island packet data from serializer
            // 32 characters of packet data
            channel0 <= ch0PacketDataEncoded;
            channel1 <= ch1PacketDataEncoded;
            channel2 <= ch2PacketDataEncoded;
        end else begin
            // Indicate to HdmiEncoder that it should stop using my channel0..2 outputs
            dataIslandActive <= 1'b0;
            channel0 <= 10'd0;
            channel1 <= 10'd0;
            channel2 <= 10'd0;
        end
    end else begin
        // Not in VSync
        hSyncArmed <= 1'b0;
        vSyncLatched <= 1'b0;
        characterCount <= ISLAND_FINISHED;
        packetCount <= 3'd0;
        dataIslandActive <= 1'b0;
        channel0 <= 10'd0;
        channel1 <= 10'd0;
        channel2 <= 10'd0;
    end
end


endmodule
