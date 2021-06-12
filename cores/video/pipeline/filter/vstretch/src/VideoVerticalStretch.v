//
// VideoVerticalStretch - Adjust height of frame using vertical linear interpolation
//
// This module uses linear interpolation between scanlines to perform non-integer scaling.
// Since one downstream scanline is often a blend of two upstream scanlines, two line buffers
// are used to cache the upstream pixel data prior to interpolation.  For scale factors > 1.0x
// (shrink factors < 1.0), the line caches help to save upstream memory bandwidth, as the
// same upstream row may be needed to interpolate multiple adjacent downstream rows.
//
// Each downstream pixel coordinate is multiplied by the shrink factor to determine the coordinate
// of the blended pixel in the upstream coordinate frame.
//
// The timing of VideoVerticalStretch is somewhat simpler than the timing of VideoHorizontalStretch
// because there is no horizontal scaling in VideoVerticalStretch, therefore the downstream column
// always matches the upstream column.
//
// This filter can be used to adjust or distort the aspect ratio of a video frame, for example:
// to upscale a 4:3 video frame to fit the height of a 16:9 display (albeit with some softening).
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

module VideoVerticalStretch #(parameter CHUNK_BITS = 5, SCALE_FRACTION_BITS = 6)
(
    input wire scalerClock,
    input wire reset,

    // Scaling configuration
    input wire [SCALE_BITS-1:0] vShrinkFactor,
    
    // Filter module reads from the downstream request FIFO...
    output wire downstreamRequestFifoReadEnable,
    input wire downstreamRequestFifoEmpty,
    input wire [REQUEST_BITS-1:0] downstreamRequestFifoReadData,
    
    // ...and writes to the downstream response FIFO.
    output reg downstreamResponseFifoWriteEnable = 1'b0,
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
localparam VCOORD_BITS = VACTIVE_BITS + SCALE_FRACTION_BITS;

// One-hot states for downstream request state machine
localparam  DOWNSTREAM_REQUEST_IDLE  = 4'b0001,
            DOWNSTREAM_REQUEST_READ  = 4'b0010,
            DOWNSTREAM_REQUEST_STORE = 4'b0100,
            DOWNSTREAM_REQUEST_STALL = 4'b1000;
reg[3:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

// One-hot states for upstream response state machine
localparam  UPSTREAM_RESPONSE_IDLE = 3'b001,
            UPSTREAM_RESPONSE_READ = 3'b010,
            UPSTREAM_RESPONSE_STORE = 3'b100;
reg [2:0] upstreamResponseState = UPSTREAM_RESPONSE_IDLE;

// One-hot states for downstream response state machine
localparam  DOWNSTREAM_RESPONSE_IDLE = 3'b001,
            DOWNSTREAM_RESPONSE_READ = 3'b010,
            DOWNSTREAM_RESPONSE_STORE = 3'b100;
reg [2:0] downstreamResponseState = DOWNSTREAM_RESPONSE_IDLE;

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

reg upstreamResponseFifoReadEnable = 1'b0;
reg upstreamResponseReady = 1'b0;
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
// so that the received pixel data can be cached accordingly
wire pendingUpstreamRequestFifoFull;
wire pendingUpstreamRequestFifoEmpty;
wire pendingUpstreamRequestFifoReadEnable;
wire [REQUEST_BITS-1:0] pendingUpstreamRequestFifoReadData;
SyncFifo #(.DATA_WIDTH(REQUEST_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingUpstreamRequests
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(pendingUpstreamRequestFifoReadEnable),
    .empty(pendingUpstreamRequestFifoEmpty),
    .readData(pendingUpstreamRequestFifoReadData),
    .writeEnable(upstreamRequestFifoWriteEnable),
    .full(pendingUpstreamRequestFifoFull),
    .writeData(upstreamRequestFifoWriteData)
);

// pendingDownstreamResponses FIFO internally keeps track of the pending responses,
// so that they can be handled as soon as required pixel data is cached
wire pendingDownstreamResponseFifoFull;
wire pendingDownstreamResponseFifoEmpty;
reg pendingDownstreamResponseFifoReadEnable = 1'b0;
wire [SCALE_FRACTION_BITS+REQUEST_BITS-1:0] pendingDownstreamResponseFifoReadData;
reg pendingDownstreamResponseFifoWriteEnable = 1'b0;
wire [SCALE_FRACTION_BITS+REQUEST_BITS-1:0] pendingDownstreamResponseFifoWriteData;
SyncFifo #(.DATA_WIDTH(REQUEST_BITS+SCALE_FRACTION_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingDownstreamResponses
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(pendingDownstreamResponseFifoReadEnable),
    .empty(pendingDownstreamResponseFifoEmpty),
    .readData(pendingDownstreamResponseFifoReadData),
    .writeEnable(pendingDownstreamResponseFifoWriteEnable),
    .full(pendingDownstreamResponseFifoFull),
    .writeData(pendingDownstreamResponseFifoWriteData)
);

wire [VACTIVE_BITS-1:0] requestedRow = downstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] requestedChunk = downstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];

wire [VCOORD_BITS-1:0] upstreamRequestCoord = requestedRow * vShrinkFactor + {{(VACTIVE_BITS){1'b0}}, vShrinkFactor[SCALE_BITS-1:1]};
wire [VACTIVE_BITS-1:0] upstreamRequestCoordWhole = upstreamRequestCoord[VCOORD_BITS-1:SCALE_FRACTION_BITS];
wire [SCALE_FRACTION_BITS-1:0] upstreamRequestCoordFraction = upstreamRequestCoord[SCALE_FRACTION_BITS-1:0];
wire [VACTIVE_BITS-1:0] upstreamRequestRowUpper = upstreamRequestCoordWhole;
wire [VACTIVE_BITS-1:0] upstreamRequestRowLower = ~|upstreamRequestCoordFraction ? 
                            upstreamRequestRowUpper : upstreamRequestRowUpper + {{(VACTIVE_BITS-1){1'b0}}, 1'b1};

wire [REQUEST_BITS-1:0] upstreamRequestUpper = {upstreamRequestRowUpper, requestedChunk};
wire [REQUEST_BITS-1:0] upstreamRequestLower = {upstreamRequestRowLower, requestedChunk};

assign pendingDownstreamResponseFifoWriteData = {upstreamRequestCoord, requestedChunk};

reg [VACTIVE_BITS-1:0] cachedRowA = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [BITS_PER_PIXEL-1:0] cacheA [0:HACTIVE_COLUMNS-1];

reg [VACTIVE_BITS-1:0] cachedRowB = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidB = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingB = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [BITS_PER_PIXEL-1:0] cacheB [0:HACTIVE_COLUMNS-1];

reg cachedRowBIsOlder = 1'b0;

wire [VACTIVE_BITS-1:0] upstreamResponseRow = pendingUpstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] upstreamResponseChunk = pendingUpstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS-1:0] upstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
wire [HACTIVE_BITS-1:0] upstreamResponseColumn = {upstreamResponseChunk, upstreamResponsePixelCount};

wire [VCOORD_BITS-1:0] downstreamResponseCoord = pendingDownstreamResponseFifoReadData[SCALE_FRACTION_BITS+REQUEST_BITS-1:SCALE_FRACTION_BITS+REQUEST_BITS-VCOORD_BITS];
wire [VACTIVE_BITS-1:0] downstreamResponseCoordWhole = downstreamResponseCoord[VCOORD_BITS-1:SCALE_FRACTION_BITS];
wire [SCALE_FRACTION_BITS-1:0] downstreamResponseCoordFraction = downstreamResponseCoord[SCALE_FRACTION_BITS-1:0];
wire [CHUNKNUM_BITS-1:0] downstreamResponseChunk = pendingDownstreamResponseFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS-1:0] downstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
wire [HACTIVE_BITS-1:0] downstreamResponseColumn = {downstreamResponseChunk, downstreamResponsePixelCount};

wire [VACTIVE_BITS-1:0] downstreamCacheRowUpper = downstreamResponseCoordWhole;
wire [VACTIVE_BITS-1:0] downstreamCacheRowLower = ~|downstreamResponseCoordFraction ? 
                            downstreamCacheRowUpper : downstreamCacheRowUpper + {{(VACTIVE_BITS-1){1'b0}}, 1'b1};

wire [SCALE_BITS-1:0] downstreamCoordLowerCoeff = {1'b0, downstreamResponseCoord[SCALE_FRACTION_BITS-1:0]};
wire [SCALE_BITS-1:0] downstreamCoordUpperCoeff = {1'b0, ~downstreamResponseCoord[SCALE_FRACTION_BITS-1:0]} + {{(SCALE_BITS-1){1'b0}}, 1'b1};


function [BITS_PER_PIXEL-1:0] blend;
    input [BITS_PER_PIXEL-1:0]  uColor;
    input [SCALE_BITS-1:0]      uCoeff;
    input [BITS_PER_PIXEL-1:0]  lColor;
    input [SCALE_BITS-1:0]      lCoeff;
    
    
    reg [4:0] uRed = 5'd0;
    reg [5:0] uGreen = 6'd0;
    reg [4:0] uBlue = 5'd0;
    reg [4:0] lRed = 5'd0;
    reg [5:0] lGreen = 6'd0;
    reg [4:0] lBlue = 5'd0;
    
    
    /* verilator lint_off UNUSED */
    reg [4+SCALE_FRACTION_BITS:0] blendedRed = {(5+SCALE_FRACTION_BITS){1'b0}};
    reg [5+SCALE_FRACTION_BITS:0] blendedGreen = {(6+SCALE_FRACTION_BITS){1'b0}};
    reg [4+SCALE_FRACTION_BITS:0] blendedBlue = {(5+SCALE_FRACTION_BITS){1'b0}};
    /* verilator lint_on UNUSED */
    
    begin
        uRed = uColor[15:11];
        uGreen = uColor[10:5];
        uBlue = uColor[4:0];
        lRed = lColor[15:11];
        lGreen = lColor[10:5];
        lBlue = lColor[4:0];
        
        blendedRed = uRed * uCoeff + lRed * lCoeff;
        blendedGreen = uGreen * uCoeff + lGreen * lCoeff;
        blendedBlue = uBlue * uCoeff + lBlue * lCoeff;
        
        blend = {blendedRed[4+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS],
                 blendedGreen[5+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS],
                 blendedBlue[4+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS]};
    end
endfunction

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        //TODO
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
    end else begin
    
        // Request state machine - Get downstream chunk requests, translate pixel coordinates,
        //                         and enqueue upstream chunk requests
        case (downstreamRequestState)
            DOWNSTREAM_REQUEST_IDLE: begin
                // Reset write enables if coming from DOWNSTREAM_REQUEST_STORE or DOWNSTREAM_REQUEST_STALL
                upstreamRequestFifoWriteEnable <= 1'b0;
                pendingDownstreamResponseFifoWriteEnable <= 1'b0;
            
                // Wait for a request
                if (!downstreamRequestFifoEmpty && !pendingUpstreamRequestFifoFull &&
                        !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    // Read the request
                    // It should be available during DOWNSTREAM_REQUEST_STORE
                    downstreamRequestFifoReadEnable <= 1'b1;
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_READ;
                end
            end

            DOWNSTREAM_REQUEST_READ: begin
                // Request should be available next cycle
                downstreamRequestFifoReadEnable <= 1'b0;
                
                // Make sure again that the FIFOs have the space to receive new requests because last cycle
                // pendingDownstreamResponseFifoWriteEnable could have caused pendingDownstreamResponseFifoFull
                if (!pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
                end
            end

            DOWNSTREAM_REQUEST_STORE: begin
                // Determine if the required upstream chunk is already cached in the line buffer
                if ((upstreamRequestRowUpper == cachedRowA || upstreamRequestRowUpper == cachedRowB) &&
                    (upstreamRequestRowLower == cachedRowA || upstreamRequestRowLower == cachedRowB)) begin
                    // If we do not already have the requested chunks cached, and we are not repeating the previous request
                    if ((upstreamRequestRowUpper == cachedRowA) && 
                         !cachedChunkValidA[requestedChunk] &&
                         !cachedChunkPendingA[requestedChunk]) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequestUpper;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingA[requestedChunk] <= 1'b1;
                    end else if ((upstreamRequestRowUpper == cachedRowB) && 
                                 !cachedChunkValidB[requestedChunk] &&
                                 !cachedChunkPendingB[requestedChunk]) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequestUpper;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingB[requestedChunk] <= 1'b1;
                    end else if ((upstreamRequestRowLower == cachedRowA) && 
                         !cachedChunkValidA[requestedChunk] &&
                         !cachedChunkPendingA[requestedChunk]) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequestLower;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingA[requestedChunk] <= 1'b1;
                    end else if ((upstreamRequestRowLower == cachedRowB) && 
                                 !cachedChunkValidB[requestedChunk] &&
                                 !cachedChunkPendingB[requestedChunk]) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequestLower;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingB[requestedChunk] <= 1'b1;
                    end else begin
                        // Save the downstream response for processing later, and return to idle
                        pendingDownstreamResponseFifoWriteEnable <= 1'b1;
                        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
                    end
                end else begin
                    // Cached rows are different from requested rows, so stall until all pending requests are complete
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STALL;
                end
            end
            
            DOWNSTREAM_REQUEST_STALL: begin
                // Stall until all pending requests are complete, then start the new row(s)
                if (pendingUpstreamRequestFifoEmpty && pendingDownstreamResponseFifoEmpty && 
                        upstreamResponseState == UPSTREAM_RESPONSE_IDLE &&
                        downstreamResponseState == DOWNSTREAM_RESPONSE_IDLE) begin
                    // Requested rows do not match the rows cached by the line buffers,
                    // so update the line buffers as needed to start caching new row(s).
                    if (cachedRowBIsOlder) begin
                        if (cachedRowA == upstreamRequestRowUpper) begin
                            cachedRowB <= upstreamRequestRowLower;
                        end else begin
                            cachedRowB <= upstreamRequestRowUpper;
                        end
                        cachedChunkValidB <= {MAX_CHUNKS_PER_ROW{1'b0}};
                        cachedRowBIsOlder <= 1'b0;
                    end else begin
                        if (cachedRowB == upstreamRequestRowUpper) begin
                            cachedRowA <= upstreamRequestRowLower;
                        end else begin
                            cachedRowA <= upstreamRequestRowUpper;
                        end
                        cachedChunkValidA <= {MAX_CHUNKS_PER_ROW{1'b0}};
                        cachedRowBIsOlder <= 1'b1;
                    end
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
                end
            end

            default: begin
                downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
            end
        endcase
        
        // Upstream response state machine - Copy received upstream pixel data into line buffer cache
        case (upstreamResponseState)

            UPSTREAM_RESPONSE_IDLE: begin
                // Wait until we can grab a pending upstream request
                if (!pendingUpstreamRequestFifoEmpty) begin
                    pendingUpstreamRequestFifoReadEnable <= 1'b1;
                    upstreamResponseFifoReadEnable <= 1'b0;
                    upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                    upstreamResponseState <= UPSTREAM_RESPONSE_READ;
                end
            end
            
            UPSTREAM_RESPONSE_READ: begin
                // Next cycle the request item should be available
                pendingUpstreamRequestFifoReadEnable <= 1'b0;
                upstreamResponseState <= UPSTREAM_RESPONSE_STORE;
                
                // We should be able to process a pixel next cycle, if available
                upstreamResponseFifoReadEnable <= !upstreamResponseFifoEmpty;
                // upstreamResponseReady delays upstreamResponseFifoReadEnable by one clock cycle
                // to synchronize upstreamResponseFifoReadData with upstreamResponseColumn
                upstreamResponseReady <= upstreamResponseFifoReadEnable;
            end

            UPSTREAM_RESPONSE_STORE: begin
                // If we had previously requested a pixel from the upstream FIFO
                if (upstreamResponseReady) begin
                    // Store the response in the appropriate line cache
                    if (upstreamResponseRow == cachedRowA) begin
                        cacheA[upstreamResponseColumn] <= upstreamResponseFifoReadData;
                    end else if (upstreamResponseRow == cachedRowB) begin
                        cacheB[upstreamResponseColumn] <= upstreamResponseFifoReadData;
                    end
                    
                    // If that was the last pixel of the chunk, start the next chunk or return to idle
                    if (upstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                        // Mark the current chunk's cache as valid and no longer pending
                        if (upstreamResponseRow == cachedRowA) begin
                            cachedChunkValidA[upstreamResponseChunk] <= 1'b1;
                            cachedChunkPendingA[upstreamResponseChunk] <= 1'b0;
                        end else if (upstreamResponseRow == cachedRowB) begin
                            cachedChunkValidB[upstreamResponseChunk] <= 1'b1;
                            cachedChunkPendingB[upstreamResponseChunk] <= 1'b0;
                        end
                        // Reset pixel counter
                        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                        
                        if (pendingUpstreamRequestFifoEmpty) begin
                            // No incoming chunk at this point, so return to idle
                            pendingUpstreamRequestFifoReadEnable <= 1'b0;
                            upstreamResponseFifoReadEnable <= 1'b0;
                            upstreamResponseReady <= 1'b0;
                            upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
                        end else begin
                            // Another chunk is incoming, so retrieve its request
                            pendingUpstreamRequestFifoReadEnable <= 1'b1;
                            
                            // Wait for pendingUpstreamRequestFifo to supply the next request
                            upstreamResponseState <= UPSTREAM_RESPONSE_READ;
                        end
                    end else begin
                        // Increment pixel counter
                        upstreamResponsePixelCount <= upstreamResponsePixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};

                        // Not the last pixel of the chunk, so do not retrieve the next chunk
                        pendingUpstreamRequestFifoReadEnable <= 1'b0;
                        
                        // We should be able to process a pixel next cycle, if available
                        
                        upstreamResponseReady <= upstreamResponseFifoReadEnable;
                        
                        if (upstreamResponsePixelCount == {{(CHUNK_BITS-1){1'b1}}, 1'b0}) begin
                            // Second to last pixel in the chunk, so stop reading response data until we grab the next pending request
                            upstreamResponseFifoReadEnable <= 1'b0;
                        end else begin
                            upstreamResponseFifoReadEnable <= !upstreamResponseFifoEmpty;
                        end
                    end
                end else begin
                    // We should be able to process a pixel next cycle, if available
                    upstreamResponseFifoReadEnable <= !upstreamResponseFifoEmpty;
                    upstreamResponseReady <= upstreamResponseFifoReadEnable;
                end
            end

            default: begin
                upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
            end

        endcase
        
        // Downstream response state machine - Once the line buffer cache contains the upstream data
        // required to respond, calculate scaled pixel data and write to downstream response FIFO
        case (downstreamResponseState)

            DOWNSTREAM_RESPONSE_IDLE: begin
                // Do not write any pixels into the response FIFO
                downstreamResponseFifoWriteEnable <= 1'b0;
                
                // Wait until we can grab a pending downstream response
                if (!pendingDownstreamResponseFifoEmpty) begin
                    pendingDownstreamResponseFifoReadEnable <= 1'b1;
                    downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                    downstreamResponseState <= DOWNSTREAM_RESPONSE_READ;
                end
            end
            
            DOWNSTREAM_RESPONSE_READ: begin
                // Do not write any pixels into the response FIFO
                downstreamResponseFifoWriteEnable <= 1'b0;
                // Pending downstream response should be available next cycle
                pendingDownstreamResponseFifoReadEnable <= 1'b0;

                downstreamResponseState <= DOWNSTREAM_RESPONSE_STORE;
            end

            DOWNSTREAM_RESPONSE_STORE: begin
                // If the source pixels are present in the cache, and the downstream response FIFO is not full
                if (((cachedRowA == downstreamCacheRowUpper && cachedChunkValidA[downstreamResponseChunk]) ||
                     (cachedRowB == downstreamCacheRowUpper && cachedChunkValidB[downstreamResponseChunk])) &&
                    ((cachedRowA == downstreamCacheRowLower && cachedChunkValidA[downstreamResponseChunk]) ||
                     (cachedRowB == downstreamCacheRowLower && cachedChunkValidB[downstreamResponseChunk])) &&
                    !downstreamResponseFifoFull) begin
                    if (cachedRowA == downstreamCacheRowUpper) begin
                        if (cachedRowA == downstreamCacheRowLower) begin
                            // Same upper and lower rows, so just send that pixel downstream
                            downstreamResponseFifoWriteData <= cacheA[downstreamResponseColumn];
                        end else begin
                            // Blend upper pixel with lower pixel
                            downstreamResponseFifoWriteData <=
                                blend(cacheA[downstreamResponseColumn], downstreamCoordUpperCoeff,
                                      cacheB[downstreamResponseColumn], downstreamCoordLowerCoeff);
                        end
                    end else begin
                        if (cachedRowB == downstreamCacheRowLower) begin
                            // Same upper and lower rows, so just send that pixel downstream
                            downstreamResponseFifoWriteData <= cacheB[downstreamResponseColumn];
                        end else begin
                            // Blend upper pixel with lower pixel
                            downstreamResponseFifoWriteData <=
                                blend(cacheB[downstreamResponseColumn], downstreamCoordUpperCoeff,
                                      cacheA[downstreamResponseColumn], downstreamCoordLowerCoeff);
                        end
                    end
                    
                    // Write to response fifo next cycle
                    downstreamResponseFifoWriteEnable <= 1'b1;
                    
                    // If second to last pixel of the chunk, then start reading the next pending response, if there is one
                    if (downstreamResponsePixelCount == {{(CHUNK_BITS-1){1'b1}}, 1'b0}) begin
                        // Not the last pixel in the chunk, so increment pixel counter
                        downstreamResponsePixelCount <= downstreamResponsePixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
                        
                        if (!pendingDownstreamResponseFifoEmpty) begin
                            // Read the next chunk
                            pendingDownstreamResponseFifoReadEnable <= 1'b1;
                        end
                    // If that was the last pixel of the chunk, start the next chunk or return to idle
                    end else if (downstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                        // Reset pixel counter
                        downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                        
                        if (pendingDownstreamResponseFifoReadEnable) begin
                            // If there is another pending downstream response being read, stay in DOWNSTREAM_RESPONSE_STORE
                            pendingDownstreamResponseFifoReadEnable <= 1'b0;
                            downstreamResponseState <= DOWNSTREAM_RESPONSE_STORE;
                        end else if (!pendingDownstreamResponseFifoEmpty) begin
                            // Read the next chunk
                            pendingDownstreamResponseFifoReadEnable <= 1'b1;
                            downstreamResponseState <= DOWNSTREAM_RESPONSE_READ;
                        end else begin
                            // No pending response chunk at this point, so return to idle
                            pendingDownstreamResponseFifoReadEnable <= 1'b0;
                            downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
                        end
                    end else begin
                        // Not the last pixel in the chunk, so increment pixel counter
                        downstreamResponsePixelCount <= downstreamResponsePixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
                        
                        // Not the second to last pixel of the chunk, so do not retrieve the next chunk
                        pendingDownstreamResponseFifoReadEnable <= 1'b0;
                    end
                end else begin
                    // Do not write any pixels into the response FIFO
                    downstreamResponseFifoWriteEnable <= 1'b0;
                    
                    // Do not grab another pending downstream response
                    pendingDownstreamResponseFifoReadEnable <= 1'b0;
                end
            end

            default: begin
                downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
            end

        endcase
    end
end

endmodule
