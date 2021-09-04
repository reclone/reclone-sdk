//
// HBlankDataIsland - Output Audio Sample and Clock Regeneration packets during horizontal blanking
//
// Audio Sample packets contain the audio sample data.  They are transmitted at the sample rate
// specified by the Audio InfoFrame packet, using an audio clock that is generated in the sink
// device based on the Audio Clock Regeneration packet.
//
// Audio Clock Regeneration packets hold two 20-bit integers, N and CTS: (f_s is sample frequency)
//  N   - typically used in a clock divider to generate a clock slower than 128*f_s; N~=128*f_s/1000
//  CTS - Cycle Time Stamp - determined by counting the number of TMDS clocks per 128*f_s/N clock
//
// Audio Clock Regeneration packets are expected to be sent at the average rate of 128*f_s/N.
// So, assuming a 48 kHz sample rate and a 74.25 MHz TMDS clock:
//  N   = 6144
//  CTS = 74250
//  Rate of Audio Clock Regeneration packet transmission = 128*48000/6144 = 1000 Hz
//  Samples per Audio Clock Regeneration packet = 48
// Considering the horizontal line frequency ranges from 33 to 45 kHz, at least one sample is
// queued per horizontal line.
//
// This module "gets" audio samples by watching one side of a FIFO buffer.  We recommend that a
// 4-sample or larger asynchronous (multi-rate) FIFO is used, so that audio samples can get queued
// up from the audio clock domain, and then the samples get processed and sent in the HDMI pixel
// clock domain later, during horizontal blanking.
//
// This module watches the horizontal sync signal to determine when to send a data island during
// horizontal blanking.  At the beginning of HSync and prior to sending the data island, up to
// four audio sample packets are obtained from the sample FIFO and saved into packet registers
// along with bits from the channel status words.  Then, exactly two packets are sent.  The first
// packet is an Audio Sample packet that sends the saved samples and channel status data.  The
// second packet is either the Audio Clock Regeneration (ACR) packet, if we are due to send it, or
// a Null packet if ACR is not due to be sent.  In this way, audio samples always take priority.
//
// The dataIslandActive signal is asserted when a data island is being transmitted, to tell
// the encoder that it should send a data island period instead of a control period.
//
// HBlankDataIsland must take priority over VBlankDataIsland.  VBlankDataIsland must be designed
// to avoid any potential scheduling conflicts with HBlankDataIsland.
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

module HBlankDataIsland
(
    input wire pixelClock,
    input wire hSync,
    input wire vSync,
    input wire [19:0] n,
    input wire [19:0] cts,
    input wire [7:0] samplesPerRegenPacket,
    input wire [7:0] spdifCategoryCode,
    input wire [3:0] spdifSamplingFreq,
    input wire [3:0] spdifWordLength,
    
    input wire sampleFifoEmpty,
    input wire [31:0] sampleFifoReadData,
    output reg sampleFifoReadEnable = 1'b0,
    
    output reg dataIslandActive = 1'b0,
    output reg [9:0] channel0 = 10'd0,
    output reg [9:0] channel1 = 10'd0,
    output reg [9:0] channel2 = 10'd0
);

// Counter values at which to start each phase of the data island
localparam [6:0] PREAMBLE_START = 7'd16;
localparam [6:0] LEADING_GUARD_BAND_START = PREAMBLE_START + 7'd8;
localparam [6:0] SAMPLE_PACKET_START = LEADING_GUARD_BAND_START + 7'd2;
localparam [6:0] REGEN_PACKET_START = SAMPLE_PACKET_START + 7'd32;
localparam [6:0] TRAILING_GUARD_BAND_START = REGEN_PACKET_START + 7'd32;
localparam [6:0] ISLAND_FINISHED = TRAILING_GUARD_BAND_START + 7'd2;

reg hSyncArmed = 1'b0;

reg sampleAvailable = 1'b0;
reg [2:0] latchedSampleCount = 3'd0;
reg [7:0] regenSampleCount = 8'd0;
reg [34:0] latchedSamples [0:3]; //{B, cR, cL, sampleR[15:0], sampleL[15:0]}

reg [6:0] characterCount = ISLAND_FINISHED;
reg[7:0] channelStatusIndex = 8'd0;

wire[191:0] channelStatusLeftWord;
SpdifChannelStatus chnlStatusLeft
(
    .channelNum(4'd1),
    .categoryCode(spdifCategoryCode),
    .samplingFreq(spdifSamplingFreq),
    .wordLength(spdifWordLength),
    .channelStatus(channelStatusLeftWord)
);

wire[191:0] channelStatusRightWord;
SpdifChannelStatus chnlStatusRight
(
    .channelNum(4'd2),
    .categoryCode(spdifCategoryCode),
    .samplingFreq(spdifSamplingFreq),
    .wordLength(spdifWordLength),
    .channelStatus(channelStatusRightWord)
);

wire [23:0] sampleHeader;
wire [55:0] sampleSubpacket0;
wire [55:0] sampleSubpacket1;
wire [55:0] sampleSubpacket2;
wire [55:0] sampleSubpacket3;
AudioSamplePacket samplePacket
(
    .layout(1'b0),
    .present({latchedSampleCount > 3'd3, latchedSampleCount > 3'd2, latchedSampleCount > 3'd1, latchedSampleCount > 3'd0}),
    .flat(4'd0),
    .B({latchedSamples[3][34], latchedSamples[2][34], latchedSamples[1][34], latchedSamples[0][34]}),
    .sample0({latchedSamples[0][31:16], 8'd0, latchedSamples[0][15:0], 8'd0}),
    .c0({latchedSamples[0][33], latchedSamples[0][32]}),
    .sample1({latchedSamples[1][31:16], 8'd0, latchedSamples[1][15:0], 8'd0}),
    .c1({latchedSamples[1][33], latchedSamples[1][32]}),
    .sample2({latchedSamples[2][31:16], 8'd0, latchedSamples[2][15:0], 8'd0}),
    .c2({latchedSamples[2][33], latchedSamples[2][32]}),
    .sample3({latchedSamples[3][31:16], 8'd0, latchedSamples[3][15:0], 8'd0}),
    .c3({latchedSamples[3][33], latchedSamples[3][32]}),
    .header(sampleHeader),
    .subpacket0(sampleSubpacket0),
    .subpacket1(sampleSubpacket1),
    .subpacket2(sampleSubpacket2),
    .subpacket3(sampleSubpacket3)
);

wire [23:0] regenHeader;
wire [55:0] regenSubpacket0;
wire [55:0] regenSubpacket1;
wire [55:0] regenSubpacket2;
wire [55:0] regenSubpacket3;
AudioClockRegenPacket regenPacket
(
    .n(n),
    .cts(cts),
    .header(regenHeader),
    .subpacket0(regenSubpacket0),
    .subpacket1(regenSubpacket1),
    .subpacket2(regenSubpacket2),
    .subpacket3(regenSubpacket3)
);

wire regenPacketDue = (regenSampleCount >= samplesPerRegenPacket);

wire [23:0] nullHeader;
wire [55:0] nullSubpacket0;
wire [55:0] nullSubpacket1;
wire [55:0] nullSubpacket2;
wire [55:0] nullSubpacket3;
NullDataIslandPacket nullPacket
(
    .header(nullHeader),
    .subpacket0(nullSubpacket0),
    .subpacket1(nullSubpacket1),
    .subpacket2(nullSubpacket2),
    .subpacket3(nullSubpacket3)
);

wire [3:0] ch0PacketData;
wire [3:0] ch1PacketData;
wire [3:0] ch2PacketData;
wire isFirstIslandPacket = (characterCount < REGEN_PACKET_START);
DataIslandPacketSerializer serializer
(
    .clock(pixelClock),
    .isFirstPacketClock(characterCount == SAMPLE_PACKET_START || characterCount == REGEN_PACKET_START),
    .isFirstIslandPacket(isFirstIslandPacket),
    .hsync(hSync),
    .vsync(vSync),
    .header(isFirstIslandPacket ? sampleHeader : (regenPacketDue ? regenHeader : nullHeader)),
    .subpacket0(isFirstIslandPacket ? sampleSubpacket0 : (regenPacketDue ? regenSubpacket0 : nullSubpacket0)),
    .subpacket1(isFirstIslandPacket ? sampleSubpacket1 : (regenPacketDue ? regenSubpacket1 : nullSubpacket1)),
    .subpacket2(isFirstIslandPacket ? sampleSubpacket2 : (regenPacketDue ? regenSubpacket2 : nullSubpacket2)),
    .subpacket3(isFirstIslandPacket ? sampleSubpacket3 : (regenPacketDue ? regenSubpacket3 : nullSubpacket3)),
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

wire [9:0] ch0GuardBand;
Terc4Encoder4to10 ch0GuardBandEncoder
(
    .d({2'b11, vSync, hSync}),
    .q(ch0GuardBand)
);
wire [9:0] ch1GuardBand = 10'b0100110011;
wire [9:0] ch2GuardBand = 10'b0100110011;

always @ (posedge pixelClock) begin
    if (!hSync) begin
        // HSync deasserted; start data island on next active edge of HSync
        hSyncArmed <= 1'b1;
    end

    if (hSyncArmed && hSync) begin
        // HSync asserted; start data island asap by resetting characterCount
        characterCount <= 7'd0;
        dataIslandActive <= 1'b0;
        channel0 <= 10'd0;
        channel1 <= 10'd0;
        channel2 <= 10'd0;
        hSyncArmed <= 1'b0;
    end else if (characterCount < PREAMBLE_START) begin
        // After HSync goes active, wait 16 cycles before starting the preamble
        characterCount <= characterCount + 7'd1;
        
        // While we're waiting, read up to four samples from the FIFO into the latchedSamples array
        if ((sampleFifoReadEnable == 1'b0) && (sampleFifoEmpty == 1'b0) && (sampleAvailable == 1'b0) && (latchedSampleCount < 3'd4)) begin
            // Read a sample from the FIFO
            sampleFifoReadEnable <= 1'b1;
        end else if (sampleFifoReadEnable == 1'b1) begin
            // Sample will be available on sampleFifoReadData next clock
            sampleFifoReadEnable <= 1'b0;
            sampleAvailable <= 1'b1;
        end else if (sampleAvailable == 1'b1) begin
            // Save the sample in latchedSamples
            sampleAvailable <= 1'b0;
            latchedSamples[latchedSampleCount[1:0]] <=
                {channelStatusIndex == 8'd0, channelStatusRightWord[channelStatusIndex], channelStatusLeftWord[channelStatusIndex], sampleFifoReadData};
            latchedSampleCount <= latchedSampleCount + 3'd1;
            regenSampleCount <= regenSampleCount + 8'd1;
            if (channelStatusIndex >= 8'd191) begin
                channelStatusIndex <= 8'd0;
            end else begin
                channelStatusIndex <= channelStatusIndex + 8'd1;
            end
        end
    // Sending a data island (including preamble and guard bands)
    end else if (characterCount < LEADING_GUARD_BAND_START) begin
        characterCount <= characterCount + 7'd1;
        // Indicate to HdmiEncoder that it should start using my channel0..2 outputs
        dataIslandActive <= 1'b1;
        // 8 characters of preamble
        channel0 <= ch0PreambleDataEncoded;
        channel1 <= ch1PreambleDataEncoded;
        channel2 <= ch2PreambleDataEncoded;
    end else if (characterCount < SAMPLE_PACKET_START || 
                 (characterCount >= TRAILING_GUARD_BAND_START && characterCount < ISLAND_FINISHED)) begin
        characterCount <= characterCount + 7'd1;
        // Data island leading or trailing guard band - 2 characters
        channel0 <= ch0GuardBand;
        channel1 <= ch1GuardBand;
        channel2 <= ch2GuardBand;
    end else if (characterCount < TRAILING_GUARD_BAND_START) begin
        characterCount <= characterCount + 7'd1;
        // Data island packet data from serializer
        // 2 packets * 32 characters each = 64 characters of packet data
        channel0 <= ch0PacketDataEncoded;
        channel1 <= ch1PacketDataEncoded;
        channel2 <= ch2PacketDataEncoded;
    end else begin
        // Indicate to HdmiEncoder that it should stop using my channel0..2 outputs
        dataIslandActive <= 1'b0;
        channel0 <= 10'd0;
        channel1 <= 10'd0;
        channel2 <= 10'd0;
        
        // We just finished sending an audio sample packet, so reset the latched sample counter
        latchedSampleCount <= 3'd0;
        // Zero out the latched samples (as a debugging aid for simulation)
        latchedSamples[0] <= 35'd0;
        latchedSamples[1] <= 35'd0;
        latchedSamples[2] <= 35'd0;
        latchedSamples[3] <= 35'd0;
        
        if (regenPacketDue) begin
            // We just finished sending an audio clock regen packet, so reset the regen counter
            regenSampleCount <= regenSampleCount - samplesPerRegenPacket;
        end
    end
end

endmodule
