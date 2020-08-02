//
// VideoTimingSink - Generate VGA-style timing and color signals from a video pipeline
//
// This is the final stage of a video pipeline - outputting video timing and color signals
// that are suitable to be consumed by an encoder for DVI, composite video, etc.
//
// Prior stages of the video pipeline have intermediate resolutions and operate in small
// data bursts, so inherently, they do not have any timing information and just perform small
// operations on request.  Therefore, it is VideoTimingSink's job to request pixel data from 
// the pipeline with enough advance notice to draw each scanline on its required schedule.
// If a pixel's color values are not retrieved in time to draw the pixel, the 'late' output
// goes 1 to indicate a design or configuration issue.
//
// This module takes two clocks - a pixel clock and a scaler clock.  The scaler clock should be
// significantly faster than the pixel clock, in an attempt to make up for inherent latency
// with higher burst speed.
//
// Two asynchronous FIFOs are used to communicate across the two clock domains, forming a simple
// request/response system.  The 'request' FIFO pushes out requests to the upstream pipeline
// stage that include the line and chunk numbers of the requested pixel data.  The 'response'
// FIFO sucks in the requested pixel data from the upstream stage.  It is expected that exactly
// the right number of pixels will eventually be delivered in response to each request.
//
// A chunk is a specific number of pixels in a scanline.  Chunk size is configurable, but a default
// of 32 pixels was selected as a tradeoff between buffer size, latency, and handshaking overhead.
// A 5-bit value for chunk number also causes the request FIFO to have a data size of 16 bits,
// making it more likely that a block RAM can potentially be inferred for the request FIFO.
// All pipeline stages must be configured with the same chunk size.  For some strange resolutions,
// the final chunk in a scanline may have fewer pixels; this is expected and fine.
//
// A core assumption is that this module takes in 16-bit (5-6-5 RGB) pixel color data, but outputs
// 24-bit (8-8-8 RGB) color data.  This is intended to limit the bandwidth, complexity, and
// FPGA resources required to implement the video pipeline.
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

module VideoTimingSink #(parameter CHUNK_BITS = 5)
(
    input wire pixelClock,
    input wire scalerClock,
    input wire reset,
    input wire [6:0] hFrontPorch,
    input wire [7:0] hSyncPulse,
    input wire [7:0] hBackPorch,
    input wire [HACTIVE_BITS-1:0] hActive,
    input wire [5:0] vFrontPorch,
    input wire [3:0] vSyncPulse,
    input wire [5:0] vBackPorch,
    input wire [VACTIVE_BITS-1:0] vActive,
    input wire syncIsActiveLow,
    input wire isInterlaced,
    
    input wire requestFifoReadEnable,
    output wire requestFifoEmpty,
    output wire [REQUEST_BITS-1:0] requestFifoReadData,
    
    input wire responseFifoWriteEnable,
    output wire responseFifoFull,
    input wire [BITS_PER_PIXEL-1:0] responseFifoWriteData,

    output reg dataEnable = 1'b0,
    output reg hSync = 1'b0,
    output reg vSync = 1'b0,
    output reg activeVideoPreamble = 1'b0,
    output reg activeVideoGuardBand = 1'b0,
    output wire [7:0] blue,
    output wire [7:0] green,
    output wire [7:0] red,
    output reg late = 1'b0

);

localparam CHUNK_SIZE = 1 << CHUNK_BITS;
localparam HACTIVE_BITS = 11;
localparam VACTIVE_BITS = 11;
localparam CHUNKNUM_BITS = HACTIVE_BITS - CHUNK_BITS;
localparam REQUEST_BITS = VACTIVE_BITS + CHUNKNUM_BITS;
localparam BITS_PER_PIXEL = 16;

wire timingDataEnable;
wire timingHSync;
wire timingVSync;
wire timingActiveVideoPreamble;
wire timingActiveVideoGuardBand;
wire [VACTIVE_BITS-1:0] timingVPos;
VideoFormatTiming timing
(
    .clock(pixelClock),
    .reset(reset),
    .hFrontPorch(hFrontPorch),
    .hSyncPulse(hSyncPulse),
    .hBackPorch(hBackPorch),
    .hActive(hActive),
    .vFrontPorch(vFrontPorch),
    .vSyncPulse(vSyncPulse),
    .vBackPorch(vBackPorch),
    .vActive(vActive),
    .syncIsActiveLow(syncIsActiveLow),
    .isInterlaced(isInterlaced),
    .dataEnable(timingDataEnable),
    .hSync(timingHSync),
    .vSync(timingVSync),
    .hPos(),
    .vPos(timingVPos),
    .activeVideoPreamble(timingActiveVideoPreamble),
    .activeVideoGuardBand(timingActiveVideoGuardBand)
);

reg [HACTIVE_BITS-CHUNK_BITS-1:0] requestedChunk = {(CHUNKNUM_BITS){1'b0}};
// Write a request to the FIFO for each chunk in the line, as soon as timingDataEnable goes to 0
wire requestFifoWriteEnable = !timingDataEnable && (requestedChunk < chunksPerLine);
wire requestFifoFull;
AsyncFifo #(.DATA_WIDTH(REQUEST_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) requestFifo
(
    .asyncReset(reset),
    .readClock(scalerClock),
    .readEnable(requestFifoReadEnable),
    .empty(requestFifoEmpty),
    .readData(requestFifoReadData),
    .writeClock(pixelClock),
    .writeEnable(requestFifoWriteEnable),
    .full(requestFifoFull),
    .writeData({timingVPos, requestedChunk})
);

// Read from the response FIFO for each active video pixel
reg clearResponseFifo = 1'b0;
wire responseFifoReadEnable = timingDataEnable;
wire responseFifoEmpty;
wire [15:0] responseFifoReadData;
AsyncFifo #(.DATA_WIDTH(BITS_PER_PIXEL), .ADDR_WIDTH(HACTIVE_BITS)) responseFifo
(
    .asyncReset(clearResponseFifo || reset),
    .readClock(pixelClock),
    .readEnable(responseFifoReadEnable),
    .empty(responseFifoEmpty),
    .readData(responseFifoReadData),
    .writeClock(scalerClock),
    .writeEnable(responseFifoWriteEnable),
    .full(responseFifoFull),
    .writeData(responseFifoWriteData)
);

wire [CHUNKNUM_BITS-1:0] chunksPerLine = hActive[HACTIVE_BITS-1:CHUNK_BITS];

// Extend 5 or 6 bits to 8 bits for each color component
assign red   = timingDataEnable ? {responseFifoReadData[15:11], responseFifoReadData[15:13]} : 8'd0;
assign green = timingDataEnable ? {responseFifoReadData[10: 5], responseFifoReadData[10: 9]} : 8'd0;
assign blue  = timingDataEnable ? {responseFifoReadData[ 4: 0], responseFifoReadData[ 4: 2]} : 8'd0;

always @ (posedge pixelClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        dataEnable <= 1'b0;
        hSync <= 1'b0;
        vSync <= 1'b0;
        activeVideoPreamble <= 1'b0;
        activeVideoGuardBand <= 1'b0;
        requestedChunk <= {CHUNKNUM_BITS{1'b0}};
        late <= 1'b0;
        clearResponseFifo <= 1'b0;
    end else begin
        // Delay these signals one clock to keep them synchronized with
        // responseFifoReadData and red, green, blue
        dataEnable <= timingDataEnable;
        hSync <= timingHSync;
        vSync <= timingVSync;
        activeVideoPreamble <= timingActiveVideoPreamble;
        activeVideoGuardBand <= timingActiveVideoGuardBand;
        
        if (timingDataEnable) begin
            requestedChunk <= {CHUNKNUM_BITS{1'b0}};
            late <= responseFifoEmpty;
            clearResponseFifo <= 1'b0;
        end else begin
            // Increment the chunk counter each clock, so that requests for all chunks on this line
            // are queued as soon as timingDataEnable goes to 0
            if (requestedChunk < chunksPerLine) begin
                requestedChunk <= requestedChunk + {{CHUNK_BITS-1{1'b0}}, 1'b1};
                late <= requestFifoFull;
            end else begin
                late <= 1'b0;
            end
            // Clear the response FIFO as the first chunk is requested
            clearResponseFifo <= (requestedChunk == {CHUNKNUM_BITS{1'b0}}) ? 1'b1 : 1'b0;
        end
    end
end

endmodule