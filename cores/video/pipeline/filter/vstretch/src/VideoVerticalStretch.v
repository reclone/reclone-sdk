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
    output reg downstreamRequestFifoReadEnable = 1'b0,
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
localparam VCOORD_BITS = VACTIVE_BITS + SCALE_FRACTION_BITS;
localparam COLOR_COMPONENT_BITS_MAX = 6;
localparam COLOR_WEIGHT_BITS = SCALE_FRACTION_BITS + COLOR_COMPONENT_BITS_MAX;

// One-hot states for downstream request state machine
localparam  DOWNSTREAM_REQUEST_IDLE  = 5'b00001,
            DOWNSTREAM_REQUEST_READ  = 5'b00010,
            DOWNSTREAM_REQUEST_CHECK = 5'b00100,
            DOWNSTREAM_REQUEST_STORE = 5'b01000,
            DOWNSTREAM_REQUEST_STALL = 5'b10000;
reg[4:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

// One-hot states for upstream response state machine
localparam  UPSTREAM_RESPONSE_IDLE = 3'b001,
            UPSTREAM_RESPONSE_READ = 3'b010,
            UPSTREAM_RESPONSE_STORE = 3'b100;
reg [2:0] upstreamResponseState = UPSTREAM_RESPONSE_IDLE;

// One-hot states for downstream response state machine
// localparam  DOWNSTREAM_RESPONSE_IDLE = 3'b001,
            // DOWNSTREAM_RESPONSE_READ = 3'b010,
            // DOWNSTREAM_RESPONSE_STORE = 3'b100;
// reg [2:0] downstreamResponseState = DOWNSTREAM_RESPONSE_IDLE;

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

reg upstreamResponseFifoReadEnableReg = 1'b0;
reg upstreamResponseReady = 1'b0;
wire upstreamResponseFifoEmpty;
wire upstreamResponseFifoReadEnable = upstreamResponseFifoReadEnableReg && !upstreamResponseFifoEmpty;
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
reg pendingUpstreamRequestFifoReadEnable = 1'b0;
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
wire pendingDownstreamResponseFifoReadEnable;
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

wire [VCOORD_BITS-1:0] upstreamRequestCoord = requestedRow * vShrinkFactor + {{(VACTIVE_BITS){1'b0}}, vShrinkFactor[SCALE_BITS-1:1]}
    - (vShrinkFactor[SCALE_BITS-1] ? {{VACTIVE_BITS{1'b0}}, 1'b1, {(SCALE_FRACTION_BITS-1){1'b0}}} : {VCOORD_BITS{1'b0}});
wire [VACTIVE_BITS-1:0] upstreamRequestCoordWhole = upstreamRequestCoord[VCOORD_BITS-1:SCALE_FRACTION_BITS];
wire [SCALE_FRACTION_BITS-1:0] upstreamRequestCoordFraction = upstreamRequestCoord[SCALE_FRACTION_BITS-1:0];
wire [VACTIVE_BITS-1:0] upstreamRequestRowUpper = upstreamRequestCoordWhole;
wire [VACTIVE_BITS-1:0] upstreamRequestRowLower = ~|upstreamRequestCoordFraction ? 
                            upstreamRequestRowUpper : upstreamRequestRowUpper + {{(VACTIVE_BITS-1){1'b0}}, 1'b1};

wire [REQUEST_BITS-1:0] upstreamRequestUpper = {upstreamRequestRowUpper, requestedChunk};
wire [REQUEST_BITS-1:0] upstreamRequestLower = {upstreamRequestRowLower, requestedChunk};
reg cachedChunkValidAStaged = 1'b0;
reg cachedChunkValidBStaged = 1'b0;
reg cachedChunkPendingAStaged = 1'b0;
reg cachedChunkPendingBStaged = 1'b0;

assign pendingDownstreamResponseFifoWriteData = {upstreamRequestCoord, requestedChunk};

reg [VACTIVE_BITS-1:0] cachedRowA = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingA = {MAX_CHUNKS_PER_ROW{1'b0}};
wire cacheWriteEnableA;
wire [HACTIVE_BITS-1:0] cacheWriteAddressA;
wire [BITS_PER_PIXEL-1:0] cacheWriteDataA;
wire cacheReadEnableA;
//reg [HACTIVE_BITS-1:0] cacheReadAddressA = {HACTIVE_BITS{1'b1}};
wire [HACTIVE_BITS-1:0] cacheReadAddressA;
wire [BITS_PER_PIXEL-1:0] cacheReadDataA;
BlockRamDualPort # (.DATA_WIDTH(BITS_PER_PIXEL), .ADDR_WIDTH(HACTIVE_BITS)) cacheA
(
    // Write Port
    .clockA(scalerClock),
    .enableA(1'b1),
    .writeEnableA(cacheWriteEnableA),
    .addressA(cacheWriteAddressA),
    .dataInA(cacheWriteDataA),
    .dataOutA(),
    
    // Read Port
    .clockB(scalerClock),
    .enableB(cacheReadEnableA),
    .writeEnableB(1'b0),
    .addressB(cacheReadAddressA),
    .dataInB({BITS_PER_PIXEL{1'b0}}),
    .dataOutB(cacheReadDataA)
);

reg [VACTIVE_BITS-1:0] cachedRowB = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidB = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingB = {MAX_CHUNKS_PER_ROW{1'b0}};
wire cacheWriteEnableB;
wire [HACTIVE_BITS-1:0] cacheWriteAddressB;
wire [BITS_PER_PIXEL-1:0] cacheWriteDataB;
wire cacheReadEnableB;
//reg [HACTIVE_BITS-1:0] cacheReadAddressB = {HACTIVE_BITS{1'b1}};
wire [HACTIVE_BITS-1:0] cacheReadAddressB;
wire [BITS_PER_PIXEL-1:0] cacheReadDataB;
BlockRamDualPort # (.DATA_WIDTH(BITS_PER_PIXEL), .ADDR_WIDTH(HACTIVE_BITS)) cacheB
(
    // Write Port
    .clockA(scalerClock),
    .enableA(1'b1),
    .writeEnableA(cacheWriteEnableB),
    .addressA(cacheWriteAddressB),
    .dataInA(cacheWriteDataB),
    .dataOutA(),
    
    // Read Port
    .clockB(scalerClock),
    .enableB(cacheReadEnableB),
    .writeEnableB(1'b0),
    .addressB(cacheReadAddressB),
    .dataInB({BITS_PER_PIXEL{1'b0}}),
    .dataOutB(cacheReadDataB)
);

reg cachedRowBIsOlder = 1'b0;

wire [VACTIVE_BITS-1:0] upstreamResponseRow = pendingUpstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] upstreamResponseChunk = pendingUpstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS-1:0] upstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
wire [HACTIVE_BITS-1:0] upstreamResponseColumn = {upstreamResponseChunk, upstreamResponsePixelCount};

// Write the upstream response to cache, when it's ready
assign cacheWriteAddressA = upstreamResponseColumn;
assign cacheWriteAddressB = upstreamResponseColumn;
assign cacheWriteDataA = upstreamResponseFifoReadData;
assign cacheWriteDataB = upstreamResponseFifoReadData;
assign cacheWriteEnableA = (upstreamResponseReady && (upstreamResponseRow == cachedRowA));
assign cacheWriteEnableB = (upstreamResponseReady && (upstreamResponseRow == cachedRowB));

wire [VCOORD_BITS-1:0] downstreamResponseCoord = pendingDownstreamResponseFifoReadData[SCALE_FRACTION_BITS+REQUEST_BITS-1:SCALE_FRACTION_BITS+REQUEST_BITS-VCOORD_BITS];
wire [VACTIVE_BITS-1:0] downstreamResponseCoordWhole = downstreamResponseCoord[VCOORD_BITS-1:SCALE_FRACTION_BITS];
wire [SCALE_FRACTION_BITS-1:0] downstreamResponseCoordFraction = downstreamResponseCoord[SCALE_FRACTION_BITS-1:0];
wire [CHUNKNUM_BITS-1:0] downstreamResponseChunk = pendingDownstreamResponseFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS:0] downstreamResponsePixelCount = {(CHUNK_BITS+1){1'b1}};
wire [HACTIVE_BITS-1:0] downstreamResponseColumn = {downstreamResponseChunk, downstreamResponsePixelCount[CHUNK_BITS-1:0]};

wire [VACTIVE_BITS-1:0] downstreamCacheRowUpper = downstreamResponseCoordWhole;
wire [VACTIVE_BITS-1:0] downstreamCacheRowLower = ~|downstreamResponseCoordFraction ? 
                            downstreamCacheRowUpper : downstreamCacheRowUpper + {{(VACTIVE_BITS-1){1'b0}}, 1'b1};

// wire [SCALE_BITS-1:0] downstreamCoordLowerCoeff = {1'b0, downstreamResponseCoord[SCALE_FRACTION_BITS-1:0]};
// wire [SCALE_BITS-1:0] downstreamCoordUpperCoeff = {1'b0, ~downstreamResponseCoord[SCALE_FRACTION_BITS-1:0]};

// Blend pixel color from cache to downstream response fifo
assign cacheReadAddressA = downstreamResponseColumn;
assign cacheReadAddressB = downstreamResponseColumn;
assign cacheReadEnableA = 1'b1;
assign cacheReadEnableB = 1'b1;

reg downstreamUpperRowInCacheA = 1'b0;
reg [SCALE_FRACTION_BITS-1:0] downstreamBlendFraction = {SCALE_FRACTION_BITS{1'b0}};
reg downstreamBlendFractionReady = 1'b0;
reg downstreamResponsePixelsCached = 1'b0;
reg downstreamBlendParamsReady = 1'b0;

reg [SCALE_BITS-1:0] downstreamBlendUpperCoeff = {SCALE_BITS{1'b0}};
reg [SCALE_BITS-1:0] downstreamBlendLowerCoeff = {SCALE_BITS{1'b0}};

// wire [BITS_PER_PIXEL-1:0] downstreamUpperPixelColor = downstreamUpperRowInCacheA ? cacheReadDataA : cacheReadDataB;
// wire [BITS_PER_PIXEL-1:0] downstreamLowerPixelColor = downstreamUpperRowInCacheA ? cacheReadDataB : cacheReadDataA;
reg [BITS_PER_PIXEL-1:0] downstreamUpperPixelColor = {BITS_PER_PIXEL{1'b0}};
reg [BITS_PER_PIXEL-1:0] downstreamLowerPixelColor = {BITS_PER_PIXEL{1'b0}};

/* assign downstreamResponseFifoWriteData = downstreamBlend ?
        blend(downstreamUpperPixelColor, downstreamBlendUpperCoeff, downstreamLowerPixelColor, downstreamBlendLowerCoeff) :
        downstreamUpperPixelColor; */
/* assign downstreamResponseFifoWriteData =
    blend(downstreamUpperPixelColor, downstreamBlendUpperCoeff, downstreamLowerPixelColor, downstreamBlendLowerCoeff); */

reg [COLOR_WEIGHT_BITS-1:0] downstreamUpperWeightRed = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamUpperWeightGreen = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamUpperWeightBlue = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamLowerWeightRed = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamLowerWeightGreen = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamLowerWeightBlue = {COLOR_WEIGHT_BITS{1'b0}};

/* verilator lint_off UNUSED */
wire [COLOR_COMPONENT_BITS_MAX-1:0] downstreamWeightSumRed = colorComponentSum(downstreamUpperWeightRed, downstreamLowerWeightRed);
wire [COLOR_COMPONENT_BITS_MAX-1:0] downstreamWeightSumGreen = colorComponentSum(downstreamUpperWeightGreen, downstreamLowerWeightGreen);
wire [COLOR_COMPONENT_BITS_MAX-1:0] downstreamWeightSumBlue = colorComponentSum(downstreamUpperWeightBlue, downstreamLowerWeightBlue);
/* verilator lint_on UNUSED */
assign downstreamResponseFifoWriteData = {downstreamWeightSumRed[4:0], downstreamWeightSumGreen[5:0], downstreamWeightSumBlue[4:0]};

reg downstreamResponseFifoWriteEnableReg = 1'b0;
assign downstreamResponseFifoWriteEnable = downstreamResponseFifoFull ? 1'b0 : downstreamResponseFifoWriteEnableReg;

reg pendingDownstreamResponseFifoReadEnableReg = 1'b0;
assign pendingDownstreamResponseFifoReadEnable = downstreamResponseFifoFull ? 1'b0 : pendingDownstreamResponseFifoReadEnableReg;

reg [31:0] totalDownstreamResponses = 32'd0;

// function [BITS_PER_PIXEL-1:0] blend;
    // input [BITS_PER_PIXEL-1:0]  uColor;
    // input [SCALE_BITS-1:0]      uCoeff;
    // input [BITS_PER_PIXEL-1:0]  lColor;
    // input [SCALE_BITS-1:0]      lCoeff;
    
    
    // reg [4:0] uRed = 5'd0;
    // reg [5:0] uGreen = 6'd0;
    // reg [4:0] uBlue = 5'd0;
    // reg [4:0] lRed = 5'd0;
    // reg [5:0] lGreen = 6'd0;
    // reg [4:0] lBlue = 5'd0;
    
    
    // /* verilator lint_off UNUSED */
    // reg [4+SCALE_FRACTION_BITS:0] blendedRed = {(5+SCALE_FRACTION_BITS){1'b0}};
    // reg [5+SCALE_FRACTION_BITS:0] blendedGreen = {(6+SCALE_FRACTION_BITS){1'b0}};
    // reg [4+SCALE_FRACTION_BITS:0] blendedBlue = {(5+SCALE_FRACTION_BITS){1'b0}};
    // /* verilator lint_on UNUSED */
    
    // begin
        // uRed = uColor[15:11];
        // uGreen = uColor[10:5];
        // uBlue = uColor[4:0];
        // lRed = lColor[15:11];
        // lGreen = lColor[10:5];
        // lBlue = lColor[4:0];
        
        // blendedRed = uRed * uCoeff + lRed * lCoeff;
        // blendedGreen = uGreen * uCoeff + lGreen * lCoeff;
        // blendedBlue = uBlue * uCoeff + lBlue * lCoeff;
        
        // blend = {blendedRed[4+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS],
                 // blendedGreen[5+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS],
                 // blendedBlue[4+SCALE_FRACTION_BITS:SCALE_FRACTION_BITS]};
    // end
// endfunction

function [COLOR_COMPONENT_BITS_MAX-1:0] colorComponentSum;
    input [COLOR_WEIGHT_BITS-1:0] addendA;
    input [COLOR_WEIGHT_BITS-1:0] addendB;

    /* verilator lint_off UNUSED */
    reg [COLOR_WEIGHT_BITS-1:0] sum;
    /* verilator lint_on UNUSED */

    begin
        sum = addendA + addendB;// + {{COLOR_COMPONENT_BITS_MAX{1'b0}}, 1'b1, {(SCALE_FRACTION_BITS-1){1'b0}}};
        colorComponentSum = sum[COLOR_WEIGHT_BITS-1:SCALE_FRACTION_BITS];
    end
endfunction

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        //TODO
        cachedChunkValidAStaged <= 1'b0;
        cachedChunkValidBStaged <= 1'b0;
        cachedChunkPendingAStaged <= 1'b0;
        cachedChunkPendingBStaged <= 1'b0;
        upstreamResponseFifoReadEnableReg <= 1'b0;
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        downstreamRequestFifoReadEnable <= 1'b0;
        pendingUpstreamRequestFifoReadEnable <= 1'b0;
        downstreamUpperRowInCacheA <= 1'b0;
        downstreamBlendUpperCoeff <= {SCALE_BITS{1'b0}};
        downstreamBlendLowerCoeff <= {SCALE_BITS{1'b0}};
        downstreamUpperPixelColor <= {BITS_PER_PIXEL{1'b0}};
        downstreamLowerPixelColor <= {BITS_PER_PIXEL{1'b0}};
        downstreamBlendFraction <= {SCALE_FRACTION_BITS{1'b0}};
        downstreamBlendFractionReady <= 1'b0;
        downstreamResponsePixelsCached <= 1'b0;
        downstreamBlendParamsReady <= 1'b0;
        downstreamUpperWeightRed <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamUpperWeightGreen <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamUpperWeightBlue <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamLowerWeightRed <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamLowerWeightGreen <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamLowerWeightBlue <= {COLOR_WEIGHT_BITS{1'b0}};

    end else begin
    
        //HACK FIXME TODO
        if (downstreamResponseFifoWriteEnable)
            totalDownstreamResponses <= totalDownstreamResponses + 32'd1;
    
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
                    downstreamRequestState <= DOWNSTREAM_REQUEST_CHECK;
                end
            end

            DOWNSTREAM_REQUEST_CHECK: begin
                // Save these pre-calculated values for DOWNSTREAM_REQUEST_STORE or DOWNSTREAM_REQUEST_STALL
                cachedChunkValidAStaged <= cachedChunkValidA[requestedChunk];
                cachedChunkValidBStaged <= cachedChunkValidB[requestedChunk];
                cachedChunkPendingAStaged <= cachedChunkPendingA[requestedChunk];
                cachedChunkPendingBStaged <= cachedChunkPendingB[requestedChunk];
                
                // Determine if the required upstream chunk is already cached in the line buffer
                if ((upstreamRequestRowUpper == cachedRowA || upstreamRequestRowUpper == cachedRowB) &&
                    (upstreamRequestRowLower == cachedRowA || upstreamRequestRowLower == cachedRowB)) begin
                    // Cached rows match the request, so proceed with enqueueing upstream requests
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
                end else begin
                    // Cached rows are different from requested rows, so stall until all pending requests are complete
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STALL;
                    upstreamRequestFifoWriteEnable <= 1'b0;
                    pendingDownstreamResponseFifoWriteEnable <= 1'b0;
                end
            end

            DOWNSTREAM_REQUEST_STORE: begin
                // If we do not already have the requested chunks cached, and we are not repeating the previous request
                if ((upstreamRequestRowUpper == cachedRowA) && 
                     !cachedChunkValidAStaged &&
                     !cachedChunkPendingAStaged) begin
                    // Enqueue the upstream request
                    upstreamRequestFifoWriteData <= upstreamRequestUpper;
                    upstreamRequestFifoWriteEnable <= 1'b1;
                    // Do not repeat this request while it is in progress
                    cachedChunkPendingAStaged <= 1'b1;
                    cachedChunkPendingA[requestedChunk] <= 1'b1;
                end else if ((upstreamRequestRowUpper == cachedRowB) && 
                             !cachedChunkValidBStaged &&
                             !cachedChunkPendingBStaged) begin
                    // Enqueue the upstream request
                    upstreamRequestFifoWriteData <= upstreamRequestUpper;
                    upstreamRequestFifoWriteEnable <= 1'b1;
                    // Do not repeat this request while it is in progress
                    cachedChunkPendingBStaged <= 1'b1;
                    cachedChunkPendingB[requestedChunk] <= 1'b1;
                end else if ((upstreamRequestRowLower == cachedRowA) && 
                     !cachedChunkValidAStaged &&
                     !cachedChunkPendingAStaged) begin
                    // Enqueue the upstream request
                    upstreamRequestFifoWriteData <= upstreamRequestLower;
                    upstreamRequestFifoWriteEnable <= 1'b1;
                    // Do not repeat this request while it is in progress
                    cachedChunkPendingAStaged <= 1'b1;
                    cachedChunkPendingA[requestedChunk] <= 1'b1;
                end else if ((upstreamRequestRowLower == cachedRowB) && 
                             !cachedChunkValidBStaged &&
                             !cachedChunkPendingBStaged) begin
                    // Enqueue the upstream request
                    upstreamRequestFifoWriteData <= upstreamRequestLower;
                    upstreamRequestFifoWriteEnable <= 1'b1;
                    // Do not repeat this request while it is in progress
                    cachedChunkPendingBStaged <= 1'b1;
                    cachedChunkPendingB[requestedChunk] <= 1'b1;
                end else begin
                    // Save the downstream response for processing later, and return to idle
                    pendingDownstreamResponseFifoWriteEnable <= 1'b1;
                    upstreamRequestFifoWriteEnable <= 1'b0;
                    downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
                end
            end
            
            DOWNSTREAM_REQUEST_STALL: begin
                // Stall until all pending requests are complete, then start the new row(s)
                if (pendingUpstreamRequestFifoEmpty && pendingDownstreamResponseFifoEmpty && 
                        upstreamResponseState == UPSTREAM_RESPONSE_IDLE &&
                        downstreamResponsePixelCount[CHUNK_BITS] &&
                        !pendingDownstreamResponseFifoReadEnableReg) begin
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
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_CHECK;
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
                    upstreamResponseFifoReadEnableReg <= 1'b0;
                    upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                    upstreamResponseState <= UPSTREAM_RESPONSE_READ;
                end
            end
            
            UPSTREAM_RESPONSE_READ: begin
                // Next cycle the request item should be available
                pendingUpstreamRequestFifoReadEnable <= 1'b0;
                upstreamResponseState <= UPSTREAM_RESPONSE_STORE;
                
                // We should be able to process a pixel next cycle, if available
                upstreamResponseFifoReadEnableReg <= !upstreamResponseFifoEmpty;
                // upstreamResponseReady delays upstreamResponseFifoReadEnable by one clock cycle
                // to synchronize upstreamResponseFifoReadData with upstreamResponseColumn
                upstreamResponseReady <= upstreamResponseFifoReadEnable;
            end

            UPSTREAM_RESPONSE_STORE: begin
                // If we had previously requested a pixel from the upstream FIFO
                if (upstreamResponseReady) begin
                    // Store the response in the appropriate line cache (see combinatorial logic for cache block RAMs)
                    
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
                        // Do not store next cycle's pixel
                        upstreamResponseReady <= 1'b0;
                        
                        if (pendingUpstreamRequestFifoEmpty) begin
                            // No incoming chunk at this point, so return to idle
                            pendingUpstreamRequestFifoReadEnable <= 1'b0;
                            upstreamResponseFifoReadEnableReg <= 1'b0;
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
                            upstreamResponseFifoReadEnableReg <= 1'b0;
                        end else begin
                            upstreamResponseFifoReadEnableReg <= !upstreamResponseFifoEmpty;
                        end
                    end
                end else begin
                    // We should be able to process a pixel next cycle, if available
                    upstreamResponseFifoReadEnableReg <= !upstreamResponseFifoEmpty;
                    upstreamResponseReady <= upstreamResponseFifoReadEnable;
                end
            end

            default: begin
                upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
            end

        endcase
        
        // Downstream response state machine - Once the line buffer cache contains the upstream data
        // required to respond, calculate scaled pixel data and write to downstream response FIFO
/*         case (downstreamResponseState)

            DOWNSTREAM_RESPONSE_IDLE: begin
                // Do not write any pixels into the response FIFO (after the last response finishes)
                if (!downstreamResponseFifoFull) begin
                    downstreamResponseFifoWriteEnableReg <= 1'b0;
                end
                
                // Wait until we can grab a pending downstream response
                if (!downstreamResponseFifoFull && !pendingDownstreamResponseFifoEmpty) begin
                    pendingDownstreamResponseFifoReadEnableReg <= 1'b1;
                    downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                    downstreamResponseState <= DOWNSTREAM_RESPONSE_READ;
                end
            end
            
            DOWNSTREAM_RESPONSE_READ: begin
                // Do not write any pixels into the response FIFO
                downstreamResponseFifoWriteEnableReg <= 1'b0;
                
                if (!downstreamResponseFifoFull) begin
                    // Pending downstream response should be available next cycle
                    pendingDownstreamResponseFifoReadEnableReg <= 1'b0;

                    downstreamResponseState <= DOWNSTREAM_RESPONSE_STORE;
                end
            end

            DOWNSTREAM_RESPONSE_STORE: begin
                // If the source pixels are present in the cache, and the downstream response FIFO is not full
                if (((cachedRowA == downstreamCacheRowUpper && cachedChunkValidA[downstreamResponseChunk]) ||
                     (cachedRowB == downstreamCacheRowUpper && cachedChunkValidB[downstreamResponseChunk])) &&
                    ((cachedRowA == downstreamCacheRowLower && cachedChunkValidA[downstreamResponseChunk]) ||
                     (cachedRowB == downstreamCacheRowLower && cachedChunkValidB[downstreamResponseChunk])) &&
                    !downstreamResponseFifoFull) begin

                    downstreamUpperRowInCacheA <= (cachedRowA == downstreamCacheRowUpper);
                    downstreamBlend <= ~|downstreamResponseCoordFraction;
                    downstreamBlendUpperCoeff <= downstreamCoordUpperCoeff;
                    downstreamBlendLowerCoeff <= downstreamCoordLowerCoeff;
                    
                    // Write to response fifo next cycle
                    downstreamResponseFifoWriteEnableReg <= 1'b1;
                    
                    // If that was the last pixel of the chunk, start the next chunk or return to idle
                    if (downstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                        // Reset pixel counter
                        downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                        
                        if (!pendingDownstreamResponseFifoEmpty) begin
                            // Read the next chunk
                            pendingDownstreamResponseFifoReadEnableReg <= 1'b1;
                            downstreamResponseState <= DOWNSTREAM_RESPONSE_READ;
                        end else begin
                            // No pending response chunk at this point, so return to idle
                            pendingDownstreamResponseFifoReadEnableReg <= 1'b0;
                            downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
                        end
                    end else begin
                        // Not the last pixel in the chunk, so increment pixel counter
                        downstreamResponsePixelCount <= downstreamResponsePixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
                        
                        // Not the second to last pixel of the chunk, so do not retrieve the next chunk
                        pendingDownstreamResponseFifoReadEnableReg <= 1'b0;
                    end
                end else begin
                    // If the response is available, write it as soon as the response fifo is not full
                    downstreamResponseFifoWriteEnableReg <= 
                        ((cachedRowA == downstreamCacheRowUpper && cachedChunkValidA[downstreamResponseChunk]) ||
                         (cachedRowB == downstreamCacheRowUpper && cachedChunkValidB[downstreamResponseChunk])) &&
                        ((cachedRowA == downstreamCacheRowLower && cachedChunkValidA[downstreamResponseChunk]) ||
                         (cachedRowB == downstreamCacheRowLower && cachedChunkValidB[downstreamResponseChunk]));
                    
                    // Do not grab another pending downstream response after the last one finishes
                    if (!downstreamResponseFifoFull) begin
                        pendingDownstreamResponseFifoReadEnableReg <= 1'b0;
                    end
                end
            end

            default: begin
                downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
            end

        endcase */
        
        // Downstream response pipeline only moves if the downstream response FIFO is not full
        if (!downstreamResponseFifoFull) begin
            if (downstreamResponsePixelCount[CHUNK_BITS]) begin
                downstreamResponsePixelsCached <= 1'b0;
                downstreamBlendFractionReady <= 1'b0;
                
                // High bit of downstreamResponsePixelCount indicates that we are not currently working on a chunk
                if (!pendingDownstreamResponseFifoEmpty && !pendingDownstreamResponseFifoReadEnableReg) begin
                    // Initially grabbing a pending downstream response
                    pendingDownstreamResponseFifoReadEnableReg <= 1'b1;
                end else if (pendingDownstreamResponseFifoReadEnableReg) begin
                    // Initial pending downstream response will be available next cycle
                    downstreamResponsePixelCount <= {(CHUNK_BITS+1){1'b0}};
                    pendingDownstreamResponseFifoReadEnableReg <= 1'b0;
                end
            end else if (!downstreamResponsePixelCount[CHUNK_BITS]) begin
                // Store what we need to blend the pixels
                downstreamUpperRowInCacheA <= (cachedRowA == downstreamCacheRowUpper);
                downstreamBlendFraction <= downstreamResponseCoordFraction;
                // Determine whether source pixels are in the cache
                downstreamResponsePixelsCached <=
                    (((cachedRowA == downstreamCacheRowUpper && cachedChunkValidA[downstreamResponseChunk]) ||
                      (cachedRowB == downstreamCacheRowUpper && cachedChunkValidB[downstreamResponseChunk])) &&
                     ((cachedRowA == downstreamCacheRowLower && cachedChunkValidA[downstreamResponseChunk]) ||
                      (cachedRowB == downstreamCacheRowLower && cachedChunkValidB[downstreamResponseChunk])));
                // Update read address of pixel cache RAMs
                // cacheReadAddressA <= downstreamResponseColumn;
                // cacheReadAddressB <= downstreamResponseColumn;
            end
            
            downstreamBlendFractionReady <= downstreamResponsePixelsCached && !downstreamResponsePixelCount[CHUNK_BITS];
            if (downstreamResponsePixelsCached && !downstreamResponsePixelCount[CHUNK_BITS]) begin
                // If that was the last pixel of the chunk, start the next chunk or return to idle
                if (downstreamResponsePixelCount == {1'b0, {CHUNK_BITS{1'b1}}}) begin
                    // Set counter to all 1's to indicate invalid count
                    downstreamResponsePixelCount <= {(CHUNK_BITS+1){1'b1}};
                    // Read the next chunk or return to idle
                    pendingDownstreamResponseFifoReadEnableReg <= !pendingDownstreamResponseFifoEmpty;
                end else begin
                    // Not the last pixel in the chunk, so increment pixel counter
                    downstreamResponsePixelCount <= downstreamResponsePixelCount + {{CHUNK_BITS{1'b0}}, 1'b1};
                end
            end
            
            if (downstreamBlendFractionReady) begin
                // Pixel colors should be available on cacheReadDataA/B
                downstreamUpperPixelColor <= downstreamUpperRowInCacheA ? cacheReadDataA : cacheReadDataB;
                downstreamLowerPixelColor <= downstreamUpperRowInCacheA ? cacheReadDataB : cacheReadDataA;
                
                if (|downstreamBlendFraction) begin
                    // Nonzero blend fraction, so blend upper and lower pixel colors using coefficients
                    downstreamBlendUpperCoeff <= {1'b0, ~downstreamBlendFraction};
                    downstreamBlendLowerCoeff <= {1'b0, downstreamBlendFraction};
                end else begin
                    // Zero blend fraction, so just use upper pixel color color
                    downstreamBlendUpperCoeff <= {1'b1, {SCALE_FRACTION_BITS{1'b0}}};
                    downstreamBlendLowerCoeff <= {SCALE_BITS{1'b0}};
                end
                
                // Weighted blend addends can be calculated next cycle
                downstreamBlendParamsReady <= 1'b1;
            end else begin
                // Not ready to calculate this stage
                downstreamBlendParamsReady <= 1'b0;
            end
            
            if (downstreamBlendParamsReady) begin
                // Calculate color component weights
                // Next cycle they will be summed and concatenated to form downstreamResponseFifoWriteData
                downstreamUpperWeightRed <= {1'b0, downstreamUpperPixelColor[15:11]} * downstreamBlendUpperCoeff;
                downstreamUpperWeightGreen <= downstreamUpperPixelColor[10:5] * downstreamBlendUpperCoeff;
                downstreamUpperWeightBlue <= {1'b0, downstreamUpperPixelColor[4:0]} * downstreamBlendUpperCoeff;
                downstreamLowerWeightRed <= {1'b0, downstreamLowerPixelColor[15:11]} * downstreamBlendLowerCoeff;
                downstreamLowerWeightGreen <= downstreamLowerPixelColor[10:5] * downstreamBlendLowerCoeff;
                downstreamLowerWeightBlue <= {1'b0, downstreamLowerPixelColor[4:0]} * downstreamBlendLowerCoeff;
                
                downstreamResponseFifoWriteEnableReg <= 1'b1;
            end else begin
                // Not ready to calculate this stage
                downstreamResponseFifoWriteEnableReg <= 1'b0;
            end
        end
    end
end

endmodule

