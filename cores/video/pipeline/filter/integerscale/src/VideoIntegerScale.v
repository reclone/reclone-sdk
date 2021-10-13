//
// VideoIntegerScale - Increase size of video frame by applying integer scaling in two dimensions
//
// Integer scaling effectively doubles, triples, quadruples, etc. the width and/or height of a
// video frame.  While separate scaling factors for width and height can be specified, pixel data
// is repeated but never interpolated.
//
// Integer scaling can be used to upscale pixel art while keeping sharp pixel edges.
//
// For scaling factors greater than 1x, a very crude scanline effect can optionally be added while
// scaling horizontally and/or vertically.  All this does is blend the background color into the 
// first row and/or column of a scaled-up pixel, for a lean but admittedly inaccurate attempt at
// CRT or LCD effects.  The scanline intensity level specifies what percentage of the background
// color is blended with the pixel color to create the final scanline color.
//      Enable/disable options: hScanlineEnable, vScanlineEnable
//      Intensity options: 0 (25% bg color), 1 (50% bg color), 2 (75% bg color), 3 (100% bg color)
//      Horizontal scanlines: Useful for mimicking the look of "fake progressive" on a CRT
//      Vertical scanlines: Mimics the look of "fake progressive" with CRT in portrait orientation
//      Both scanlines: Mimics the look of LCDs that have a small gap between pixels
//
// Two line buffers are used to implement the scaling without unnecessary duplication of upstream
// memory bandwidth.  While in theory only one line buffer is required, in practice a filter like
// VideoVerticalStretch may be placed downstream which commonly alternates requests between
// two adjacent rows.  Having two line buffers instead of one keeps both rows cached, and
// prevents "thrashing" which would add unacceptable latency and duplication of upstream requests.
//
// This scaling module is implemented as three state machines that operate in parallel:
//
//  - Downstream Request State Machine
//      This state machine watches a FIFO that receives pixel chunk requests from the downstream
//      pipeline element.  For each downstream request received, an upstream request is created
//      based on the calculated upstream pixel position, if it has not already been requested.
//      This state machine also pushes the downstream request into a pending downstream response
//      FIFO, so that the request is handled later when cached pixel data is available.
//
//  - Upstream Response State Machine
//      This state machine is responsible for copying requested upstream pixel data into the
//      line cache, and then setting bits in cachedChunkValid to indicate that those pixels are
//      received and ready to be upscaled.
//
//  - Downstream Response State Machine
//      This state machine actually handles the downstream chunk requests as soon as the required
//      pixel data is available in the line cache.  For each pixel, once the required
//      cachedChunkValid bit is set, the pixel color is copied from the cache to the response FIFO,
//      optionally blending with the backgroundColor for a scanline effect.
//
// Assumes 16-bit RGB pixel data (5-6-5 red-green-blue).
//
//
// Copyright 2020 - 2021 Reclone Labs <reclonelabs.com>
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

module VideoIntegerScale #(parameter CHUNK_BITS = 5)
(
    input wire scalerClock,
    input wire reset,

    // Scaling configuration
    input wire [SCALE_BITS-1:0] hScaleFactor, // 1 to 7
    input wire [SCALE_BITS-1:0] vScaleFactor, // 1 to 7
    
    // Scanline effect configuration
    /* verilator lint_off UNUSED */
    input wire [BITS_PER_PIXEL-1:0] backgroundColor,
    input wire hScanlineEnable,
    input wire vScanlineEnable,
    input wire [1:0] scanlineIntensity, // 0=25%, 1=50%, 2=75%, 3=100%
    /* verilator lint_on UNUSED */

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
localparam SCALE_BITS = 3;
localparam RECIPROCAL_FRACTION_BITS = 15;
localparam RECIPROCAL_BITS = 1 + RECIPROCAL_FRACTION_BITS;

// One-hot states for downstream request state machine
// localparam DOWNSTREAM_REQUEST_IDLE = 4'b0001, DOWNSTREAM_REQUEST_READ = 4'b0010, DOWNSTREAM_REQUEST_STORE = 4'b0100, DOWNSTREAM_REQUEST_STALL = 4'b1000;
// reg[3:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

// One-hot states for upstream response state machine
localparam  UPSTREAM_RESPONSE_IDLE = 4'b0001,
            UPSTREAM_RESPONSE_READ = 4'b0010,
            UPSTREAM_RESPONSE_STAGE = 4'b0100,
            UPSTREAM_RESPONSE_STORE = 4'b1000;
reg [3:0] upstreamResponseState = UPSTREAM_RESPONSE_IDLE;

// One-hot states for downstream response state machine
// localparam DOWNSTREAM_RESPONSE_IDLE = 3'b001, DOWNSTREAM_RESPONSE_READ = 3'b010, DOWNSTREAM_RESPONSE_STORE = 3'b100;
// reg [2:0] downstreamResponseState = DOWNSTREAM_RESPONSE_IDLE;

reg [REQUEST_BITS-1:0] downstreamRequestStaged = {REQUEST_BITS{1'b1}};
wire [VACTIVE_BITS-1:0] requestedRow = downstreamRequestStaged[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] requestedChunk = downstreamRequestStaged[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS:0] downstreamRequestPixelCount = {(CHUNK_BITS+1){1'b1}};
//wire [HACTIVE_BITS-1:0] requestedColumn = {requestedChunk, {CHUNK_BITS{1'b0}}}; // Calculate upstream requests based on first pixel in downstream chunk
wire [HACTIVE_BITS-1:0] requestedColumn = {requestedChunk, downstreamRequestPixelCount[CHUNK_BITS-1:0]};

// reg [VACTIVE_BITS-1:0] pendingDownstreamResponseRow = {VACTIVE_BITS{1'b1}};
// reg [CHUNKNUM_BITS-1:0] pendingDownstreamResponseChunk = {CHUNKNUM_BITS{1'b1}};

reg [VACTIVE_BITS-1:0] cachedRowA = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingA = {MAX_CHUNKS_PER_ROW{1'b0}};
wire cacheWriteEnableA;
wire [HACTIVE_BITS-1:0] cacheWriteAddressA;
wire [BITS_PER_PIXEL-1:0] cacheWriteDataA;
wire cacheReadEnableA;
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




// Lookup table of fractions of 32768, index is denominator (except for index 0 which repeats 1)
// floor(x / idx) == floor((x * reciprocalFactors[idx]) >> 15)
reg [RECIPROCAL_BITS-1:0] reciprocalFactors [0:(1 << SCALE_BITS)-1];
initial begin
    $readmemh("integerScaleReciprocalFactors.mem", reciprocalFactors);
end

// function [HACTIVE_BITS-1:0] divideCoordBy;
    // input [HACTIVE_BITS-1:0] coord;
    // input [SCALE_BITS-1:0] dividend;
    // /* verilator lint_off UNUSED */
    // reg [HACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:0] product;
    // /* verilator lint_on UNUSED */
    // begin
        // product = coord * reciprocalFactors[dividend];
        // divideCoordBy = product[HACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:RECIPROCAL_FRACTION_BITS];
    // end
// endfunction

wire downstreamRequestNewRowStall = upstreamRequestStaged &&
                                    !upstreamRequestRowIsCacheA &&
                                    !upstreamRequestRowIsCacheB &&
                                    !(pendingUpstreamRequestFifoEmpty &&
                                      pendingDownstreamResponseFifoEmpty && 
                                      upstreamResponseState == UPSTREAM_RESPONSE_IDLE &&
                                      !pendingDownstreamResponseFifoReadEnableReg &&
                                      !pendingDownstreamResponseAvailable);
wire downstreamRequestPipelineStall = pendingUpstreamRequestFifoFull ||
                                      upstreamRequestFifoFull ||
                                      pendingDownstreamResponseFifoFull ||
                                      downstreamRequestNewRowStall;
reg downstreamRequestFifoReadEnableReg = 1'b0;
assign downstreamRequestFifoReadEnable = downstreamRequestFifoReadEnableReg && !downstreamRequestPipelineStall;
reg downstreamRequestNewChunk = 1'b0;
reg upstreamRequestAvailable = 1'b0;

// wire [VACTIVE_BITS-1:0] upstreamRequestRow = divideCoordBy(requestedRow, vScaleFactor);
// /* verilator lint_off UNUSED */
// wire [HACTIVE_BITS-1:0] upstreamRequestColumn = divideCoordBy(requestedColumn, hScaleFactor);
// /* verilator lint_on UNUSED */

reg [VACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:0] upstreamRequestRowPrecision = {(VACTIVE_BITS+RECIPROCAL_FRACTION_BITS){1'b0}};
/* verilator lint_off UNUSED */
reg [HACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:0] upstreamRequestColumnPrecision = {(HACTIVE_BITS+RECIPROCAL_FRACTION_BITS){1'b0}};
/* verilator lint_on UNUSED */

wire [VACTIVE_BITS-1:0] upstreamRequestRow = upstreamRequestRowPrecision[VACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:RECIPROCAL_FRACTION_BITS];
/* verilator lint_off UNUSED */
wire [HACTIVE_BITS-1:0] upstreamRequestColumn = upstreamRequestColumnPrecision[HACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:RECIPROCAL_FRACTION_BITS];
/* verilator lint_on UNUSED */
wire [CHUNKNUM_BITS-1:0] upstreamRequestChunk = upstreamRequestColumn[HACTIVE_BITS-1:CHUNK_BITS];

reg upstreamCachedChunkValidA = 1'b0;
reg upstreamCachedChunkPendingA = 1'b1;
reg upstreamCachedChunkValidB = 1'b0;
reg upstreamCachedChunkPendingB = 1'b1;
reg [VACTIVE_BITS-1:0] upstreamRequestRowStaged = {VACTIVE_BITS{1'b1}};
reg upstreamRequestRowIsCacheA = 1'b0;
reg upstreamRequestRowIsCacheB = 1'b0;
reg [HACTIVE_BITS-1:0] upstreamRequestColumnStaged = {HACTIVE_BITS{1'b1}};
wire [CHUNKNUM_BITS-1:0] upstreamRequestChunkStaged = upstreamRequestColumnStaged[HACTIVE_BITS-1:CHUNK_BITS];
reg upstreamRequestStaged = 1'b0;
wire [REQUEST_BITS-1:0] upstreamRequest = {upstreamRequestRowStaged, upstreamRequestChunkStaged};

//reg [REQUEST_BITS-1:0] pendingUpstreamRequestStaged = {REQUEST_BITS{1'b1}};

//wire [VACTIVE_BITS-1:0] upstreamResponseRow = pendingUpstreamRequestStaged[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
reg upstreamResponseRowIsCacheA = 1'b0;
reg upstreamResponseRowIsCacheB = 1'b0;
reg [CHUNKNUM_BITS-1:0] upstreamResponseChunk = {CHUNKNUM_BITS{1'b1}};
reg [CHUNK_BITS-1:0] upstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
wire [HACTIVE_BITS-1:0] upstreamResponseColumn = {upstreamResponseChunk, upstreamResponsePixelCount};

wire pendingDownstreamResponseScanlinePixel =
    (hScanlineEnable && ({1'b0, upstreamRequestRowPrecision[RECIPROCAL_FRACTION_BITS-1:0]} < reciprocalFactors[vScaleFactor])) ||
    (vScanlineEnable && ({1'b0, upstreamRequestColumnPrecision[RECIPROCAL_FRACTION_BITS-1:0]} < reciprocalFactors[hScaleFactor]));
reg pendingDownstreamResponseScanlinePixelStaged = 1'b0;

// Write the upstream response to cache, when it's ready
assign cacheWriteAddressA = upstreamResponseColumn;
assign cacheWriteAddressB = upstreamResponseColumn;
assign cacheWriteDataA = upstreamResponseFifoReadData;
assign cacheWriteDataB = upstreamResponseFifoReadData;
assign cacheWriteEnableA = (upstreamResponseReady && upstreamResponseRowIsCacheA);
assign cacheWriteEnableB = (upstreamResponseReady && upstreamResponseRowIsCacheB);

//wire [VACTIVE_BITS-1:0] downstreamResponseRow = pendingDownstreamResponseFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
//wire [CHUNKNUM_BITS-1:0] downstreamResponseChunk = pendingDownstreamResponseFifoReadData[CHUNKNUM_BITS-1:0];
//reg [CHUNK_BITS-1:0] downstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
//wire [HACTIVE_BITS-1:0] downstreamResponseColumn = {downstreamResponseChunk, downstreamResponsePixelCount};

//wire [VACTIVE_BITS-1:0] downstreamCacheRow  = divideCoordBy(downstreamResponseRow, vScaleFactor);
//wire [HACTIVE_BITS-1:0] downstreamCacheColumn = divideCoordBy(downstreamResponseColumn, hScaleFactor);

reg [VACTIVE_BITS+HACTIVE_BITS:0] pendingDownstreamResponseStaged = {(VACTIVE_BITS+HACTIVE_BITS+1){1'b1}};
wire [VACTIVE_BITS-1:0] downstreamCacheRow  = pendingDownstreamResponseFifoReadData[HACTIVE_BITS+VACTIVE_BITS-1:HACTIVE_BITS];
wire [HACTIVE_BITS-1:0] downstreamCacheColumnStaged = pendingDownstreamResponseStaged[HACTIVE_BITS-1:0];;
//wire [CHUNKNUM_BITS-1:0] downstreamCacheChunkStaged = downstreamCacheColumnStaged[HACTIVE_BITS-1:CHUNK_BITS];

reg downstreamCacheRowIsCacheA = 1'b0;
reg downstreamCacheRowIsCacheB = 1'b0;
reg downstreamCachedChunkValidAStaged = 1'b0;
reg downstreamCachedChunkValidBStaged = 1'b0;

// The first row and/or column of a scaled-up pixel is a scanline pixel
// wire isDownstreamResponseScanlineRow = ((downstreamCacheRow * vScaleFactor) == downstreamResponseRow);
// wire isDownstreamResponseScanlineCol = ((downstreamCacheColumn * hScaleFactor) == downstreamResponseColumn);
// wire isDownstreamResponseScanlinePixel = ((hScanlineEnable && isDownstreamResponseScanlineRow) || 
                                          // (vScanlineEnable && isDownstreamResponseScanlineCol));

// Copy pixel color from cache to downstream response fifo
reg downstreamResponseInCacheA = 1'b0;
reg downstreamResponseScanlineBlend = 1'b0;
assign cacheReadAddressA = downstreamCacheColumnStaged;
assign cacheReadAddressB = downstreamCacheColumnStaged;
assign cacheReadEnableA = !downstreamResponseFifoFull && pendingDownstreamResponseAvailable &&
                          downstreamCacheRowIsCacheA && downstreamCachedChunkValidAStaged; //!downstreamResponseStall && pendingDownstreamResponseAvailable;
assign cacheReadEnableB = !downstreamResponseFifoFull && pendingDownstreamResponseAvailable &&
                          downstreamCacheRowIsCacheB && downstreamCachedChunkValidBStaged; //!downstreamResponseStall && pendingDownstreamResponseAvailable;
// wire [BITS_PER_PIXEL-1:0] cacheAPixelColor = downstreamResponseScanlineBlend ?
                            // scanlineBlend(cacheReadDataA, backgroundColor, scanlineIntensity) : cacheReadDataA;
// wire [BITS_PER_PIXEL-1:0] cacheBPixelColor = downstreamResponseScanlineBlend ?
                            // scanlineBlend(cacheReadDataB, backgroundColor, scanlineIntensity) : cacheReadDataB;
reg pendingDownstreamResponseReady = 1'b0;
reg pendingDownstreamResponseAvailable = 1'b0;
wire downstreamResponseStall = downstreamResponseFifoFull || 
                               (pendingDownstreamResponseAvailable &&
                                !((downstreamCacheRowIsCacheA && downstreamCachedChunkValidAStaged) ||
                                  (downstreamCacheRowIsCacheB && downstreamCachedChunkValidBStaged)));

reg downstreamResponsePixelAvailable = 1'b0;

reg downstreamResponseFifoWriteEnableReg = 1'b0;
assign downstreamResponseFifoWriteEnable = !downstreamResponseFifoFull && downstreamResponseFifoWriteEnableReg;
//assign downstreamResponseFifoWriteData = downstreamResponseInCacheA ? cacheAPixelColor : cacheBPixelColor;
//assign downstreamResponseFifoWriteData = downstreamResponseInCacheA ? cacheReadDataA : cacheReadDataB;


// upstreamRequests FIFO provides chunk requests to the upstream pipeline element
reg upstreamRequestFifoWriteEnableReg = 1'b0;
wire upstreamRequestFifoWriteEnable = upstreamRequestFifoWriteEnableReg && !downstreamRequestPipelineStall;
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
wire upstreamResponseFifoReadEnable = !upstreamResponseFifoEmpty && upstreamResponseFifoReadEnableReg;
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
reg pendingDownstreamResponseFifoReadEnableReg = 1'b0;
wire pendingDownstreamResponseFifoReadEnable = !downstreamResponseStall &&
                                               ! pendingDownstreamResponseFifoEmpty &&
                                               pendingDownstreamResponseFifoReadEnableReg;
wire [VACTIVE_BITS+HACTIVE_BITS:0] pendingDownstreamResponseFifoReadData;
reg pendingDownstreamResponseFifoWriteEnableReg = 1'b0;
wire pendingDownstreamResponseFifoWriteEnable = pendingDownstreamResponseFifoWriteEnableReg && !downstreamRequestPipelineStall;
reg [VACTIVE_BITS+HACTIVE_BITS:0] pendingDownstreamResponseFifoWriteData = {(VACTIVE_BITS+HACTIVE_BITS+1){1'b1}};
SyncFifo #(.DATA_WIDTH(VACTIVE_BITS+HACTIVE_BITS+1), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingDownstreamResponses
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


function [BITS_PER_PIXEL-1:0] scanlineBlend;
    input [BITS_PER_PIXEL-1:0] fgColor;
    input [BITS_PER_PIXEL-1:0] bgColor;
    input [1:0] intensity;
    
    /* verilator lint_off UNUSED */
    reg [4:0] fgRed = 5'd0;
    reg [5:0] fgGreen = 6'd0;
    reg [4:0] fgBlue = 5'd0;
    reg [4:0] bgRed = 5'd0;
    reg [5:0] bgGreen = 6'd0;
    reg [4:0] bgBlue = 5'd0;
    /* verilator lint_on UNUSED */
    
    reg [4:0] blendedRed = 5'd0;
    reg [5:0] blendedGreen = 6'd0;
    reg [4:0] blendedBlue = 5'd0;
    begin
        fgRed = fgColor[15:11];
        fgGreen = fgColor[10:5];
        fgBlue = fgColor[4:0];
        bgRed = bgColor[15:11];
        bgGreen = bgColor[10:5];
        bgBlue = bgColor[4:0];
        
        case (intensity)
            // 25% background color, 75% foreground color
            2'b00  : begin
                blendedRed = {2'b00, bgRed[4:2]} + {1'b0, fgRed[4:1]} + {2'b00, fgRed[4:2]};
                blendedGreen = {2'b00, bgGreen[5:2]} + {1'b0, fgGreen[5:1]} + {2'b00, fgGreen[5:2]};
                blendedBlue = {2'b00, bgBlue[4:2]} + {1'b0, fgBlue[4:1]} + {2'b00, fgBlue[4:2]};
            end
            
            // 50% background color, 50% foreground color
            2'b01  : begin
                blendedRed = {1'b0, bgRed[4:1]} + {1'b0, fgRed[4:1]};
                blendedGreen = {1'b0, bgGreen[5:1]} + {1'b0, fgGreen[5:1]};
                blendedBlue = {1'b0, bgBlue[4:1]} + {1'b0, fgBlue[4:1]};
            end
            
            // 75% background color, 25% foreground color
            2'b10  : begin
                blendedRed = {1'b0, bgRed[4:1]} + {2'b00, bgRed[4:2]} + {2'b00, fgRed[4:2]};
                blendedGreen = {1'b0, bgGreen[5:1]} + {2'b00, bgGreen[5:2]} + {2'b00, fgGreen[5:2]};
                blendedBlue = {1'b0, bgBlue[4:1]} + {2'b00, bgBlue[4:2]} + {2'b00, fgBlue[4:2]};
            end
            
            // 100% background color
            default : begin
                blendedRed = bgRed;
                blendedGreen = bgGreen;
                blendedBlue = bgBlue;
            end
        endcase
        
        scanlineBlend = {blendedRed, blendedGreen, blendedBlue};
    end
endfunction

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        downstreamRequestFifoReadEnableReg <= 1'b0;
        //downstreamRequestAvailable <= 1'b0;
        downstreamRequestStaged <= {REQUEST_BITS{1'b1}};
        downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b1}};
        downstreamRequestNewChunk <= 1'b0;
        upstreamRequestAvailable <= 1'b0;
        upstreamRequestRowPrecision <= {(VACTIVE_BITS+RECIPROCAL_FRACTION_BITS){1'b0}};
        upstreamRequestColumnPrecision <= {(HACTIVE_BITS+RECIPROCAL_FRACTION_BITS){1'b0}};
        upstreamCachedChunkValidA <= 1'b0;
        upstreamCachedChunkPendingA <= 1'b1;
        upstreamCachedChunkValidB <= 1'b0;
        upstreamCachedChunkPendingB <= 1'b1;
        upstreamRequestRowStaged <= {VACTIVE_BITS{1'b1}};
        upstreamRequestRowIsCacheA <= 1'b0;
        upstreamRequestRowIsCacheB <= 1'b0;
        upstreamRequestColumnStaged <= {HACTIVE_BITS{1'b1}};
        upstreamRequestStaged <= 1'b0;
        pendingDownstreamResponseScanlinePixelStaged <= 1'b0;
        upstreamResponseFifoReadEnableReg <= 1'b0;
        upstreamResponseRowIsCacheA <= 1'b0;
        upstreamResponseRowIsCacheB <= 1'b0;
        upstreamRequestFifoWriteEnableReg <= 1'b0;
        pendingUpstreamRequestFifoReadEnable <= 1'b0;
        //pendingDownstreamResponseRow <= {VACTIVE_BITS{1'b1}};
        //pendingDownstreamResponseChunk <= {CHUNKNUM_BITS{1'b1}};
        pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
        pendingDownstreamResponseReady <= 1'b0;
        pendingDownstreamResponseAvailable <= 1'b0;
        pendingDownstreamResponseFifoReadEnableReg <= 1'b0;
        pendingDownstreamResponseFifoWriteData <= {(VACTIVE_BITS+HACTIVE_BITS+1){1'b1}};
        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
        upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        upstreamResponseReady <= 1'b0;
        upstreamResponseChunk <= {CHUNKNUM_BITS{1'b1}};
        //downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        //downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
        cachedRowA <= {VACTIVE_BITS{1'b1}};
        cachedChunkValidA <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedChunkPendingA <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedRowB <= {VACTIVE_BITS{1'b1}};
        cachedChunkValidB <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedChunkPendingB <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedRowBIsOlder <= 1'b0;
        //downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        pendingDownstreamResponseStaged <= {(VACTIVE_BITS+HACTIVE_BITS+1){1'b1}};
        downstreamCachedChunkValidAStaged <= 1'b0;
        downstreamCachedChunkValidBStaged <= 1'b0;
        downstreamResponseFifoWriteEnableReg <= 1'b0;
        downstreamCacheRowIsCacheA <= 1'b0;
        downstreamCacheRowIsCacheB <= 1'b0;
        downstreamResponseInCacheA <= 1'b0;
        downstreamResponseScanlineBlend <= 1'b0;
        downstreamResponsePixelAvailable <= 1'b0;
        downstreamResponseFifoWriteData <= {BITS_PER_PIXEL{1'b0}};

    end else begin
        
        // Downstream request pipeline - Get downstream chunk requests, translate pixel coordinates,
        //                              and enqueue upstream chunk requests
        if (!downstreamRequestPipelineStall) begin
            // Only move the pipeline when the various destination FIFOs are not full
            
            // STAGE 1 - Read the downstream request when FIFO not empty
            if (!downstreamRequestFifoReadEnableReg &&
                !downstreamRequestNewChunk &&
                downstreamRequestPixelCount >= {1'b0, {(CHUNK_BITS-1){1'b1}}, 1'b0}) begin
                // Read the next request if we are at or beyond the second to last pixel in the chunk
                downstreamRequestFifoReadEnableReg <= !downstreamRequestFifoEmpty;
            end else begin
                downstreamRequestFifoReadEnableReg <= 1'b0;
            end
            
            // STAGE 2 - Downstream request will be available next cycle
            downstreamRequestNewChunk <= downstreamRequestFifoReadEnableReg;
            
            // STAGE 3 - Register downstreamRequestFifoReadData to improve timing
            downstreamRequestStaged <= downstreamRequestFifoReadData;
            if (downstreamRequestNewChunk) begin
                // Reset pixel counter if we are starting a new chunk
                downstreamRequestPixelCount <= {(CHUNK_BITS+1){1'b0}};
            end else if (!downstreamRequestPixelCount[CHUNK_BITS]) begin
                // If continuing the same chunk, increment the pixel counter
                downstreamRequestPixelCount <= downstreamRequestPixelCount + {{(CHUNK_BITS){1'b0}}, 1'b1};
            end
            
            // STAGE 4 - Calculate upstream row and column
            if (!downstreamRequestPixelCount[CHUNK_BITS]) begin
                upstreamRequestRowPrecision <= requestedRow * reciprocalFactors[vScaleFactor];
                upstreamRequestColumnPrecision <= requestedColumn * reciprocalFactors[hScaleFactor];
                upstreamRequestAvailable <= 1'b1;
            end else begin
                // Not currently processing a chunk
                upstreamRequestAvailable <= 1'b0;
            end
            
            // STAGE 4 - Stage upstream request and pending downstream response (to improve timing)
            if (upstreamRequestAvailable) begin
                // Determine if the required upstream chunk is already cached in the line buffer
                upstreamCachedChunkValidA <= cachedChunkValidA[upstreamRequestChunk];
                upstreamCachedChunkPendingA <= cachedChunkPendingA[upstreamRequestChunk];
                upstreamCachedChunkValidB <= cachedChunkValidB[upstreamRequestChunk];
                upstreamCachedChunkPendingB <= cachedChunkPendingB[upstreamRequestChunk];
                upstreamRequestRowStaged <= upstreamRequestRow;
                upstreamRequestRowIsCacheA <= (upstreamRequestRow == cachedRowA);
                upstreamRequestRowIsCacheB <= (upstreamRequestRow == cachedRowB);
                upstreamRequestColumnStaged <= upstreamRequestColumn;
                pendingDownstreamResponseScanlinePixelStaged <= pendingDownstreamResponseScanlinePixel;
                upstreamRequestStaged <= 1'b1;
            end else begin
                upstreamRequestStaged <= 1'b0;
            end
            
            // STAGE 5 - Write upstream requests and pending downstream responses
            if (upstreamRequestStaged) begin
                // Determine if the required upstream chunk is already cached in the line buffer
                if (upstreamRequestRowIsCacheA) begin
                    // The requested row is cache A
                    
                    // If we do not already have the requested chunk cached, and we are not repeating the previous request
                    if ( !upstreamCachedChunkValidA &&
                         !upstreamCachedChunkPendingA) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequest;
                        upstreamRequestFifoWriteEnableReg <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingA[upstreamRequestChunk] <= 1'b1;
                        upstreamCachedChunkPendingA <= 1'b1;
                    end else begin
                        // No need for an upstream request
                        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
                        upstreamRequestFifoWriteEnableReg <= 1'b0;
                    end
                end else if (upstreamRequestRowIsCacheB) begin
                    // The requested row is cache B
                    
                    // If we do not already have the requested chunk cached, and we are not repeating the previous request
                    if ( !upstreamCachedChunkValidB &&
                         !upstreamCachedChunkPendingB) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequest;
                        upstreamRequestFifoWriteEnableReg <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingB[upstreamRequestChunk] <= 1'b1;
                        upstreamCachedChunkPendingB <= 1'b1;
                    end else begin
                        // No need for an upstream request
                        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
                        upstreamRequestFifoWriteEnableReg <= 1'b0;
                    end
                end else begin
                    // Cached rows are different from requested row, and !downstreamRequestNewRowStall says that
                    // all requests for currently cached rows are complete
                    
                    // Requested row does not match the row cached by the line buffer,
                    // so reset all of the cachedChunkValid bits and update cachedRow
                    if (cachedRowBIsOlder) begin
                        cachedRowB <= upstreamRequestRowStaged;
                        upstreamRequestRowIsCacheB <= 1'b1;
                        cachedChunkValidB <= {MAX_CHUNKS_PER_ROW{1'b0}};
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingB[upstreamRequestChunk] <= 1'b1;
                        upstreamCachedChunkPendingB <= 1'b1;
                        cachedRowBIsOlder <= 1'b0;
                    end else begin
                        cachedRowA <= upstreamRequestRowStaged;
                        upstreamRequestRowIsCacheA <= 1'b1;
                        cachedChunkValidA <= {MAX_CHUNKS_PER_ROW{1'b0}};
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingA[upstreamRequestChunk] <= 1'b1;
                        upstreamCachedChunkPendingA <= 1'b1;
                        cachedRowBIsOlder <= 1'b1;
                    end
                    
                    // Enqueue the upstream request
                    upstreamRequestFifoWriteData <= upstreamRequest;
                    upstreamRequestFifoWriteEnableReg <= 1'b1;
                end
                
                // Remember to service the downstream request later, when the pixel data is cached
                pendingDownstreamResponseFifoWriteData <= {pendingDownstreamResponseScanlinePixelStaged, upstreamRequestRowStaged, upstreamRequestColumnStaged};
                pendingDownstreamResponseFifoWriteEnableReg <= 1'b1;
                
            end else begin
                // Do not write anything to FIFOs
                upstreamRequestFifoWriteEnableReg <= 1'b0;
                pendingDownstreamResponseFifoWriteEnableReg <= 1'b0;
            end
        end
        
        
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
                upstreamResponseState <= UPSTREAM_RESPONSE_STAGE;
                
                // Start reading the next upstream response
                upstreamResponseFifoReadEnableReg <= 1'b1;
            end
            
            UPSTREAM_RESPONSE_STAGE: begin
                // Stage the pending upstream request to improve timing
                upstreamResponseChunk <= pendingUpstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];
                upstreamResponseRowIsCacheA <= 
                    (cachedRowA == pendingUpstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS]);
                upstreamResponseRowIsCacheB <= 
                    (cachedRowB == pendingUpstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS]);
                
                // We should be able to process a pixel next cycle, if available
                upstreamResponseFifoReadEnableReg <= 1'b1;
                // upstreamResponseReady delays upstreamResponseFifoReadEnable by one clock cycle
                // to synchronize upstreamResponseFifoReadData with upstreamResponseColumn
                upstreamResponseReady <= upstreamResponseFifoReadEnable;

                upstreamResponseState <= UPSTREAM_RESPONSE_STORE;
            end

            UPSTREAM_RESPONSE_STORE: begin
                // If we had previously requested a pixel from the upstream FIFO
                if (upstreamResponseReady) begin
                    // Store the response in the appropriate line cache (see combinatorial logic for cache block RAMs)
                    
                    // If that was the last pixel of the chunk, start the next chunk or return to idle
                    if (upstreamResponsePixelCount == {CHUNK_BITS{1'b1}}) begin
                        // Mark the current chunk's cache as valid and no longer pending
                        if (upstreamResponseRowIsCacheA) begin
                            cachedChunkValidA[upstreamResponseChunk] <= 1'b1;
                            cachedChunkPendingA[upstreamResponseChunk] <= 1'b0;
                        end else if (upstreamResponseRowIsCacheB) begin
                            cachedChunkValidB[upstreamResponseChunk] <= 1'b1;
                            cachedChunkPendingB[upstreamResponseChunk] <= 1'b0;
                        end
                        // Reset pixel counter
                        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                        // Do not store next cycle's pixel
                        upstreamResponseReady <= 1'b0;
                        // Do not read another upstream response
                        upstreamResponseFifoReadEnableReg <= 1'b0;
                        
                        if (pendingUpstreamRequestFifoEmpty) begin
                            // No incoming chunk at this point, so return to idle
                            pendingUpstreamRequestFifoReadEnable <= 1'b0;
                            
                            
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
                            upstreamResponseFifoReadEnableReg <= 1'b1;
                        end
                    end
                end else begin
                    // We should be able to process a pixel next cycle, if available
                    upstreamResponseFifoReadEnableReg <= 1'b1;
                    upstreamResponseReady <= upstreamResponseFifoReadEnable;
                end
            end

            default: begin
                upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
            end

        endcase
        
        
        // Downstream response pipeline - Once the line buffer cache contains the upstream data
        // required to respond, calculate scaled pixel data and write to downstream response FIFO
        if (!downstreamResponseStall) begin
            // STAGE 1 - read requested upstream pixel
            pendingDownstreamResponseFifoReadEnableReg <= !pendingDownstreamResponseFifoEmpty;
            
            // STAGE 2 - if read, requested pixel will be ready next cycle
            pendingDownstreamResponseReady <= !pendingDownstreamResponseFifoEmpty && pendingDownstreamResponseFifoReadEnableReg;
            
            // STAGE 3 - stage pendingDownstreamResponseFifoReadData to improve timing
            pendingDownstreamResponseStaged <= pendingDownstreamResponseFifoReadData;
            downstreamCacheRowIsCacheA <= (downstreamCacheRow == cachedRowA);
            downstreamCacheRowIsCacheB <= (downstreamCacheRow == cachedRowB);
            pendingDownstreamResponseAvailable <= pendingDownstreamResponseReady;
            
            // STAGE 4 - downstreamCacheRow and downstreamCacheColumn have the upstream coords
            // This sets cacheReadAddressA and cacheReadAddressB, so next cycle
            // cacheReadDataA and cacheReadDataB will have the pixel colors at that address.
            // downstreamResponseInCacheA will select which cache to use, and 
            // downstreamResponseScanlineBlend will say whether to blend with background color.
            downstreamResponsePixelAvailable <= pendingDownstreamResponseAvailable;
            if (pendingDownstreamResponseAvailable) begin
                // Requested pixel is available, and downstreamResponseStall says it's in the cache
                // Tell next stage which cache to use
                downstreamResponseInCacheA <= downstreamCacheRowIsCacheA;
                // Tell next stage whether to blend with background color
                downstreamResponseScanlineBlend <= pendingDownstreamResponseStaged[HACTIVE_BITS+VACTIVE_BITS];
            end
        end else if (!downstreamResponseFifoFull) begin
            downstreamResponsePixelAvailable <= 1'b0;
        end
        
        // Pre-calculate the cache valid flags for the pending downstream response
        // These need to get updated every clock so that downstreamResponseStall can also be updated
        downstreamCachedChunkValidAStaged <= cachedChunkValidA[pendingDownstreamResponseFifoReadData[HACTIVE_BITS-1:CHUNK_BITS]];
        downstreamCachedChunkValidBStaged <= cachedChunkValidB[pendingDownstreamResponseFifoReadData[HACTIVE_BITS-1:CHUNK_BITS]];
        
        if (!downstreamResponseFifoFull) begin
            // STAGE 5 - select between cacheA and cacheB, and optionally scanline blend
            // Write to response fifo next cycle (as soon as the response fifo is not full)
            downstreamResponseFifoWriteEnableReg <= downstreamResponsePixelAvailable;
            if (downstreamResponsePixelAvailable) begin
                if (downstreamResponseInCacheA) begin
                    if (downstreamResponseScanlineBlend) begin
                        downstreamResponseFifoWriteData <= scanlineBlend(cacheReadDataA, backgroundColor, scanlineIntensity);
                    end else begin
                        downstreamResponseFifoWriteData <= cacheReadDataA;
                    end
                end else begin
                    if (downstreamResponseScanlineBlend) begin
                        downstreamResponseFifoWriteData <= scanlineBlend(cacheReadDataB, backgroundColor, scanlineIntensity);
                    end else begin
                        downstreamResponseFifoWriteData <= cacheReadDataB;
                    end
                end
            end
        end

    end
end

endmodule
