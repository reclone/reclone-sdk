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
    input wire [BITS_PER_PIXEL-1:0] backgroundColor,
    input wire hScanlineEnable,
    input wire vScanlineEnable,
    input wire [1:0] scanlineIntensity, // 0=25%, 1=50%, 2=75%, 3=100%

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
localparam SCALE_BITS = 3;
localparam RECIPROCAL_FRACTION_BITS = 15;
localparam RECIPROCAL_BITS = 1 + RECIPROCAL_FRACTION_BITS;

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
wire [HACTIVE_BITS-1:0] requestedColumn = {requestedChunk, {CHUNK_BITS{1'b0}}}; // Calculate upstream requests based on first pixel in downstream chunk

reg [VACTIVE_BITS-1:0] cachedRowA = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingA = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [BITS_PER_PIXEL-1:0] cacheA [0:HACTIVE_COLUMNS-1];

reg [VACTIVE_BITS-1:0] cachedRowB = {VACTIVE_BITS{1'b1}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkValidB = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [MAX_CHUNKS_PER_ROW-1:0] cachedChunkPendingB = {MAX_CHUNKS_PER_ROW{1'b0}};
reg [BITS_PER_PIXEL-1:0] cacheB [0:HACTIVE_COLUMNS-1];

reg cachedRowBIsOlder = 1'b0;

// Lookup table of fractions of 32768, index is denominator (except for index 0 which repeats 1)
// floor(x / idx) == floor((x * reciprocalFactors[idx]) >> 15)
reg [RECIPROCAL_BITS-1:0] reciprocalFactors [0:(1 << SCALE_BITS)-1];
initial begin
    $readmemh("integerScaleReciprocalFactors.mem", reciprocalFactors);
end

function [HACTIVE_BITS-1:0] divideCoordBy;
    input [HACTIVE_BITS-1:0] coord;
    input [SCALE_BITS-1:0] dividend;
    /* verilator lint_off UNUSED */
    reg [HACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:0] product;
    /* verilator lint_on UNUSED */
    begin
        product = coord * reciprocalFactors[dividend];
        divideCoordBy = product[HACTIVE_BITS+RECIPROCAL_FRACTION_BITS-1:RECIPROCAL_FRACTION_BITS];
    end
endfunction

wire [VACTIVE_BITS-1:0] upstreamRequestRow = divideCoordBy(requestedRow, vScaleFactor);
/* verilator lint_off UNUSED */
wire [HACTIVE_BITS-1:0] upstreamRequestColumn = divideCoordBy(requestedColumn, hScaleFactor);
/* verilator lint_on UNUSED */
wire [CHUNKNUM_BITS-1:0] upstreamRequestChunk = upstreamRequestColumn[HACTIVE_BITS-1:CHUNK_BITS];
wire [REQUEST_BITS-1:0] upstreamRequest = {upstreamRequestRow, upstreamRequestChunk};

wire [VACTIVE_BITS-1:0] upstreamResponseRow = pendingUpstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] upstreamResponseChunk = pendingUpstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS-1:0] upstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
wire [HACTIVE_BITS-1:0] upstreamResponseColumn = {upstreamResponseChunk, upstreamResponsePixelCount};

wire [VACTIVE_BITS-1:0] downstreamResponseRow = pendingDownstreamResponseFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] downstreamResponseChunk = pendingDownstreamResponseFifoReadData[CHUNKNUM_BITS-1:0];
reg [CHUNK_BITS-1:0] downstreamResponsePixelCount = {CHUNK_BITS{1'b0}};
wire [HACTIVE_BITS-1:0] downstreamResponseColumn = {downstreamResponseChunk, downstreamResponsePixelCount};

wire [VACTIVE_BITS-1:0] downstreamCacheRow  = divideCoordBy(downstreamResponseRow, vScaleFactor);
wire [HACTIVE_BITS-1:0] downstreamCacheColumn = divideCoordBy(downstreamResponseColumn, hScaleFactor);
wire [CHUNKNUM_BITS-1:0] downstreamCacheChunk = downstreamCacheColumn[HACTIVE_BITS-1:CHUNK_BITS];

// The first row and/or column of a scaled-up pixel is a scanline pixel
wire isDownstreamResponseScanlineRow = ((downstreamCacheRow * vScaleFactor) == downstreamResponseRow);
wire isDownstreamResponseScanlineCol = ((downstreamCacheColumn * hScaleFactor) == downstreamResponseColumn);
wire isDownstreamResponseScanlinePixel = ((hScanlineEnable && isDownstreamResponseScanlineRow) || 
                                          (vScanlineEnable && isDownstreamResponseScanlineCol));

reg downstreamResponseFifoWriteEnableReg = 1'b0;
assign downstreamResponseFifoWriteEnable = downstreamResponseFifoFull ? 1'b0 : downstreamResponseFifoWriteEnableReg;

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
wire [REQUEST_BITS-1:0] pendingDownstreamResponseFifoReadData;
reg pendingDownstreamResponseFifoWriteEnable = 1'b0;
SyncFifo #(.DATA_WIDTH(REQUEST_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) pendingDownstreamResponses
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(pendingDownstreamResponseFifoReadEnable),
    .empty(pendingDownstreamResponseFifoEmpty),
    .readData(pendingDownstreamResponseFifoReadData),
    .writeEnable(pendingDownstreamResponseFifoWriteEnable),
    .full(pendingDownstreamResponseFifoFull),
    .writeData(downstreamRequestFifoReadData)
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
        downstreamRequestFifoReadEnable <= 1'b0;
        upstreamResponseFifoReadEnable <= 1'b0;
        upstreamRequestFifoWriteEnable <= 1'b0;
        pendingDownstreamResponseFifoWriteEnable <= 1'b0;
        pendingDownstreamResponseFifoReadEnable <= 1'b0;
        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
        upstreamResponseState <= UPSTREAM_RESPONSE_IDLE;
        upstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        upstreamResponseReady <= 1'b0;
        downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
        downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
        cachedRowA <= {VACTIVE_BITS{1'b1}};
        cachedChunkValidA <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedChunkPendingA <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedRowB <= {VACTIVE_BITS{1'b1}};
        cachedChunkValidB <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedChunkPendingB <= {MAX_CHUNKS_PER_ROW{1'b0}};
        cachedRowBIsOlder <= 1'b0;
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        downstreamResponseFifoWriteEnableReg <= 1'b0;
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
                if (upstreamRequestRow == cachedRowA || upstreamRequestRow == cachedRowB) begin
                    // If we do not already have the requested chunk cached, and we are not repeating the previous request
                    if ((upstreamRequestRow == cachedRowA) && 
                         !cachedChunkValidA[upstreamRequestChunk] &&
                         !cachedChunkPendingA[upstreamRequestChunk]) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequest;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingA[upstreamRequestChunk] <= 1'b1;
                    end else if ((upstreamRequestRow == cachedRowB) && 
                                 !cachedChunkValidB[upstreamRequestChunk] &&
                                 !cachedChunkPendingB[upstreamRequestChunk]) begin
                        // Enqueue the upstream request
                        upstreamRequestFifoWriteData <= upstreamRequest;
                        upstreamRequestFifoWriteEnable <= 1'b1;
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingB[upstreamRequestChunk] <= 1'b1;
                    end
                    
                    // Remember to service the downstream request later, when the pixel data is cached
                    pendingDownstreamResponseFifoWriteEnable <= 1'b1;
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
                end else begin
                    // Cached rows are different from requested row, so stall until all pending requests are complete
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STALL;
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
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingB[upstreamRequestChunk] <= 1'b1;
                        cachedRowBIsOlder <= 1'b0;
                    end else begin
                        cachedRowA <= upstreamRequestRow;
                        cachedChunkValidA <= {MAX_CHUNKS_PER_ROW{1'b0}};
                        // Do not repeat this request while it is in progress
                        cachedChunkPendingA[upstreamRequestChunk] <= 1'b1;
                        cachedRowBIsOlder <= 1'b1;
                    end
                    
                    // Enqueue the upstream request
                    upstreamRequestFifoWriteData <= upstreamRequest;
                    upstreamRequestFifoWriteEnable <= 1'b1;
                    // Remember to service the downstream request later, when the pixel data is cached
                    pendingDownstreamResponseFifoWriteEnable <= 1'b1;
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
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
                downstreamResponseFifoWriteEnableReg <= 1'b0;
                
                // Wait until we can grab a pending downstream response
                if (!pendingDownstreamResponseFifoEmpty) begin
                    pendingDownstreamResponseFifoReadEnable <= 1'b1;
                    downstreamResponsePixelCount <= {CHUNK_BITS{1'b0}};
                    downstreamResponseState <= DOWNSTREAM_RESPONSE_READ;
                end
            end
            
            DOWNSTREAM_RESPONSE_READ: begin
                // Do not write any pixels into the response FIFO
                downstreamResponseFifoWriteEnableReg <= 1'b0;
                // Pending downstream response should be available next cycle
                pendingDownstreamResponseFifoReadEnable <= 1'b0;

                downstreamResponseState <= DOWNSTREAM_RESPONSE_STORE;
            end

            DOWNSTREAM_RESPONSE_STORE: begin
                // If the source pixel is present in the cache, and the downstream response FIFO is not full
                if (((downstreamCacheRow == cachedRowA && cachedChunkValidA[downstreamCacheChunk]) ||
                     (downstreamCacheRow == cachedRowB && cachedChunkValidB[downstreamCacheChunk]))
                        && !downstreamResponseFifoFull) begin
                        
                    // Copy the cached pixel into the response FIFO
                    if (downstreamCacheRow == cachedRowA) begin
                        // Pixel is in row cache A
                        if (isDownstreamResponseScanlinePixel) begin
                            // Blend the pixel color with the background color
                            downstreamResponseFifoWriteData <= scanlineBlend(cacheA[downstreamCacheColumn], backgroundColor, scanlineIntensity);
                        end else begin
                            // Just copy the cached pixel in its entirety
                            downstreamResponseFifoWriteData <= cacheA[downstreamCacheColumn];
                        end
                    end else begin
                        // Pixel is in row cache B
                        if (isDownstreamResponseScanlinePixel) begin
                            // Blend the pixel color with the background color
                            downstreamResponseFifoWriteData <= scanlineBlend(cacheB[downstreamCacheColumn], backgroundColor, scanlineIntensity);
                        end else begin
                            // Just copy the cached pixel in its entirety
                            downstreamResponseFifoWriteData <= cacheB[downstreamCacheColumn];
                        end
                    end
                    
                    // Write to response fifo next cycle (as soon as the response fifo is not full)
                    downstreamResponseFifoWriteEnableReg <= 1'b1;
                    
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
                    // Do not grab another pending downstream response
                    pendingDownstreamResponseFifoReadEnable <= 1'b0;
                    
                    // Set downstream write enable according to the cache status, so that the response is written
                    // as soon as the downstream response fifo is not full
                    downstreamResponseFifoWriteEnableReg <= 
                        ((downstreamCacheRow == cachedRowA && cachedChunkValidA[downstreamCacheChunk]) ||
                         (downstreamCacheRow == cachedRowB && cachedChunkValidB[downstreamCacheChunk]));
                end
            end

            default: begin
                downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
            end

        endcase
    end
end

endmodule
