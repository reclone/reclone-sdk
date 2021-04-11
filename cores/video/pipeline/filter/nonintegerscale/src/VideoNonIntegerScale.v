//
// VideoNonIntegerScale - Adjust size of frame by applying non-integer scaling in two dimensions
//
// Non-integer scaling applies a fractional fixed-point scale factor to the horizontal and vertical
// dimensions of the video frame.
//
// Scale factors are actually specified as "shrink factors" to avoid needing any divide operations
// in the fixed-point math.  The output resolution is expected to be calculated as follows:
//    (downstream dimension) = (upstream dimension) / (shrink factor)
// Therefore, 0.0 < (shrink factor) < 1.0 will increase the width or height of the video frame,
// whereas 1.0 < (shrink factor) < 2.0 will decrease the width or height.
// The shrink factor is also the size of each downstream pixel in the upstream coordinate system!
//
// Shrink factors of >= 2.0 cannot be specified because reducing the width or height by more than
// half will result in skipped pixels and cause the output to look crappy.  Instead, place a
// binning filter upstream of this scaler module to achieve >50% reduction in size.
//
// When useBilinearInterpolation is set to 1, bilinear interpolation will be applied, which
// "smooths" the scaled image.  Suggested: Always use bilinear interpolation when downscaling.
// When useBilinearInterpolation is set to 0, nearest-neighbor interpolation is used, which
// keeps pixel edges sharp and theoretically uses less upstream bandwidth, but causes some
// rows or columns to be visibly larger than others.
//
// This scaling module is implemented as three state machines that operate in parallel:
//
//  - Downstream Request State Machine
//      This state machine watches a FIFO that receives pixel chunk requests from the downstream
//      pipeline element.  For each downstream request received, upstream requests are created
//      based on the calculated upstream pixel position, if they have not already been requested.
//      This state machine also pushes the downstream request into a pending downstream response
//      FIFO, so that the request is handled later when cached pixel data is available.  The
//      coordinate calculation is pipelined to help ensure that the design achieves timing closure,
//      even when DSP blocks are inferred.
//
//  - Upstream Response State Machine
//      This state machine is responsible for copying requested upstream pixel data into the
//      line caches, and then setting bits in cachedChunkValid to indicate that those pixels are
//      received and ready for scaling.
//
//  - Downstream Response State Machine
//      This state machine actually handles the downstream chunk requests as soon as the required
//      pixel data is available in the line caches.  For each pixel, once the required
//      cachedChunkValid bits are set, the downstream pixel color is calculated from up to four
//      cached pixels.  The color calculation is pipelined to help ensure that the design achieves
//      timing closure, even when DSP blocks are inferred.
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

module VideoNonIntegerScale #(parameter CHUNK_BITS = 5, SCALE_FRACTION_BITS = 6)
(
    input wire scalerClock,
    input wire reset,

    // Scaling configuration
    input wire enableNonIntegerScaling,
    input wire useBilinearInterpolation,
    input wire [SCALE_BITS-1:0] hShrinkFactor,
    input wire [SCALE_BITS-1:0] vShrinkFactor,
    
    // Filter module reads from the downstream request FIFO...
    output wire downstreamRequestFifoReadEnable,
    input wire downstreamRequestFifoEmpty,
    input wire [REQUEST_BITS-1:0] downstreamRequestFifoReadData,
    // ...and writes to the downstream response FIFO.
    output wire downstreamResponseFifoWriteEnable,
    input wire downstreamResponseFifoFull,
    output wire [BITS_PER_PIXEL-1:0] downstreamResponseFifoWriteData,
    
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
localparam VCOORD_BITS = VACTIVE_BITS + SCALE_FRACTION_BITS;
localparam COORDS_BITS = VCOORD_BITS + HCOORD_BITS;

// One-hot states for downstream request state machine
localparam DOWNSTREAM_REQUEST_IDLE = 4'b0001, DOWNSTREAM_REQUEST_READ = 4'b0010, DOWNSTREAM_REQUEST_STORE = 4'b0100, DOWNSTREAM_REQUEST_STALL = 4'b1000;
reg[3:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

// One-hot states for upstream response state machine
localparam UPSTREAM_RESPONSE_IDLE = 3'b001, UPSTREAM_RESPONSE_READ = 3'b010, UPSTREAM_RESPONSE_STORE = 3'b100;
reg [2:0] upstreamResponseState = UPSTREAM_RESPONSE_IDLE;

// One-hot states for downstream response state machine
localparam DOWNSTREAM_RESPONSE_IDLE = 3'b001, DOWNSTREAM_RESPONSE_READ = 3'b010, DOWNSTREAM_RESPONSE_STORE = 3'b100;
reg [2:0] downstreamResponseState = DOWNSTREAM_RESPONSE_IDLE;

wire [VACTIVE_BITS-1:0] requestedRow = downstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] requestedChunk = downstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS:0] downstreamRequestPixelCount = {(CHUNK_BITS+1){1'b0}};
wire [HACTIVE_BITS-1:0] requestedColumn = {requestedChunk, downstreamRequestPixelCount[CHUNK_BITS-1:0]};
reg [HCOORD_BITS-1:0] upstreamHCoord = {HCOORD_BITS{1'b0}};
reg [VCOORD_BITS-1:0] upstreamVCoord = {VCOORD_BITS{1'b0}};
reg upstreamCoordsValid = 1'b0;

wire [HACTIVE_BITS-1:0] upstreamHCoordWhole = upstreamHCoord[HCOORD_BITS-1:SCALE_FRACTION_BITS];
wire [HACTIVE_BITS-1:0] upstreamHCoordWholeNext = upstreamHCoordWhole + {{(HACTIVE_BITS-1){1'b0}}, 1'b1};
wire [CHUNKNUM_BITS-1:0] upstreamHCoordChunk = upstreamHCoordWhole[HACTIVE_BITS-1:CHUNK_BITS];
wire [CHUNKNUM_BITS-1:0] upstreamHCoordChunkNext = upstreamHCoordWholeNext[HACTIVE_BITS-1:CHUNK_BITS];
wire [SCALE_FRACTION_BITS-1:0] upstreamHCoordFraction = upstreamHCoord[SCALE_FRACTION_BITS-1:0];
wire [VACTIVE_BITS-1:0] upstreamVCoordWhole = upstreamVCoord[VCOORD_BITS-1:SCALE_FRACTION_BITS];
wire [VACTIVE_BITS-1:0] upstreamVCoordWholeNext = upstreamVCoordWhole + {{(VACTIVE_BITS-1){1'b0}}, 1'b1};
wire [SCALE_FRACTION_BITS-1:0] upstreamVCoordFraction = upstreamVCoord[SCALE_FRACTION_BITS-1:0];
reg [REQUEST_BITS-1:0] newUpstreamRequests [0:3];
reg [3:0] newUpstreamRequestsValid = 4'b0000;
reg [VACTIVE_BITS-1:0] upstreamRequestRow = {VACTIVE_BITS{1'b0}};


// Two line buffers that cache upstream pixel chunks for two different rows

reg [VACTIVE_BITS-1:0] cachedRowA = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [BITS_PER_PIXEL-1:0] cacheA [0:HACTIVE_COLUMNS-1];

reg [VACTIVE_BITS-1:0] cachedRowB = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidB = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingB = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [BITS_PER_PIXEL-1:0] cacheB [0:HACTIVE_COLUMNS-1];

// Flag that indicates which cache slot should be replaced next
reg cachedRowBIsOlder = 1'b0;

wire [VACTIVE_BITS-1:0] upstreamResponseRow = pendingUpstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] upstreamResponseChunk = pendingUpstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS-1:0] upstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
wire [HACTIVE_BITS-1:0] upstreamResponseColumn = {upstreamResponseChunk, upstreamResponsePixelCount};

// upstreamRequests FIFO provides chunk requests to the upstream pipeline element
reg upstreamRequestFifoWriteEnable = 1'b0;
wire upstreamRequestFifoFull;
reg [REQUEST_BITS-1:0] upstreamRequestFifoWriteData = {REQUEST_BITS{1'b0}};
wire upstreamRequestFifoReadEnableScaling;
wire [REQUEST_BITS-1:0] upstreamRequestFifoReadDataScaling;
wire upstreamRequestFifoEmptyScaling;
SyncFifo #(.DATA_WIDTH(REQUEST_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) upstreamRequests
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(upstreamRequestFifoReadEnableScaling),
    .empty(upstreamRequestFifoEmptyScaling),
    .readData(upstreamRequestFifoReadDataScaling),
    .writeEnable(upstreamRequestFifoWriteEnable),
    .full(upstreamRequestFifoFull),
    .writeData(upstreamRequestFifoWriteData)
);

reg upstreamResponseFifoReadEnable = 1'b0;
reg upstreamResponseReady = 1'b0;
wire upstreamResponseFifoEmpty;
wire [BITS_PER_PIXEL-1:0] upstreamResponseFifoReadData;
wire upstreamResponseFifoFullScaling;
// upstreamResponses FIFO receives pixel data from the upstream pipeline element
SyncFifo #(.DATA_WIDTH(BITS_PER_PIXEL), .ADDR_WIDTH(CHUNK_BITS)) upstreamResponses
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(upstreamResponseFifoReadEnable),
    .empty(upstreamResponseFifoEmpty),
    .readData(upstreamResponseFifoReadData),
    .writeEnable(upstreamResponseFifoWriteEnable),
    .full(upstreamResponseFifoFullScaling),
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
// so that they can be handled as soon as required pixel data is cached.
// This cache actually contains the full precision fixed-point coordinates of each pending
// downstream pixel (in the coordinate system of the upstream video frame).
wire pendingDownstreamResponseFifoFull;
wire pendingDownstreamResponseFifoEmpty;
reg pendingDownstreamResponseFifoReadEnable = 1'b0;
wire [COORDS_BITS-1:0] pendingDownstreamResponseFifoReadData;
reg pendingDownstreamResponseFifoWriteEnable = 1'b0;
reg [COORDS_BITS-1:0] pendingDownstreamResponseFifoWriteData = {COORDS_BITS{1'b0}};
SyncFifo #(.DATA_WIDTH(COORDS_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingDownstreamResponses
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

reg downstreamResponseFifoWriteEnableScaling = 1'b0;
reg downstreamRequestFifoReadEnableScaling = 1'b0;

reg [BITS_PER_PIXEL-1:0] blendedPixel = {BITS_PER_PIXEL{1'b0}};

// Short-circuit this module if enableNonIntegerScaling == 0
assign downstreamResponseFifoWriteData = enableNonIntegerScaling ? blendedPixel : upstreamResponseFifoWriteData;
assign downstreamResponseFifoWriteEnable = enableNonIntegerScaling ? downstreamResponseFifoWriteEnableScaling : upstreamResponseFifoWriteEnable;
assign upstreamRequestFifoReadData = enableNonIntegerScaling ? upstreamRequestFifoReadDataScaling : downstreamRequestFifoReadData;
assign upstreamRequestFifoEmpty = enableNonIntegerScaling ? upstreamRequestFifoEmptyScaling : downstreamRequestFifoEmpty;
assign upstreamRequestFifoReadEnableScaling = enableNonIntegerScaling ? upstreamRequestFifoReadEnable : 1'b0;
assign downstreamRequestFifoReadEnable = enableNonIntegerScaling ? downstreamRequestFifoReadEnableScaling : upstreamRequestFifoReadEnable;
assign upstreamResponseFifoFull = enableNonIntegerScaling ? upstreamResponseFifoFullScaling : downstreamResponseFifoFull;

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        upstreamResponseFifoReadEnable <= 1'b0;
        upstreamRequestFifoWriteEnable <= 1'b0;
        pendingDownstreamResponseFifoWriteEnable <= 1'b0;
        pendingDownstreamResponseFifoReadEnable <= 1'b0;
        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
        upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        upstreamResponseReady <= 1'b0;
        //downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
        cachedRowA <= {VACTIVE_BITS{1'b1}};
        cachedChunkValidA <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedChunkPendingA <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedRowB <= {VACTIVE_BITS{1'b1}};
        cachedChunkValidB <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedChunkPendingB <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedRowBIsOlder <= 1'b0;
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b0}};
        upstreamHCoord <= {HCOORD_BITS{1'b0}};
        upstreamVCoord <= {VCOORD_BITS{1'b0}};
        upstreamCoordsValid <= 1'b0;
        newUpstreamRequestsValid <= 4'b0000;
        upstreamRequestRow <= {VACTIVE_BITS{1'b0}};
        pendingDownstreamResponseFifoWriteData <= {COORDS_BITS{1'b0}};
        downstreamResponseFifoWriteEnableScaling <= 1'b0;
        blendedPixel <= {BITS_PER_PIXEL{1'b0}};
        downstreamRequestFifoReadEnableScaling <= 1'b0;
    end else begin
        
        // Request state machine - Get downstream chunk requests, translate pixel coordinates,
        //                         and enqueue upstream chunk requests
        case (downstreamRequestState)
            DOWNSTREAM_REQUEST_IDLE: begin
                // Reset write enables if coming from DOWNSTREAM_REQUEST_STORE or DOWNSTREAM_REQUEST_STALL
                upstreamRequestFifoWriteEnable <= 1'b0;
                pendingDownstreamResponseFifoWriteEnable <= 1'b0;
            
                // Wait for a request
                if (enableNonIntegerScaling && 
                        !downstreamRequestFifoEmpty && !pendingUpstreamRequestFifoFull &&
                        !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    // Read the request
                    // It should be available during DOWNSTREAM_REQUEST_STORE
                    downstreamRequestFifoReadEnableScaling <= 1'b1;
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_READ;
                end
            end

            DOWNSTREAM_REQUEST_READ: begin
                // Request should be available next cycle
                downstreamRequestFifoReadEnableScaling <= 1'b0;
                
                // Make sure again that the FIFOs have the space to receive new requests because last cycle
                // pendingDownstreamResponseFifoWriteEnable could have caused pendingDownstreamResponseFifoFull
                if (!pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
                    downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b0}};
                    upstreamCoordsValid <= 1'b0;
                end
            end

            DOWNSTREAM_REQUEST_STORE: begin
            
                if (!pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    
                    // First stage - determine coordinates of downstream pixel in upstream coordinate system
                    
                    if (downstreamRequestPixelCount[CHUNK_BITS]) begin
                        // Finished with all the pixels in a request, and the next request was not available,
                        // so stay idle and let the other stages finish up.
                        // The only way back will be through DOWNSTREAM_REQUEST_IDLE
                        upstreamCoordsValid <= 1'b0;
                    end else begin
                        // For proper coordinate calculation without introducing a shift,
                        // need to consider half-pixel offsets and scale as follows:
                        //  upstream coord = (downstream coord + 0.5) / (scale factor) - 0.5
                        //                 = (downstream coord) * (shrink factor) + (shrink factor / 2) - 0.5
                        // This calculation can yield negative coordinate values for the first one or more
                        // pixels of a row, if shrink factor is < 1.  To simplify the logic and stick with
                        // unsigned numbers, the final "-0.5" is only applied for shrink factors >= 1.
                        upstreamHCoord <= requestedColumn * hShrinkFactor + 
                                          {{(HCOORD_BITS-SCALE_BITS+1){1'b0}}, hShrinkFactor[SCALE_BITS-1:1]} -
                                          (hShrinkFactor[SCALE_BITS-1] ? 
                                           {{(HCOORD_BITS-SCALE_FRACTION_BITS){1'b0}}, 1'b1, {(SCALE_FRACTION_BITS-1){1'b0}}} :
                                           {HCOORD_BITS{1'b0}});
                        upstreamVCoord <= requestedRow * vShrinkFactor + 
                                          {{(VCOORD_BITS-SCALE_BITS+1){1'b0}}, vShrinkFactor[SCALE_BITS-1:1]} -
                                          (vShrinkFactor[SCALE_BITS-1] ? 
                                           {{(VCOORD_BITS-SCALE_FRACTION_BITS){1'b0}}, 1'b1, {(SCALE_FRACTION_BITS-1){1'b0}}} :
                                           {VCOORD_BITS{1'b0}});
                        upstreamCoordsValid <= 1'b1;
                        
                        // If second to last pixel of the chunk, then start reading the next request, if there is one
                        if (downstreamRequestPixelCount == {1'b0, {(CHUNK_BITS-1){1'b1}}, 1'b0}) begin
                            downstreamRequestPixelCount <= downstreamRequestPixelCount + {{CHUNK_BITS{1'b0}}, 1'b1};
                            if (!downstreamRequestFifoEmpty) begin
                                downstreamRequestFifoReadEnableScaling <= 1'b1;
                            end
                        // If that was the last pixel of the chunk
                        end else if (downstreamRequestPixelCount == {1'b0, {CHUNK_BITS{1'b1}}}) begin
                            if (downstreamRequestFifoReadEnableScaling) begin
                                // Start working the next request
                                downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b0}};
                                downstreamRequestFifoReadEnableScaling <= 1'b0;
                            end else begin
                                // Do not process another request
                                downstreamRequestPixelCount <= downstreamRequestPixelCount + {{CHUNK_BITS{1'b0}}, 1'b1};
                            end
                        end else begin
                            downstreamRequestPixelCount <= downstreamRequestPixelCount + {{CHUNK_BITS{1'b0}}, 1'b1};
                        end
                        
                    end
                    
                    // Second stage - determine needed upstream requests and push coordinates as a pending downstream response
                    
                    if (upstreamCoordsValid) begin
                        if (useBilinearInterpolation) begin
                            // Upper left chunk - always needed
                            newUpstreamRequests[0] <= {upstreamVCoordWhole, upstreamHCoordChunk};
                            newUpstreamRequestsValid[0] <= 1'b1;
                            
                            // Lower left chunk
                            if (upstreamVCoordFraction != {SCALE_FRACTION_BITS{1'b0}}) begin
                                // Nonzero fractional part for vertical coordinate, so the next row IS needed
                                newUpstreamRequests[1] <= {(upstreamVCoordWhole + {{(VACTIVE_BITS-1){1'b0}}, 1'b1}), upstreamHCoordChunk};
                                newUpstreamRequestsValid[1] <= 1'b1;
                            end
                            
                            // Right chunks
                            if (upstreamHCoordFraction != {SCALE_FRACTION_BITS{1'b0}}) begin
                                // Nonzero fractional part for horizontal coordinate, so the next chunk column may be needed
                                
                                // Upper right chunk
                                newUpstreamRequests[2] <= {upstreamVCoordWhole, upstreamHCoordChunkNext};
                                newUpstreamRequestsValid[2] <= 1'b1;
                                
                                // Lower right chunk
                                if (upstreamVCoordFraction != {SCALE_FRACTION_BITS{1'b0}}) begin
                                    // Nonzero fractional part for vertical coordinate, so the next row IS needed
                                    newUpstreamRequests[3] <= {(upstreamVCoordWhole + {{(VACTIVE_BITS-1){1'b0}}, 1'b1}), upstreamHCoordChunkNext};
                                    newUpstreamRequestsValid[3] <= 1'b1;
                                end
                            end
                            pendingDownstreamResponseFifoWriteData <= {upstreamVCoord, upstreamHCoord};
                        end else begin
                            // Determine the nearest neighbor.
                            // The coordinates pushed into pendingDownstreamResponseFifo are integers,
                            // with fraction bits forced to zero.
                            if (upstreamVCoordFraction[SCALE_FRACTION_BITS-1]) begin
                                // Lower row is nearer
                                if (upstreamHCoordFraction[SCALE_FRACTION_BITS-1]) begin
                                    // Lower right pixel is nearest
                                    newUpstreamRequests[3] <= {upstreamVCoordWholeNext, upstreamHCoordChunkNext};
                                    newUpstreamRequestsValid[3] <= 1'b1;
                                    pendingDownstreamResponseFifoWriteData <=
                                        {upstreamVCoordWholeNext, {SCALE_FRACTION_BITS{1'b0}}, upstreamHCoordWholeNext, {SCALE_FRACTION_BITS{1'b0}}};
                                end else begin
                                    // Lower left pixel is nearest
                                    newUpstreamRequests[1] <= {upstreamVCoordWholeNext, upstreamHCoordChunk};
                                    newUpstreamRequestsValid[1] <= 1'b1;
                                    pendingDownstreamResponseFifoWriteData <=
                                        {upstreamVCoordWholeNext, {SCALE_FRACTION_BITS{1'b0}}, upstreamHCoordWhole, {SCALE_FRACTION_BITS{1'b0}}};
                                end
                            end else begin
                                // Upper row is nearer
                                if (upstreamHCoordFraction[SCALE_FRACTION_BITS-1]) begin
                                    // Upper right pixel is nearest
                                    newUpstreamRequests[2] <= {upstreamVCoordWhole, upstreamHCoordChunkNext};
                                    newUpstreamRequestsValid[2] <= 1'b1;
                                    pendingDownstreamResponseFifoWriteData <=
                                        {upstreamVCoordWhole, {SCALE_FRACTION_BITS{1'b0}}, upstreamHCoordWholeNext, {SCALE_FRACTION_BITS{1'b0}}};
                                end else begin
                                    // Upper left pixel is nearest
                                    newUpstreamRequests[0] <= {upstreamVCoordWhole, upstreamHCoordChunk};
                                    newUpstreamRequestsValid[0] <= 1'b1;
                                    pendingDownstreamResponseFifoWriteData <=
                                        {upstreamVCoordWhole, {SCALE_FRACTION_BITS{1'b0}}, upstreamHCoordWhole, {SCALE_FRACTION_BITS{1'b0}}};
                                end
                            end
                        end
                        pendingDownstreamResponseFifoWriteEnable <= 1'b1;
                    end else begin
                        pendingDownstreamResponseFifoWriteEnable <= 1'b0;
                    end
                    
                    // Third stage - push upstream requests and determine whether to transition state
                    
                    if (newUpstreamRequestsValid[0]) begin
                        if (newUpstreamRequests[0][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowA) begin
                            if ( !cachedChunkValidA[newUpstreamRequests[0][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingA[newUpstreamRequests[0][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[0];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingA[newUpstreamRequests[0][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[0] <= 1'b0;
                        end else if (newUpstreamRequests[0][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowB) begin
                            if ( !cachedChunkValidB[newUpstreamRequests[0][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingB[newUpstreamRequests[0][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[0];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingB[newUpstreamRequests[0][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[0] <= 1'b0;
                        end else begin
                            // Stall until we can transition a row cache to the new row number
                            upstreamRequestRow <= newUpstreamRequests[0][REQUEST_BITS-1:CHUNKNUM_BITS];
                            downstreamRequestState <= DOWNSTREAM_REQUEST_STALL;
                        end
                    end else if (newUpstreamRequestsValid[1]) begin
                        if (newUpstreamRequests[1][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowA) begin
                            if ( !cachedChunkValidA[newUpstreamRequests[1][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingA[newUpstreamRequests[1][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[1];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingA[newUpstreamRequests[1][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[1] <= 1'b0;
                        end else if (newUpstreamRequests[1][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowB) begin
                            if ( !cachedChunkValidB[newUpstreamRequests[1][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingB[newUpstreamRequests[1][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[1];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingB[newUpstreamRequests[1][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[1] <= 1'b0;
                        end else begin
                            // Stall until we can transition a row cache to the new row number
                            upstreamRequestRow <= newUpstreamRequests[1][REQUEST_BITS-1:CHUNKNUM_BITS];
                            downstreamRequestState <= DOWNSTREAM_REQUEST_STALL;
                        end
                    end else if (newUpstreamRequestsValid[2]) begin
                        if (newUpstreamRequests[2][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowA) begin
                            if ( !cachedChunkValidA[newUpstreamRequests[2][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingA[newUpstreamRequests[2][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[2];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingA[newUpstreamRequests[2][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[2] <= 1'b0;
                        end else if (newUpstreamRequests[2][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowB) begin
                            if ( !cachedChunkValidB[newUpstreamRequests[2][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingB[newUpstreamRequests[2][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[2];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingB[newUpstreamRequests[2][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[2] <= 1'b0;
                        end else begin
                            // Stall until we can transition a row cache to the new row number
                            upstreamRequestRow <= newUpstreamRequests[2][REQUEST_BITS-1:CHUNKNUM_BITS];
                            downstreamRequestState <= DOWNSTREAM_REQUEST_STALL;
                        end
                    end else if (newUpstreamRequestsValid[3]) begin
                        if (newUpstreamRequests[3][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowA) begin
                            if ( !cachedChunkValidA[newUpstreamRequests[3][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingA[newUpstreamRequests[3][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[3];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingA[newUpstreamRequests[3][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[3] <= 1'b0;
                        end else if (newUpstreamRequests[3][REQUEST_BITS-1:CHUNKNUM_BITS] == cachedRowB) begin
                            if ( !cachedChunkValidB[newUpstreamRequests[3][CHUNKNUM_BITS-1:0]] &&
                                 !cachedChunkPendingB[newUpstreamRequests[3][CHUNKNUM_BITS-1:0]]) begin
                                // Enqueue the upstream request
                                upstreamRequestFifoWriteData <= newUpstreamRequests[3];
                                upstreamRequestFifoWriteEnable <= 1'b1;
                                // Do not repeat this request while it is in progress
                                cachedChunkPendingB[newUpstreamRequests[3][CHUNKNUM_BITS-1:0]] <= 1'b1;
                            end
                            newUpstreamRequestsValid[3] <= 1'b0;
                        end else begin
                            // Stall until we can transition a row cache to the new row number
                            upstreamRequestRow <= newUpstreamRequests[1][REQUEST_BITS-1:CHUNKNUM_BITS];
                            downstreamRequestState <= DOWNSTREAM_REQUEST_STALL;
                        end
                    end else begin
                        // Nothing to write into the upstream request FIFOs
                        upstreamRequestFifoWriteEnable <= 1'b0;
                        
                        // If we are done processing downstream requests for now
                        if (downstreamRequestPixelCount[CHUNK_BITS] && !upstreamCoordsValid) begin
                            // Transition back to idle
                            downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
                        end
                    end
                    
                end else begin
                    pendingDownstreamResponseFifoWriteEnable <= 1'b0;
                    downstreamRequestFifoReadEnableScaling <= 1'b0;
                end
            end
            
            DOWNSTREAM_REQUEST_STALL: begin
                // Stall until all pending requests are complete, then start the new row
                if (pendingUpstreamRequestFifoEmpty && pendingDownstreamResponseFifoEmpty && 
                    upstreamResponseState == UPSTREAM_RESPONSE_IDLE &&
                    downstreamResponseState == DOWNSTREAM_RESPONSE_IDLE) begin
                    // Requested row does not match the row cached by the line buffer,
                    // so reset all of the cachedChunkValid bits and update cachedRow
                    if (cachedRowBIsOlder) begin
                        cachedRowB <= upstreamRequestRow;
                        cachedChunkValidB <= {MAX_CHUNKS_PER_ROW{1'b0}};
                        cachedRowBIsOlder <= 1'b0;
                    end else begin
                        cachedRowA <= upstreamRequestRow;
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
        

        
    end
end

endmodule
