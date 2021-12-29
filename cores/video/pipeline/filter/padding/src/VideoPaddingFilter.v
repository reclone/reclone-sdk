//
// VideoPaddingFilter - Pad the sides of the video frame with a solid color
//
// This padding filter adds bars of a solid color to any side of the video frame.  To do this,
// it requires the dimensions of the source video frame, the amount to pad the left and top sides,
// and the desired padding color.  The source video frame is effectively shifted down and right
// by the specified padding amounts.  Any pixel requested outside of the shifted source
// frame rectangle is filled with the padding color.
//
// If the source video frame dimensions are specified as smaller than its actual dimensions,
// this filter will effectively trim off the bottom and/or right side of the source video,
// by replacing source video content with the padding color.
//
// The padding filter is useful for pillarboxing and/or letterboxing a smaller video frame
// inside a larger output resolution, without scaling.
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

module VideoPaddingFilter #(parameter CHUNK_BITS = 5)
(
    input wire scalerClock,
    input wire reset,
    
    // Padding configuration
    input wire [VACTIVE_BITS-1:0] padTopRows,
    input wire [HACTIVE_BITS-1:0] padLeftColumns,
    input wire [VACTIVE_BITS-1:0] sourceRows,
    input wire [HACTIVE_BITS-1:0] sourceColumns,
    input wire [BITS_PER_PIXEL-1:0] padColor,

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
localparam VACTIVE_BITS = 11;
localparam CHUNKNUM_BITS = HACTIVE_BITS - CHUNK_BITS;
localparam REQUEST_BITS = VACTIVE_BITS + CHUNKNUM_BITS;
localparam BITS_PER_PIXEL = 16;

// One-hot states for downstream request state machine
localparam DOWNSTREAM_REQUEST_IDLE  = 4'b0001,
           DOWNSTREAM_REQUEST_READ  = 4'b0010,
           DOWNSTREAM_REQUEST_STAGE = 4'b0100,
           DOWNSTREAM_REQUEST_STORE = 4'b1000;
reg[3:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

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
reg pendingUpstreamRequestFifoReadEnable = 1'b0;
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
wire pendingDownstreamResponseFifoReadEnable;
wire [HACTIVE_BITS:0] pendingDownstreamResponseFifoReadData;
reg pendingDownstreamResponseFifoWriteEnableReg = 1'b0;
wire pendingDownstreamResponseFifoWriteEnable = pendingDownstreamResponseFifoWriteEnableReg && !pendingDownstreamResponseFifoFull;
reg [HACTIVE_BITS:0] pendingDownstreamResponseFifoWriteData = {(HACTIVE_BITS+1){1'b0}};
SyncFifo #(.DATA_WIDTH(HACTIVE_BITS+1), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingDownstreamResponses
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

reg [REQUEST_BITS-1:0] downstreamRequestStaged = {REQUEST_BITS{1'b0}};
reg [REQUEST_BITS-1:0] lastUpstreamChunkRequest = {REQUEST_BITS{1'b1}};
reg [REQUEST_BITS-1:0] lastlastUpstreamChunkRequest = {REQUEST_BITS{1'b1}};

reg [CHUNK_BITS:0] downstreamRequestPixelCount = {(CHUNK_BITS+1){1'b0}};

wire [VACTIVE_BITS-1:0] downstreamRequestRow = downstreamRequestStaged[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [HACTIVE_BITS-1:0] downstreamRequestColumn = {downstreamRequestStaged[CHUNKNUM_BITS-1:0], downstreamRequestPixelCount[CHUNK_BITS-1:0]};
wire [VACTIVE_BITS-1:0] upstreamRequestRow = downstreamRequestRow - padTopRows;
wire [HACTIVE_BITS-1:0] upstreamRequestColumn = downstreamRequestColumn - padLeftColumns;
wire [CHUNKNUM_BITS-1:0] upstreamRequestChunk = upstreamRequestColumn[HACTIVE_BITS-1:HACTIVE_BITS-CHUNKNUM_BITS];
wire downstreamRequestIsPadding = (downstreamRequestRow < padTopRows) || (downstreamRequestRow >= padTopRows + sourceRows) ||
                                  (downstreamRequestColumn < padLeftColumns) || (downstreamRequestColumn >= padLeftColumns + sourceColumns);
wire [REQUEST_BITS-1:0] upstreamChunkRequest = {upstreamRequestRow, upstreamRequestChunk};


// Two upstream chunk caches, so that we can read from one while filling the other
reg [CHUNKNUM_BITS-1:0] cachedChunkNumA = {CHUNKNUM_BITS{1'b1}};
reg [CHUNKNUM_BITS-1:0] cachedChunkNumB = {CHUNKNUM_BITS{1'b1}};
reg [BITS_PER_PIXEL-1:0] cachedChunkA [0:CHUNK_SIZE-1];
reg [BITS_PER_PIXEL-1:0] cachedChunkB [0:CHUNK_SIZE-1];

// Flag to keep track of which cached chunk is older
reg cachedChunkBIsOlder = 1'b0;
// Flags indicating whether the cached chunks are valid (filled completely with pixel data
reg cachedChunkAValid = 1'b0;
reg cachedChunkBValid = 1'b0;


reg upstreamResponseFifoReadEnableReg = 1'b0;
assign upstreamResponseFifoReadEnable = upstreamResponseFifoReadEnableReg && !upstreamResponseFifoEmpty;

reg storeUpstreamResponse = 1'b0;
reg storeUpstreamResponseToCacheB = 1'b0;
reg [CHUNK_BITS-1:0] storeUpstreamResponsePixelCount = {CHUNK_BITS{1'b1}};

// Flags to track whether the downstream state machine still needs cached chunk A or B
reg downstreamPixelIsPadding = 1'b0;
reg [CHUNKNUM_BITS-1:0] downstreamPixelChunk = {CHUNKNUM_BITS{1'b1}};
reg [CHUNK_BITS-1:0] downstreamPixelWhole = {CHUNK_BITS{1'b1}};
wire downstreamPixelInCacheA = (downstreamPixelChunk == cachedChunkNumA);
wire downstreamPixelInCacheB = (downstreamPixelChunk == cachedChunkNumB);
// Do not discard either chunk while we are providing padding color
wire downstreamNeedsCachedChunkA = (downstreamPixelInCacheA || downstreamPixelIsPadding);
wire downstreamNeedsCachedChunkB = (downstreamPixelInCacheB || downstreamPixelIsPadding);

wire downstreamPixelIsCached = (downstreamPixelInCacheA && cachedChunkAValid) || (downstreamPixelInCacheB && cachedChunkBValid);

reg downstreamResponseFifoWriteEnableReg = 1'b0;
assign downstreamResponseFifoWriteEnable =  !downstreamResponseStall && downstreamResponseFifoWriteEnableReg;
wire [BITS_PER_PIXEL-1:0] downstreamPixelColorCached = (downstreamPixelInCacheA ? cachedChunkA[downstreamPixelWhole] : cachedChunkB[downstreamPixelWhole]);
//reg [BITS_PER_PIXEL-1:0] downstreamPixelColorCached = {BITS_PER_PIXEL{1'b0}};
//assign downstreamResponseFifoWriteData = downstreamPixelIsPadding ? padColor : downstreamPixelColorCached;

// Available flag is delayed copy of pendingDownstreamResponseFifoReadEnable
reg pendingDownstreamResponseAvailable = 1'b0;
// Ready flag is delayed copy of available flag
reg pendingDownstreamResponseReady = 1'b0;

// Read the next pending downstream response coord as long as the downstream response fifo can receive it
reg pendingDownstreamResponseFifoReadEnableReg = 1'b0;
assign pendingDownstreamResponseFifoReadEnable = !downstreamResponseStall &&
                                                 !pendingDownstreamResponseFifoEmpty &&
                                                 pendingDownstreamResponseFifoReadEnableReg;

wire downstreamResponseStall = downstreamResponseFifoFull ||
                                (pendingDownstreamResponseReady &&
                                 (!downstreamPixelIsCached && !downstreamPixelIsPadding));

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        downstreamRequestStaged <= {REQUEST_BITS{1'b0}};
        upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
        downstreamRequestFifoReadEnableReg <= 1'b0;
        upstreamRequestFifoWriteEnable <= 1'b0;
        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
        pendingUpstreamRequestFifoReadEnable <= 1'b0;
        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
        pendingDownstreamResponseFifoWriteData <= {(HACTIVE_BITS+1){1'b0}};
        lastUpstreamChunkRequest <= {REQUEST_BITS{1'b1}};
        lastlastUpstreamChunkRequest <= {REQUEST_BITS{1'b1}};
        downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b0}};
        cachedChunkNumA <= {CHUNKNUM_BITS{1'b1}};
        cachedChunkNumB <= {CHUNKNUM_BITS{1'b1}};
        cachedChunkBIsOlder <= 1'b0;
        cachedChunkAValid <= 1'b0;
        cachedChunkBValid <= 1'b0;
        upstreamResponseFifoReadEnableReg <= 1'b0;
        storeUpstreamResponse <= 1'b0;
        storeUpstreamResponseToCacheB <= 1'b0;
        storeUpstreamResponsePixelCount <= {CHUNK_BITS{1'b1}};
        pendingDownstreamResponseFifoReadEnableReg <= 1'b0;
        pendingDownstreamResponseAvailable <= 1'b0;
        pendingDownstreamResponseReady <= 1'b0;
        downstreamPixelIsPadding <= 1'b0;
        downstreamPixelChunk <= {CHUNKNUM_BITS{1'b1}};
        downstreamPixelWhole <= {CHUNK_BITS{1'b1}};
        downstreamResponseFifoWriteEnableReg <= 1'b0;
        downstreamResponseFifoWriteData <= {BITS_PER_PIXEL{1'b0}};
    end else begin
    
        // Request state machine - Get downstream chunk requests, translate chunk coordinates,
        //                         and enqueue upstream chunk requests
        case (downstreamRequestState)
            DOWNSTREAM_REQUEST_IDLE: begin
                // Reset write enables if coming from DOWNSTREAM_REQUEST_STORE
                upstreamRequestFifoWriteEnable <= 1'b0;
                if (pendingDownstreamResponseFifoWriteEnable) begin
                    pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
                end
            
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
                if (pendingDownstreamResponseFifoWriteEnable) begin
                    pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
                end
                
                // Make sure again that the FIFOs have the space to receive new requests because last cycle
                // pendingDownstreamResponseFifoWriteEnable could have caused pendingDownstreamResponseFifoFull
                if (!pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STAGE;
                end
            end
            
            DOWNSTREAM_REQUEST_STAGE: begin
                // Stage the downstream request to improve timing
                downstreamRequestStaged <= downstreamRequestFifoReadData;
                if (pendingDownstreamResponseFifoWriteEnable) begin
                    pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
                end
                
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
                    if (!downstreamRequestIsPadding && lastUpstreamChunkRequest != upstreamChunkRequest && lastlastUpstreamChunkRequest != upstreamChunkRequest) begin
                        // Submit upstreamChunkRequest
                        lastUpstreamChunkRequest <= upstreamChunkRequest;
                        lastlastUpstreamChunkRequest <= lastUpstreamChunkRequest;
                        upstreamRequestFifoWriteData <= upstreamChunkRequest;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                    end else begin
                        // No additional upstream request needed
                        upstreamRequestFifoWriteEnable <= 1'b0;
                    end
                    
                    // Save horizontal column as pending downstream response,
                    // and set flag for whether the padding color should be used
                    pendingDownstreamResponseFifoWriteData <= {downstreamRequestIsPadding, upstreamRequestColumn};
                    pendingDownstreamResponseFifoWriteEnableReg <= 1'b1;
                    
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
                            downstreamRequestState <= DOWNSTREAM_REQUEST_STAGE;
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
                upstreamResponseFifoReadEnableReg <= 1'b0;
                storeUpstreamResponse <= 1'b0;
            end

            UPSTREAM_RESPONSE_READ: begin
                // Next cycle the request item should be available
                pendingUpstreamRequestFifoReadEnable <= 1'b0;
                storeUpstreamResponse <= 1'b0;
                
                // Determine which cache chunk will store the upstream response
                if (!cachedChunkBIsOlder && !downstreamNeedsCachedChunkA) begin
                    // This upstream response will soon be stored in cache A
                    upstreamResponseState <= UPSTREAM_RESPONSE_STORE;
                    upstreamResponseFifoReadEnableReg <= 1'b1;
                end else if (cachedChunkBIsOlder && !downstreamNeedsCachedChunkB) begin
                    // This upstream response will soon be stored in cache B
                    upstreamResponseState <= UPSTREAM_RESPONSE_STORE;
                    upstreamResponseFifoReadEnableReg <= 1'b1;
                end
                // else downstream is still using the older cache chunk, so wait till finished using it
            end

            UPSTREAM_RESPONSE_STORE: begin
                // pendingUpstreamRequestFifoReadData has the pending upstream request (chunk number)
                
                if (upstreamResponseFifoReadEnable) begin
                    // Combinatorial logic says we are about to read an upstream response pixel
                    // Save its pixel count and destination cache so it can be stored to cache next cycle
                    storeUpstreamResponse <= 1'b1;
                    storeUpstreamResponseToCacheB <= cachedChunkBIsOlder;
                    storeUpstreamResponsePixelCount <= upstreamResponsePixelCount;
                    
                    // If that was the last pixel of the chunk, start the next chunk or return to idle
                    if (upstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                        // Reset pixel counter
                        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                        // Flip the flag indicating which chunk cache is older
                        cachedChunkBIsOlder <= !cachedChunkBIsOlder;
                        
                        if (!pendingUpstreamRequestFifoEmpty) begin
                            // Another upstream request needs to be handled, so read it
                            pendingUpstreamRequestFifoReadEnable <= 1'b1;
                            upstreamResponseFifoReadEnableReg <= 1'b0;
                            upstreamResponseState <= UPSTREAM_RESPONSE_READ;
                        end else begin
                            // No more upstream requests, so return to idle
                            upstreamResponseFifoReadEnableReg <= 1'b0;
                            upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
                        end
                    end else begin
                        // Not the last pixel in the chunk, so increment pixel counter
                        upstreamResponsePixelCount <= upstreamResponsePixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
                    end
                    
                end else begin
                    storeUpstreamResponse <= 1'b0;
                end
            end

            default: begin
                upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
            end
        endcase
        
        // Store the upstream response pixel as directed by the upstream response state machine
        if (storeUpstreamResponse) begin
            if (!storeUpstreamResponseToCacheB) begin
                // Store upstream pixel to cache A
                cachedChunkA[storeUpstreamResponsePixelCount] <= upstreamResponseFifoReadData;
                // Mark the cache being updated with the chunk number
                cachedChunkNumA <= pendingUpstreamRequestFifoReadData;
                
                if (storeUpstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                    // Last pixel in chunk is stored, so mark the cache valid
                    cachedChunkAValid <= 1'b1;
                end else begin
                    // Chunk is only partially cached, so clear valid flag
                    cachedChunkAValid <= 1'b0;
                end
            end else begin
                // Store upstream pixel to cache B
                cachedChunkB[storeUpstreamResponsePixelCount] <= upstreamResponseFifoReadData;
                // Mark the cache being updated with the chunk number
                cachedChunkNumB <= pendingUpstreamRequestFifoReadData;
                
                if (storeUpstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                    // Last pixel in chunk is stored, so mark the cache valid
                    cachedChunkBValid <= 1'b1;
                end else begin
                    // Chunk is only partially cached, so clear valid flag
                    cachedChunkBValid <= 1'b0;
                end
            end
        end
        
        // Downstream response pipeline
        if (!downstreamResponseStall) begin
            // STAGE 1 - Start reading from pending downstream response FIFO
            pendingDownstreamResponseFifoReadEnableReg <= !pendingDownstreamResponseFifoEmpty;
            
            // STAGE 2 - Pending downstream response should be available next cycle
            pendingDownstreamResponseAvailable <= !pendingDownstreamResponseFifoEmpty &&
                                                 pendingDownstreamResponseFifoReadEnableReg;
            
            // STAGE 3 - Register pendingDownstreamResponseFifoReadData to improve timing
            pendingDownstreamResponseReady <= pendingDownstreamResponseAvailable;
            downstreamPixelIsPadding <= pendingDownstreamResponseFifoReadData[HACTIVE_BITS];
            downstreamPixelChunk <= pendingDownstreamResponseFifoReadData[HACTIVE_BITS-1:HACTIVE_BITS-CHUNKNUM_BITS];
            downstreamPixelWhole <= pendingDownstreamResponseFifoReadData[CHUNK_BITS-1:0];
            
            // STAGE 4 - Determine final pixel color
            downstreamResponseFifoWriteEnableReg <= pendingDownstreamResponseReady;
            downstreamResponseFifoWriteData <= downstreamPixelIsPadding ? padColor : downstreamPixelColorCached;
        end
    end
end

endmodule
