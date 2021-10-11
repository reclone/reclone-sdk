//
// VideoHorizontalStretch - Adjust width of frame using horizontal linear interpolation
//
// This module uses linear interpolation to perform non-integer scaling of a scanline.
// Since it is operating on one line at a time, this module can scale horizontally
// using only two chunk buffer caches.
//
// Each downstream pixel coordinate is multiplied by the shrink factor to determine the coordinate
// of the blended pixel in the upstream coordinate frame.
//
// While pixel data in one cache is being used for interpolation, the other cache can store
// upstream pixel data needed for later interpolation.  The goal is to achieve a burst efficiency
// of delivering one interpolated pixel downstream per scaler clock, at least for "upscaling"
// shrink factors <= 1.0 (hShrinkFactor <= 64).
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
localparam COLOR_COMPONENT_BITS_MAX = 6;
localparam COLOR_WEIGHT_BITS = SCALE_FRACTION_BITS + COLOR_COMPONENT_BITS_MAX;

// One-hot states for downstream request state machine
localparam DOWNSTREAM_REQUEST_IDLE = 4'b0001,
           DOWNSTREAM_REQUEST_READ = 4'b0010,
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
reg pendingDownstreamResponseFifoReadEnableReg = 1'b0;
wire pendingDownstreamResponseFifoReadEnable =
    pendingDownstreamResponseFifoReadEnableReg &&
    !downstreamResponseStall &&
    !downstreamCacheStall &&
    !pendingDownstreamResponseFifoEmpty;
wire [HCOORD_BITS-1:0] pendingDownstreamResponseFifoReadData;
reg pendingDownstreamResponseFifoWriteEnableReg = 1'b0;
wire pendingDownstreamResponseFifoWriteEnable = !pendingDownstreamResponseFifoFull && pendingDownstreamResponseFifoWriteEnableReg;
reg [HCOORD_BITS-1:0] pendingDownstreamResponseFifoWriteData = {HCOORD_BITS{1'b0}};
SyncFifo #(.DATA_WIDTH(HCOORD_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingDownstreamResponses
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

reg [REQUEST_BITS-1:0] lastUpstreamChunkRequest = {REQUEST_BITS{1'b1}};
reg [REQUEST_BITS-1:0] lastlastUpstreamChunkRequest = {REQUEST_BITS{1'b1}};

reg [REQUEST_BITS-1:0] downstreamRequestStaged = {REQUEST_BITS{1'b1}};
reg [CHUNK_BITS:0] downstreamRequestPixelCount = {(CHUNK_BITS+1){1'b0}};
wire [VACTIVE_BITS-1:0] downstreamRequestRow = downstreamRequestStaged[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [HACTIVE_BITS-1:0] downstreamRequestCoord = {downstreamRequestStaged[CHUNKNUM_BITS-1:0], downstreamRequestPixelCount[CHUNK_BITS-1:0]};
wire [HCOORD_BITS-1:0] upstreamRequestCoord = downstreamRequestCoord * hShrinkFactor + {{(HCOORD_BITS-SCALE_BITS){1'b0}}, hShrinkFactor[SCALE_BITS-1:1]}
    - (hShrinkFactor[SCALE_BITS-1] ? {{HACTIVE_BITS{1'b0}}, 1'b1, {(SCALE_FRACTION_BITS-1){1'b0}}} : {HCOORD_BITS{1'b0}});
wire needsNextChunkToo = (upstreamRequestCoord[HCOORD_BITS-CHUNKNUM_BITS-1:HCOORD_BITS-HACTIVE_BITS] == {CHUNK_BITS{1'b1}}) &&
                         (|upstreamRequestCoord[SCALE_FRACTION_BITS-1:0]);
wire [REQUEST_BITS-1:0] upstreamChunkRequest = {downstreamRequestRow, upstreamRequestCoord[HCOORD_BITS-1:HCOORD_BITS-CHUNKNUM_BITS]};
wire [REQUEST_BITS-1:0] upstreamChunkRequestNext = {downstreamRequestRow, upstreamRequestCoord[HCOORD_BITS-1:HCOORD_BITS-CHUNKNUM_BITS] + {{(CHUNKNUM_BITS-1){1'b0}}, 1'b1}};


// Two upstream chunk caches, so that we can read from one while filling the other
reg [CHUNKNUM_BITS-1:0] cachedChunkNumA = {CHUNKNUM_BITS{1'b1}};
reg [CHUNKNUM_BITS-1:0] cachedChunkNumB = {CHUNKNUM_BITS{1'b1}};
reg [BITS_PER_PIXEL-1:0] cachedChunkA [0:CHUNK_SIZE-1];
reg [BITS_PER_PIXEL-1:0] cachedChunkB [0:CHUNK_SIZE-1];

// Flag to keep track of which cached chunk is older
reg cachedChunkBIsOlder = 1'b0;
// Flags indicating whether the cached chunks are valid (filled completely with pixel data)
reg cachedChunkAValid = 1'b0;
reg cachedChunkBValid = 1'b0;



reg upstreamResponseFifoReadEnableReg = 1'b0;
assign upstreamResponseFifoReadEnable = upstreamResponseFifoReadEnableReg && !upstreamResponseFifoEmpty;

reg storeUpstreamResponse = 1'b0;
reg storeUpstreamResponseToCacheB = 1'b0;
reg [CHUNK_BITS-1:0] storeUpstreamResponsePixelCount = {CHUNK_BITS{1'b1}};

// Determine the coordinates of the left and right pixels, and their blending coefficients
//wire [HACTIVE_BITS-1:0] downstreamLeftPixelColumn = pendingDownstreamResponseFifoReadData[HCOORD_BITS-1:SCALE_FRACTION_BITS];
reg [HACTIVE_BITS-1:0] downstreamLeftPixelColumn = {HACTIVE_BITS{1'b1}};
wire [CHUNKNUM_BITS-1:0] downstreamLeftPixelChunk = downstreamLeftPixelColumn[HACTIVE_BITS-1:CHUNK_BITS];
wire [CHUNK_BITS-1:0] downstreamLeftPixelWhole = downstreamLeftPixelColumn[CHUNK_BITS-1:0];
// wire [SCALE_BITS-1:0] downstreamLeftPixelCoeff =
    // {1'b0, ~pendingDownstreamResponseFifoReadData[SCALE_FRACTION_BITS-1:0]} +
    // {{(SCALE_BITS-1){1'b0}}, 1'b1};
reg [SCALE_BITS-1:0] downstreamLeftPixelCoeff = {SCALE_BITS{1'b1}};

// wire [HACTIVE_BITS-1:0] downstreamRightPixelColumn = ~|downstreamRightPixelCoeff ?
                            // downstreamLeftPixelColumn : downstreamLeftPixelColumn + {{(HACTIVE_BITS-1){1'b0}}, 1'b1};
reg [HACTIVE_BITS-1:0] downstreamRightPixelColumn = {HACTIVE_BITS{1'b1}};
wire [CHUNKNUM_BITS-1:0] downstreamRightPixelChunk = downstreamRightPixelColumn[HACTIVE_BITS-1:CHUNK_BITS];
wire [CHUNK_BITS-1:0] downstreamRightPixelWhole = downstreamRightPixelColumn[CHUNK_BITS-1:0];
//wire [SCALE_BITS-1:0] downstreamRightPixelCoeff = {1'b0, pendingDownstreamResponseFifoReadData[SCALE_FRACTION_BITS-1:0]};
reg [SCALE_BITS-1:0] downstreamRightPixelCoeff = {SCALE_BITS{1'b1}};

// Flags to track whether the downstream state machine still needs cached chunk A or B
wire downstreamLeftPixelInCacheA = (downstreamLeftPixelChunk == cachedChunkNumA);
wire downstreamLeftPixelInCacheB = (downstreamLeftPixelChunk == cachedChunkNumB);
wire downstreamRightPixelInCacheA = (downstreamRightPixelChunk == cachedChunkNumA);
wire downstreamRightPixelInCacheB = (downstreamRightPixelChunk == cachedChunkNumB);

wire downstreamNeedsCachedChunkA = (downstreamLeftPixelInCacheA || downstreamRightPixelInCacheA);
wire downstreamNeedsCachedChunkB = (downstreamLeftPixelInCacheB || downstreamRightPixelInCacheB);

wire [BITS_PER_PIXEL-1:0] downstreamLeftPixelColor = (downstreamLeftPixelInCacheA ? cachedChunkA[downstreamLeftPixelWhole] : cachedChunkB[downstreamLeftPixelWhole]);
wire [BITS_PER_PIXEL-1:0] downstreamRightPixelColor = (downstreamRightPixelInCacheA ? cachedChunkA[downstreamRightPixelWhole] : cachedChunkB[downstreamRightPixelWhole]);

// Registers to add a pipeline stage before the blend calculation
reg [BITS_PER_PIXEL-1:0] blendLeftPixelColor = {BITS_PER_PIXEL{1'b0}};
reg [BITS_PER_PIXEL-1:0] blendRightPixelColor = {BITS_PER_PIXEL{1'b0}};
reg [SCALE_BITS-1:0] blendLeftPixelCoeff = {SCALE_BITS{1'b0}};
reg [SCALE_BITS-1:0] blendRightPixelCoeff = {SCALE_BITS{1'b0}};

wire downstreamLeftPixelIsCached = (downstreamLeftPixelInCacheA && cachedChunkAValid) || (downstreamLeftPixelInCacheB && cachedChunkBValid);
wire downstreamRightPixelIsCached = (downstreamRightPixelInCacheA && cachedChunkAValid) || (downstreamRightPixelInCacheB && cachedChunkBValid);

// Available flag is delayed copy of pendingDownstreamResponseFifoReadEnableReg
reg pendingDownstreamResponseAvailable = 1'b0;
reg pendingDownstreamCoordsAvailable = 1'b0;


//assign downstreamResponseFifoWriteData = blend(blendLeftPixelColor, blendLeftPixelCoeff, blendRightPixelColor, blendRightPixelCoeff);

reg downstreamBlendParamsReady = 1'b0;
reg downstreamBlendWeightsReady = 1'b0;
reg [COLOR_WEIGHT_BITS-1:0] downstreamLeftWeightRed = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamLeftWeightGreen = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamLeftWeightBlue = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamRightWeightRed = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamRightWeightGreen = {COLOR_WEIGHT_BITS{1'b0}};
reg [COLOR_WEIGHT_BITS-1:0] downstreamRightWeightBlue = {COLOR_WEIGHT_BITS{1'b0}};

/* verilator lint_off UNUSED */
wire [COLOR_COMPONENT_BITS_MAX-1:0] downstreamWeightSumRed = colorComponentSum(downstreamLeftWeightRed, downstreamRightWeightRed);
wire [COLOR_COMPONENT_BITS_MAX-1:0] downstreamWeightSumGreen = colorComponentSum(downstreamLeftWeightGreen, downstreamRightWeightGreen);
wire [COLOR_COMPONENT_BITS_MAX-1:0] downstreamWeightSumBlue = colorComponentSum(downstreamLeftWeightBlue, downstreamRightWeightBlue);
/* verilator lint_on UNUSED */
//assign downstreamResponseFifoWriteData = {downstreamWeightSumRed[4:0], downstreamWeightSumGreen[5:0], downstreamWeightSumBlue[4:0]};
reg downstreamResponseFifoWriteEnableReg = 1'b0;
assign downstreamResponseFifoWriteEnable = downstreamResponseFifoWriteEnableReg && !downstreamResponseFifoFull;

wire downstreamCacheStall = (pendingDownstreamCoordsAvailable && (!downstreamLeftPixelIsCached || !downstreamRightPixelIsCached));
wire downstreamResponseStall = downstreamResponseFifoFull;

// function [BITS_PER_PIXEL-1:0] blend;
    // input [BITS_PER_PIXEL-1:0]  lColor;
    // input [SCALE_BITS-1:0]      lCoeff;
    // input [BITS_PER_PIXEL-1:0]  rColor;
    // input [SCALE_BITS-1:0]      rCoeff;
    
    
    // reg [4:0] lRed = 5'd0;
    // reg [5:0] lGreen = 6'd0;
    // reg [4:0] lBlue = 5'd0;
    // reg [4:0] rRed = 5'd0;
    // reg [5:0] rGreen = 6'd0;
    // reg [4:0] rBlue = 5'd0;
    
    
    // /* verilator lint_off UNUSED */
    // reg [4+SCALE_FRACTION_BITS:0] blendedRed = {(5+SCALE_FRACTION_BITS){1'b0}};
    // reg [5+SCALE_FRACTION_BITS:0] blendedGreen = {(6+SCALE_FRACTION_BITS){1'b0}};
    // reg [4+SCALE_FRACTION_BITS:0] blendedBlue = {(5+SCALE_FRACTION_BITS){1'b0}};
    // /* verilator lint_on UNUSED */
    
    // begin
        // lRed = lColor[15:11];
        // lGreen = lColor[10:5];
        // lBlue = lColor[4:0];
        // rRed = rColor[15:11];
        // rGreen = rColor[10:5];
        // rBlue = rColor[4:0];
        
        // blendedRed = lRed * lCoeff + rRed * rCoeff;
        // blendedGreen = lGreen * lCoeff + rGreen * rCoeff;
        // blendedBlue = lBlue * lCoeff + rBlue * rCoeff;
        
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
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
        downstreamRequestStaged <= {REQUEST_BITS{1'b1}};
        downstreamRequestFifoReadEnableReg <= 1'b0;
        upstreamRequestFifoWriteEnable <= 1'b0;
        pendingUpstreamRequestFifoReadEnable <= 1'b0;
        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        pendingDownstreamResponseFifoReadEnableReg <= 1'b0;
        pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
        pendingDownstreamResponseFifoWriteData <= {HCOORD_BITS{1'b0}};
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
        pendingDownstreamResponseAvailable <= 1'b0;
        pendingDownstreamCoordsAvailable <= 1'b0;
        blendLeftPixelColor <= {BITS_PER_PIXEL{1'b0}};
        blendRightPixelColor <= {BITS_PER_PIXEL{1'b0}};
        blendLeftPixelCoeff <= {SCALE_BITS{1'b0}};
        blendRightPixelCoeff <= {SCALE_BITS{1'b0}};
        downstreamResponseFifoWriteEnableReg <= 1'b0;
        downstreamBlendParamsReady <= 1'b0;
        downstreamBlendWeightsReady <= 1'b0;
        downstreamLeftWeightRed <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamLeftWeightGreen <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamLeftWeightBlue <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamRightWeightRed <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamRightWeightGreen <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamRightWeightBlue <= {COLOR_WEIGHT_BITS{1'b0}};
        downstreamLeftPixelColumn <= {HACTIVE_BITS{1'b1}};
        downstreamLeftPixelCoeff <= {SCALE_BITS{1'b1}};
        downstreamRightPixelColumn <= {HACTIVE_BITS{1'b1}};
        downstreamRightPixelCoeff <= {SCALE_BITS{1'b1}};
        downstreamResponseFifoWriteData <= {BITS_PER_PIXEL{1'b0}};
    end else begin
        // Request state machine - Get downstream chunk requests, translate pixel coordinates,
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
                upstreamRequestFifoWriteEnable <= 1'b0;
                
                // Make sure again that the FIFOs have the space to receive new requests because last cycle
                // pendingDownstreamResponseFifoWriteEnable could have caused pendingDownstreamResponseFifoFull
                if (!pendingUpstreamRequestFifoFull && !upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STAGE;
                end
            end
            
            DOWNSTREAM_REQUEST_STAGE: begin
                downstreamRequestStaged <= downstreamRequestFifoReadData;
                if (pendingDownstreamResponseFifoWriteEnable) begin
                    pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
                end
                upstreamRequestFifoWriteEnable <= 1'b0;
                
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
        
        // DOWNSTREAM RESPONSE STAGING
        
        if (!downstreamResponseStall) begin
            if (!downstreamCacheStall) begin
                // Read the next pending downstream response coord
                pendingDownstreamResponseFifoReadEnableReg <= !pendingDownstreamResponseFifoEmpty;
                
                pendingDownstreamResponseAvailable <= pendingDownstreamResponseFifoReadEnableReg &&
                                                      !pendingDownstreamResponseFifoEmpty;
                
                // Pre-calculate left/right columns and coefficients to improve timing
                pendingDownstreamCoordsAvailable <= pendingDownstreamResponseAvailable;
                if (pendingDownstreamResponseAvailable) begin
                    downstreamLeftPixelColumn <= pendingDownstreamResponseFifoReadData[HCOORD_BITS-1:SCALE_FRACTION_BITS];
                    downstreamLeftPixelCoeff <= {1'b0, ~pendingDownstreamResponseFifoReadData[SCALE_FRACTION_BITS-1:0]} +
                                               {{(SCALE_BITS-1){1'b0}}, 1'b1};
                    downstreamRightPixelColumn <= ~|pendingDownstreamResponseFifoReadData[SCALE_FRACTION_BITS-1:0] ?
                        pendingDownstreamResponseFifoReadData[HCOORD_BITS-1:SCALE_FRACTION_BITS] : 
                        pendingDownstreamResponseFifoReadData[HCOORD_BITS-1:SCALE_FRACTION_BITS] + {{(HACTIVE_BITS-1){1'b0}}, 1'b1};
                    downstreamRightPixelCoeff <= {1'b0, pendingDownstreamResponseFifoReadData[SCALE_FRACTION_BITS-1:0]};
                end
                
                // If we read a pending downstream response last cycle, determine if the required pixels
                // are cached, and if so, store their colors and coefficients for the next stage which
                // does the actual blend calculation.
                downstreamBlendParamsReady <= pendingDownstreamCoordsAvailable;
                if  (pendingDownstreamCoordsAvailable) begin
                    blendLeftPixelColor <= downstreamLeftPixelColor;
                    blendRightPixelColor <= downstreamRightPixelColor;
                    blendLeftPixelCoeff <= downstreamLeftPixelCoeff;
                    blendRightPixelCoeff <= downstreamRightPixelCoeff;
                end
            end else begin
                downstreamBlendParamsReady <= 1'b0;
            end
            
            downstreamBlendWeightsReady <= downstreamBlendParamsReady;
            if (downstreamBlendParamsReady) begin
                // Calculate color component weights
                // Next cycle they will be summed and concatenated to form downstreamResponseFifoWriteData
                downstreamLeftWeightRed <= {1'b0, blendLeftPixelColor[15:11]} * blendLeftPixelCoeff;
                downstreamLeftWeightGreen <= blendLeftPixelColor[10:5] * blendLeftPixelCoeff;
                downstreamLeftWeightBlue <= {1'b0, blendLeftPixelColor[4:0]} * blendLeftPixelCoeff;
                downstreamRightWeightRed <= {1'b0, blendRightPixelColor[15:11]} * blendRightPixelCoeff;
                downstreamRightWeightGreen <= blendRightPixelColor[10:5] * blendRightPixelCoeff;
                downstreamRightWeightBlue <= {1'b0, blendRightPixelColor[4:0]} * blendRightPixelCoeff;
            end
            
            downstreamResponseFifoWriteEnableReg <= downstreamBlendWeightsReady;
            if (downstreamBlendWeightsReady) begin
                downstreamResponseFifoWriteData <= {downstreamWeightSumRed[4:0],
                                                    downstreamWeightSumGreen[5:0],
                                                    downstreamWeightSumBlue[4:0]};
            end
        end
    end
end

endmodule
