//
// VideoHorizontalStretch - Adjust width of frame using horizontal linear interpolation
//
// This module uses linear interpolation to perform non-integer scaling of a scanline.
// Since it is operating on one line at a time, this module can scale horizontally
// "just in time" as upstream pixel data comes in, without using full line or chunk buffers.
// However, this makes the timing complicated, as the same upstream pixel may be needed to
// calculate more than one downstream pixel, and each downstream pixel must blend one or two
// upstream pixels.
//
// Each downstream pixel coordinate is multiplied by the shrink factor to determine the coordinate
// of the blended pixel in the upstream coordinate frame.
//
// The game here is to buffer enough upstream pixels and enough downstream pixel requests so that
// we spend little time waiting to pull data from the FIFOs, and hopefully achieve burst speeds
// close to one downstream pixel per shader clock, at least for shrink factors < 1.0.
//
// Consider a scale factor of 2x (shrink factor of 0.5).  The FIFO reads should resemble this:
//
//      Upstream Column     Downstream Request
//          0                   0.25
//          1                   
//                              0.75
//          2                   1.25
//                              1.75
//          3                   2.25
//                              2.75
//          4                   3.25
//          ...                 ...
//
// Since it takes up to two upstream pixels to produce each downstream pixel, this module implements
// a two-pixel upstream pre-fetch to keep up the downstream burst speed.  To look ahead and know when
// an upstream pixel can be discarded (and a new pixel can be read from the FIFO), the next
// downstream request (if available) is pre-fetched.
//      Cycle   UpstreamR   UpstreamL       DownstreamA DownstreamB
//      0                                   0.25
//      1       0                           0.75        0.25
//      2       1           0               0.75        0.25
//      3       1           0               1.25        0.75
//      4       2           1               1.75        1.25
//      5       2           1               2.25        1.75
//      6       3           2               2.75        2.25
//      ...
//
// Rules for cycling the upstream pre-fetch (i.e. fetch a new pixel from upstreamResponses):
//  1. Never cycle the upstream pre-fetch if the downstream pre-fetch contains zero items.
//  2. If the downstream pre-fetch contains one item, cycle the upstream pre-fetch if it does not
//     contain the pixels that the downstream item needs.
//  3. If the downstream pre-fetch contains two items, and the upstream pre-fetch *cannot* satisfy
//     the oldest downstream item, then cycle the upstream pre-fetch.
//  4. If the downstream pre-fetch contains two items, and the upstream pre-fetch *can* satisfy the
//     oldest downstream item, but youngest downstream item cannot be satisfied, then cycle the
//     upstream pre-fetch.
//
// Rules for cycling the downstream pre-fetch (i.e. fetch a new coord from pendingDownstreamResponses):
//  1. If the downstream pre-fetch contains less than two items, then attempt to read more items
//     from the FIFO to fill the two-item pre-fetch.
//  2. If the oldest item in the downstream pre-fetch can be satisfied using the upstream pre-fetch,
//     then calculate the interpolated pixel, discard the oldest downstream item and attempt
//     to read a new downstream item.
//
// This filter can be used to adjust or distort the aspect ratio of a video frame, for example:
// to display a non-square-pixel video source on a display with square pixels.
//
// Assumes 16-bit RGB pixel data (5-6-5 red-green-blue).
//
//
// Copyright 2021 Reclone Labs <reclonelabs.com>
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

module VideoHorizontalStretch #(parameter CHUNK_BITS = 5, SCALE_FRACTION_BITS = 6)
(
    input wire scalerClock,
    input wire reset,

    // Scaling configuration
    input wire [SCALE_BITS-1:0] hShrinkFactor,
    
    // Filter module reads from the downstream request FIFO...
    output wire downstreamRequestFifoReadEnable,
    input wire downstreamRequestFifoEmpty,
    input wire [REQUEST_BITS-1:0] downstreamRequestFifoReadData,
    
    // ...and writes to the downstream response FIFO.
    output wire downstreamResponseFifoWriteEnable,
    input wire downstreamResponseFifoFull,
    output reg [BITS_PER_PIXEL-1:0] downstreamResponseFifoWriteData = {BITS_PER_PIXEL{1'b0}},
    
    // Filter module exposes upstream request FIFO for reading...
    input wire upstreamRequestFifoReadEnable,
    output wire upstreamRequestFifoEmpty,
    output wire [REQUEST_BITS-1:0] upstreamRequestFifoReadData,
    
    // ...and exposes upstream response FIFO for writing.
    input wire upstreamResponseFifoWriteEnable,
    output wire upstreamResponseFifoFull,
    input wire [BITS_PER_PIXEL-1:0] upstreamResponseFifoWriteData
);

localparam CHUNK_SIZE = 1 << CHUNK_BITS;
localparam HACTIVE_BITS = 11;
localparam HACTIVE_COLUMNS = 1 << HACTIVE_BITS;
localparam VACTIVE_BITS = 11;
localparam CHUNKNUM_BITS = HACTIVE_BITS - CHUNK_BITS;
localparam MAX_CHUNKS_PER_ROW = 1 << CHUNKNUM_BITS;
localparam REQUEST_BITS = VACTIVE_BITS + CHUNKNUM_BITS;
localparam BITS_PER_PIXEL = 16;
localparam SCALE_BITS = SCALE_FRACTION_BITS + 1;
localparam HCOORD_BITS = HACTIVE_BITS + SCALE_FRACTION_BITS;

// One-hot states for downstream request state machine
localparam DOWNSTREAM_REQUEST_IDLE = 3'b001, DOWNSTREAM_REQUEST_READ = 3'b010, DOWNSTREAM_REQUEST_STORE = 3'b100;
reg[2:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

// One-hot states for upstream response state machine
localparam UPSTREAM_RESPONSE_IDLE = 3'b001, UPSTREAM_RESPONSE_READ = 3'b010, UPSTREAM_RESPONSE_STORE = 3'b100;
reg [2:0] upstreamResponseState = UPSTREAM_RESPONSE_IDLE;

// Downstream request read enable is gated to avoid glitches due to state machine design
reg downstreamRequestFifoReadEnableReg = 1'b0;
assign downstreamRequestFifoReadEnable = downstreamRequestFifoReadEnableReg &&
    !pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull;

// upstreamRequests FIFO provides chunk requests to the upstream pipeline element
reg upstreamRequestFifoWriteEnable = 1'b0;
wire upstreamRequestFifoFull;
reg [REQUEST_BITS-1:0] upstreamRequestFifoWriteData = {REQUEST_BITS{1'b0}};
SyncFifo #(.DATA_WIDTH(REQUEST_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) upstreamRequests
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(upstreamRequestFifoReadEnable),
    .empty(upstreamRequestFifoEmpty),
    .readData(upstreamRequestFifoReadData),
    .writeEnable(upstreamRequestFifoWriteEnable),
    .full(upstreamRequestFifoFull),
    .writeData(upstreamRequestFifoWriteData)
);

wire upstreamResponseFifoReadEnable;
wire upstreamResponseFifoEmpty;
wire [BITS_PER_PIXEL-1:0] upstreamResponseFifoReadData;
// upstreamResponses FIFO receives pixel data from the upstream pipeline element
SyncFifo #(.DATA_WIDTH(BITS_PER_PIXEL), .ADDR_WIDTH(CHUNK_BITS)) upstreamResponses
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(upstreamResponseFifoReadEnable),
    .empty(upstreamResponseFifoEmpty),
    .readData(upstreamResponseFifoReadData),
    .writeEnable(upstreamResponseFifoWriteEnable),
    .full(upstreamResponseFifoFull),
    .writeData(upstreamResponseFifoWriteData)
);

// pendingUpstreamRequests FIFO internally keeps track of the upstream requests,
// so that the received pixel data can be processed accordingly
wire pendingUpstreamRequestFifoFull;
wire pendingUpstreamRequestFifoEmpty;
reg pendingUpstreamRequestFifoReadEnable;
wire [CHUNKNUM_BITS-1:0] pendingUpstreamRequestFifoReadData;
SyncFifo #(.DATA_WIDTH(CHUNKNUM_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingUpstreamRequests
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(pendingUpstreamRequestFifoReadEnable),
    .empty(pendingUpstreamRequestFifoEmpty),
    .readData(pendingUpstreamRequestFifoReadData),
    .writeEnable(upstreamRequestFifoWriteEnable),
    .full(pendingUpstreamRequestFifoFull),
    .writeData(upstreamRequestFifoWriteData[CHUNKNUM_BITS-1:0])
);

reg [CHUNK_BITS-1:0] upstreamResponsePixelCount = {CHUNK_BITS{1'b0}};

// pendingDownstreamResponses FIFO internally keeps track of the pending responses,
// so that they can be handled as soon as required pixel data is cached.
// This cache actually contains the full precision fixed-point horizontal coordinate
// of each pending downstream pixel (in the coordinate system of the upstream video frame).
wire pendingDownstreamResponseFifoFull;
wire pendingDownstreamResponseFifoEmpty;
reg pendingDownstreamResponseFifoReadEnable = 1'b0;
wire [HCOORD_BITS-1:0] pendingDownstreamResponseFifoReadData;
reg pendingDownstreamResponseFifoWriteEnable = 1'b0;
reg [HCOORD_BITS-1:0] pendingDownstreamResponseFifoWriteData = {HCOORD_BITS{1'b0}};
SyncFifo #(.DATA_WIDTH(HCOORD_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingDownstreamResponses
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(pendingDownstreamResponseFifoReadEnable),
    .empty(pendingDownstreamResponseFifoEmpty),
    .readData(pendingDownstreamResponseFifoReadData),
    .writeEnable(pendingDownstreamResponseFifoWriteEnable && !pendingDownstreamResponseFifoFull),
    .full(pendingDownstreamResponseFifoFull),
    .writeData(pendingDownstreamResponseFifoWriteData)
);

reg [REQUEST_BITS-1:0] lastUpstreamChunkRequest = {REQUEST_BITS{1'b1}};
reg [REQUEST_BITS-1:0] lastlastUpstreamChunkRequest = {REQUEST_BITS{1'b1}};

reg [CHUNK_BITS:0] downstreamRequestPixelCount = {(CHUNK_BITS+1){1'b0}};
wire [VACTIVE_BITS-1:0] downstreamRequestRow = downstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [HACTIVE_BITS-1:0] downstreamRequestCoord = {downstreamRequestFifoReadData[CHUNKNUM_BITS-1:0], downstreamRequestPixelCount[CHUNK_BITS-1:0]};
wire [HCOORD_BITS-1:0] upstreamRequestCoord = downstreamRequestCoord * hShrinkFactor + {{(HCOORD_BITS-SCALE_BITS){1'b0}}, hShrinkFactor[SCALE_BITS-1:1]}
    - (hShrinkFactor[SCALE_BITS-1] ? {{HACTIVE_BITS{1'b0}}, 1'b1, {(SCALE_FRACTION_BITS-1){1'b0}}} : {HCOORD_BITS{1'b0}});
wire needsNextChunkToo = (upstreamRequestCoord[HCOORD_BITS-CHUNKNUM_BITS-1:HCOORD_BITS-HACTIVE_BITS] == {CHUNK_BITS{1'b1}}) &&
                         (|upstreamRequestCoord[SCALE_FRACTION_BITS-1:0]);
wire [REQUEST_BITS-1:0] upstreamChunkRequest = {downstreamRequestRow, upstreamRequestCoord[HCOORD_BITS-1:HCOORD_BITS-CHUNKNUM_BITS]};
wire [REQUEST_BITS-1:0] upstreamChunkRequestNext = {downstreamRequestRow, upstreamRequestCoord[HCOORD_BITS-1:HCOORD_BITS-CHUNKNUM_BITS] + {{(CHUNKNUM_BITS-1){1'b0}}, 1'b1}};

reg [BITS_PER_PIXEL-1:0] leftPixelColor = {BITS_PER_PIXEL{1'b0}};
reg [HACTIVE_BITS-1:0] leftPixelColumn = {HACTIVE_BITS{1'b1}};
wire [BITS_PER_PIXEL-1:0] rightPixelColor = upstreamResponseFifoReadData;
reg [HACTIVE_BITS-1:0] rightPixelColumn = {HACTIVE_BITS{1'b1}};

wire [HCOORD_BITS-1:0] downstreamCoordA = pendingDownstreamResponseFifoReadData;
wire [SCALE_BITS-1:0] downstreamCoordARightCoeff = {1'b0, downstreamCoordA[SCALE_FRACTION_BITS-1:0]};
wire [SCALE_BITS-1:0] downstreamCoordALeftCoeff = {1'b0, ~downstreamCoordA[SCALE_FRACTION_BITS-1:0]} + {{(SCALE_BITS-1){1'b0}}, 1'b1};
wire [HACTIVE_BITS-1:0] downstreamCoordALeftColumn  = downstreamCoordA[HCOORD_BITS-1:HCOORD_BITS-HACTIVE_BITS];
wire [HACTIVE_BITS-1:0] downstreamCoordARightColumn = downstreamCoordA[HCOORD_BITS-1:HCOORD_BITS-HACTIVE_BITS] + {{(HACTIVE_BITS-1){1'b0}}, 1'b1};
wire downstreamCoordAAvailable = (downstreamCoordALeftColumn == leftPixelColumn) &&
                                 (~|downstreamCoordARightCoeff || downstreamCoordARightColumn == rightPixelColumn);

reg  [HCOORD_BITS-1:0] downstreamCoordB = {HCOORD_BITS{1'b1}};
wire [SCALE_BITS-1:0] downstreamCoordBRightCoeff = {1'b0, downstreamCoordB[SCALE_FRACTION_BITS-1:0]};
wire [SCALE_BITS-1:0] downstreamCoordBLeftCoeff = {1'b0, ~downstreamCoordB[SCALE_FRACTION_BITS-1:0]} + {{(SCALE_BITS-1){1'b0}}, 1'b1};
wire [HACTIVE_BITS-1:0] downstreamCoordBLeftColumn  = downstreamCoordB[HCOORD_BITS-1:HCOORD_BITS-HACTIVE_BITS];
wire [HACTIVE_BITS-1:0] downstreamCoordBRightColumn = downstreamCoordB[HCOORD_BITS-1:HCOORD_BITS-HACTIVE_BITS] + {{(HACTIVE_BITS-1){1'b0}}, 1'b1};
wire downstreamCoordBAvailable = (downstreamCoordBLeftColumn == leftPixelColumn) &&
                                 (~|downstreamCoordBRightCoeff || downstreamCoordBRightColumn == rightPixelColumn);

reg [1:0] downstreamCoordPreFetchCount = 2'd0;

reg inboundUpstreamRequest = 1'b0;

reg downstreamResponseFifoWriteEnableReg = 1'b0;
assign downstreamResponseFifoWriteEnable = downstreamResponseFifoWriteEnableReg && !downstreamResponseFifoFull;

// Read a new pending downstream response (horizontal coordinate) if we have not yet
// filled the two lookahead slots, or if we have the upstream pixels needed to satisfy slot B.
assign pendingDownstreamResponseFifoReadEnable = !pendingDownstreamResponseFifoEmpty &&
    (downstreamCoordPreFetchCount < 2'd2 || (downstreamCoordBAvailable && !downstreamResponseFifoFull));

// Read the next upstream response pixel if we do not have the right upstream
// pixel columns to form the current downstream pixel, OR if we anticipate
// needing fresh upstream pixel columns next cycle.
assign upstreamResponseFifoReadEnable = !upstreamResponseFifoEmpty && !downstreamResponseFifoFull &&
    ((downstreamCoordPreFetchCount == 2'd1 && !downstreamCoordAAvailable) ||
     (downstreamCoordPreFetchCount == 2'd2 && !downstreamCoordBAvailable) ||
     (downstreamCoordPreFetchCount == 2'd2 && downstreamCoordBAvailable && !downstreamCoordAAvailable));
     
reg [31:0] totalUpstreamResponses = 32'd0;

function [BITS_PER_PIXEL-1:0] blend;
    input [BITS_PER_PIXEL-1:0]  lColor;
    input [SCALE_BITS-1:0]      lCoeff;
    input [BITS_PER_PIXEL-1:0]  rColor;
    input [SCALE_BITS-1:0]      rCoeff;
    
    
    reg [4:0] lRed = 5'd0;
    reg [5:0] lGreen = 6'd0;
    reg [4:0] lBlue = 5'd0;
    reg [4:0] rRed = 5'd0;
    reg [5:0] rGreen = 6'd0;
    reg [4:0] rBlue = 5'd0;
    
    
    /* verilator lint_off UNUSED */
    reg [4+SCALE_FRACTION_BITS:0] blendedRed = {(5+SCALE_FRACTION_BITS){1'b0}};
    reg [5+SCALE_FRACTION_BITS:0] blendedGreen = {(6+SCALE_FRACTION_BITS){1'b0}};
    reg [4+SCALE_FRACTION_BITS:0] blendedBlue = {(5+SCALE_FRACTION_BITS){1'b0}};
    /* verilator lint_on UNUSED */
    
    begin
        lRed = lColor[15:11];
        lGreen = lColor[10:5];
        lBlue = lColor[4:0];
        rRed = rColor[15:11];
        rGreen = rColor[10:5];
        rBlue = rColor[4:0];
        
        blendedRed = lRed * lCoeff + rRed * rCoeff;
        blendedGreen = lGreen * lCoeff + rGreen * rCoeff;
        blendedBlue = lBlue * lCoeff + rBlue * rCoeff;
        
        blend = {blendedRed[4+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS],
                 blendedGreen[5+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS],
                 blendedBlue[4+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS]};
    end
endfunction


always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        // TODO

    end else begin
        if (upstreamResponseFifoReadEnable)
            totalUpstreamResponses <= totalUpstreamResponses + 32'd1;

    
        // Request state machine - Get downstream chunk requests, translate pixel coordinates,
        //                         and enqueue upstream chunk requests
        case (downstreamRequestState)
            DOWNSTREAM_REQUEST_IDLE: begin
                // Reset write enables if coming from DOWNSTREAM_REQUEST_STORE or DOWNSTREAM_REQUEST_STALL
                upstreamRequestFifoWriteEnable <= 1'b0;
                pendingDownstreamResponseFifoWriteEnable <= 1'b0;
                lastUpstreamChunkRequest <= {REQUEST_BITS{1'b1}};
                lastlastUpstreamChunkRequest <= {REQUEST_BITS{1'b1}};
            
                // Wait for a request
                if (!downstreamRequestFifoEmpty && !pendingUpstreamRequestFifoFull &&
                    !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    // Read the request
                    // It should be available during DOWNSTREAM_REQUEST_STORE
                    downstreamRequestFifoReadEnableReg <= 1'b1;
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_READ;
                end
            end

            DOWNSTREAM_REQUEST_READ: begin
                // Request should be available next cycle
                downstreamRequestFifoReadEnableReg <= 1'b0;
                
                // Make sure again that the FIFOs have the space to receive new requests because last cycle
                // pendingDownstreamResponseFifoWriteEnable could have caused pendingDownstreamResponseFifoFull
                if (!pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
                    downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b0}};
                end
            end

            DOWNSTREAM_REQUEST_STORE: begin
                if (!pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    // Request chunks from upstream
                    if (lastUpstreamChunkRequest != upstreamChunkRequest && lastlastUpstreamChunkRequest != upstreamChunkRequest) begin
                        // Submit upstreamChunkRequest
                        lastUpstreamChunkRequest <= upstreamChunkRequest;
                        lastlastUpstreamChunkRequest <= lastUpstreamChunkRequest;
                        upstreamRequestFifoWriteData <= upstreamChunkRequest;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                    end else if (lastUpstreamChunkRequest != upstreamChunkRequestNext && lastlastUpstreamChunkRequest != upstreamChunkRequestNext
                                 && needsNextChunkToo) begin
                        // Need the first pixel of next chunk too, so submit upstreamChunkRequest + 1
                        lastUpstreamChunkRequest <= upstreamChunkRequestNext;
                        lastlastUpstreamChunkRequest <= lastUpstreamChunkRequest;
                        upstreamRequestFifoWriteData <= upstreamChunkRequestNext;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                    end else begin
                        // No additional upstream request needed
                        upstreamRequestFifoWriteEnable <= 1'b0;
                    end
                    
                    // Save horizontal coordinate as pending downstream response
                    pendingDownstreamResponseFifoWriteData <= upstreamRequestCoord;
                    pendingDownstreamResponseFifoWriteEnable <= 1'b1;
                    
                    // If second to last pixel of the chunk, then start reading the next request, if there is one
                    if (downstreamRequestPixelCount == {1'b0, {(CHUNK_BITS-1){1'b1}}, 1'b0}) begin
                        downstreamRequestPixelCount <= downstreamRequestPixelCount + {{CHUNK_BITS{1'b0}}, 1'b1};
                        if (!downstreamRequestFifoEmpty) begin
                            downstreamRequestFifoReadEnableReg <= 1'b1;
                        end
                    // If that was the last pixel of the chunk
                    end else if (downstreamRequestPixelCount == {1'b0, {CHUNK_BITS{1'b1}}}) begin
                        if (downstreamRequestFifoReadEnableReg) begin
                            // Start working the next request
                            downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b0}};
                            downstreamRequestFifoReadEnableReg <= 1'b0;
                        end else begin
                            // Do not process another request
                            downstreamRequestPixelCount <= downstreamRequestPixelCount + {{CHUNK_BITS{1'b0}}, 1'b1};
                            downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
                        end
                    end else begin
                        downstreamRequestPixelCount <= downstreamRequestPixelCount + {{CHUNK_BITS{1'b0}}, 1'b1};
                    end
                    
                end else begin
                    upstreamRequestFifoWriteEnable <= 1'b0;
                end
            end

            default: begin
                downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
            end
        endcase
        
        case (upstreamResponseState)
            UPSTREAM_RESPONSE_IDLE: begin
                // Wait until we can grab a pending upstream request
                if (!pendingUpstreamRequestFifoEmpty) begin
                    pendingUpstreamRequestFifoReadEnable <= 1'b1;
                    upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                    upstreamResponseState <= UPSTREAM_RESPONSE_READ;
                end
                inboundUpstreamRequest <= 1'b0;
            end

            UPSTREAM_RESPONSE_READ: begin
                // Next cycle the request item should be available
                pendingUpstreamRequestFifoReadEnable <= 1'b0;
                upstreamResponseState <= UPSTREAM_RESPONSE_STORE;
            end

            UPSTREAM_RESPONSE_STORE: begin
                // pendingUpstreamRequestFifoReadData has the pending upstream request (chunk number)
                
                if (upstreamResponseFifoReadEnable) begin
                    // Combinatorial logic says we are about to read an upstream response pixel, so
                    // store its column and update the pixel counter
                    rightPixelColumn[CHUNK_BITS-1:0] <= upstreamResponsePixelCount;
                    // Shift right pixel color and column to left pixel
                    leftPixelColumn <= rightPixelColumn;
                    leftPixelColor <= rightPixelColor;
                    
                    // If that was the last pixel of the chunk, start the next chunk or return to idle
                    if (upstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                        // Reset pixel counter
                        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                        
                        if (inboundUpstreamRequest) begin
                            // Another chunk is incoming, and its request will be ready next cycle
                            pendingUpstreamRequestFifoReadEnable <= 1'b0;
                            inboundUpstreamRequest <= 1'b0;
                        end else begin
                            // No incoming chunk at this point, so return to idle
                            upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
                        end
                    end else begin
                        if (upstreamResponsePixelCount == {(CHUNK_BITS){1'b0}}) begin
                            // First pixel in the chunk, so update the chunk part of rightPixelColumn
                            rightPixelColumn[HACTIVE_BITS-1:CHUNK_BITS] <= pendingUpstreamRequestFifoReadData;
                        end else if (upstreamResponsePixelCount == {{(CHUNK_BITS-1){1'b1}}, 1'b0}) begin
                            // Second to last pixel in the chunk, so start reading the next pending request if there is one
                            if (!pendingUpstreamRequestFifoEmpty) begin
                                // Another chunk is incoming, so retrieve its request
                                pendingUpstreamRequestFifoReadEnable <= 1'b1;
                                inboundUpstreamRequest <= 1'b1;
                            end
                        end
                        
                        // Increment pixel counter
                        upstreamResponsePixelCount <= upstreamResponsePixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
                    end
                end else begin
                    pendingUpstreamRequestFifoReadEnable <= 1'b0;
                end
            end

            default: begin
                upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
            end
        endcase
        
        
        // Cycle the downstream response pre-fetch, and write responses if the required pixel data is available
        if (downstreamCoordPreFetchCount == 2'd1) begin
            if (downstreamCoordAAvailable && !downstreamResponseFifoFull) begin
                // Write a pixel to the downstream response based on coordinate A
                downstreamResponseFifoWriteEnableReg <= 1'b1;
                downstreamResponseFifoWriteData <= blend(leftPixelColor, downstreamCoordALeftCoeff, rightPixelColor, downstreamCoordARightCoeff);
                if (pendingDownstreamResponseFifoReadEnable) begin
                    downstreamCoordB <= downstreamCoordA;
                    // Count remains at 1
                end else begin
                    downstreamCoordPreFetchCount <= 2'd0;
                end
            end else begin
                // Cannot write the response yet
                downstreamResponseFifoWriteEnableReg <= 1'b0;
                if (pendingDownstreamResponseFifoReadEnable) begin
                    downstreamCoordB <= downstreamCoordA;
                    downstreamCoordPreFetchCount <= 2'd2;
                end else begin
                    // Count remains at 1
                end
            end
        end else if (downstreamCoordPreFetchCount == 2'd2) begin
            if (downstreamCoordBAvailable && !downstreamResponseFifoFull) begin
                // Write a pixel to the downstream response based on coordinate B
                downstreamResponseFifoWriteEnableReg <= 1'b1;
                downstreamResponseFifoWriteData <= blend(leftPixelColor, downstreamCoordBLeftCoeff, rightPixelColor, downstreamCoordBRightCoeff);
                if (pendingDownstreamResponseFifoReadEnable) begin
                    downstreamCoordB <= downstreamCoordA;
                    // Count remains at 2
                end else begin
                    downstreamCoordPreFetchCount <= 2'd1;
                end
            end else begin
                // Cannot write the response yet
                downstreamResponseFifoWriteEnableReg <= 1'b0;
                // Count remains at 2
            end
        end else begin
            // Nothing to do
            downstreamResponseFifoWriteEnableReg <= 1'b0;
            if (pendingDownstreamResponseFifoReadEnable) begin
                downstreamCoordPreFetchCount <= 2'd1;
            end
        end
    end
end

endmodule
