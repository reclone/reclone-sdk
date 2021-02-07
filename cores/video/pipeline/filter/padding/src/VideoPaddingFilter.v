//
// VideoPaddingFilter - Pad the sides of the video frame with a solid color
//
// This padding filter adds bars of a solid color to any side of the video frame.  To do this,
// it requires the dimensions of the source video frame, the amount to pad the left and top sides,
// and the desired padding color.  The source video frame is effectively shifted down and right
// by the specified padding amounts.  Any pixel chunk requested outside of the shifted source
// frame rectangle is filled with the padding color.
//
// If the source video frame dimensions are specified as smaller than its actual dimensions,
// this filter will effectively trim off the bottom and/or right side of the source video,
// by replacing source video content with the padding color.
//
// To keep the design simple, it is only possible to pad a multiple of CHUNK_SIZE pixels
// on the left side, but any number of rows can be padded on the top of the frame.
//
// The padding filter is useful for pillarboxing and/or letterboxing a smaller video frame
// inside a larger output resolution, without scaling.
//
// This padding module is implemented as two state machines that operate in parallel:
//
//  - Downstream Request State Machine
//      This state machine watches a FIFO that receives pixel chunk requests from the downstream
//      pipeline element.  For each downstream request received, if the request is within the
//      video source rectangle, an upstream request is created based on the calculated upstream
//      chunk position.  This state machine also pushes the downstream request into a pending
//      downstream response FIFO, so that each request is handled in order later when pixel data
//      is available.
//
//  - Downstream Response State Machine
//      This state machine actually handles the downstream chunk requests as soon as the required
//      pixel data is available in the line cache.  For each pixel, once the required
//      cachedChunkValid bit is set, the pixel color is copied from the cache to the response FIFO,
//      optionally blending with the backgroundColor for a scanline effect.
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
    // Padding configuration
    input wire [VACTIVE_BITS-1:0] padTopRows,
    input wire [CHUNKNUM_BITS-1:0] padLeftChunks,
    input wire [VACTIVE_BITS-1:0] sourceRows,
    input wire [CHUNKNUM_BITS-1:0] sourceChunks,
    input wire [BITS_PER_PIXEL-1:0] padColor,

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
    output reg upstreamResponseFifoFull,
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

// One-hot states for downstream request state machine
localparam DOWNSTREAM_REQUEST_IDLE = 3'b001, DOWNSTREAM_REQUEST_READ = 3'b010, DOWNSTREAM_REQUEST_STORE = 3'b100;
reg[3:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

wire [VACTIVE_BITS-1:0] requestedRow = downstreamRequestFifoReadData[REQUEST_BITS-1:REQUEST_BITS-VACTIVE_BITS];
wire [CHUNKNUM_BITS-1:0] requestedChunk = downstreamRequestFifoReadData[CHUNKNUM_BITS-1:0];
wire [VACTIVE_BITS-1:0] upstreamRequestRow = requestedRow - padTopRows;
wire [CHUNKNUM_BITS-1:0] upstreamRequestChunk = requestedChunk - padLeftChunks;
wire [REQUEST_BITS-1:0] upstreamRequest = {upstreamRequestRow, upstreamRequestChunk};

reg usePadColorForDownstreamResponse = 1'b1;
assign downstreamResponseFifoWriteData = usePadColorForDownstreamResponse ? padColor : upstreamResponseFifoWriteData;

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


always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        upstreamResponseFifoFull <= 1'b1;
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        upstreamRequestFifoWriteEnable <= 1'b0;
        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
        usePadColorForDownstreamResponse <= 1'b1;
    end else begin
    
        // Request state machine - Get downstream chunk requests, translate chunk coordinates,
        //                         and enqueue upstream chunk requests
        case (downstreamRequestState)
            DOWNSTREAM_REQUEST_IDLE: begin
                // Reset write enables if coming from DOWNSTREAM_REQUEST_STORE or DOWNSTREAM_REQUEST_STALL
                upstreamRequestFifoWriteEnable <= 1'b0;
                pendingDownstreamResponseFifoWriteEnable <= 1'b0;
            
                // Wait for a request
                if (!downstreamRequestFifoEmpty && !upstreamRequestFifoFull && 
                    !pendingDownstreamResponseFifoFull) begin
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
                if (!upstreamRequestFifoFull && !pendingDownstreamResponseFifoFull) begin
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
                end
            end

            DOWNSTREAM_REQUEST_STORE: begin
                // If request is within the source video rectangle, queue the upstream request,
                // otherwise the padding color will be used and no upstream request is required
                if (requestedRow >= padTopRows && 
                    requestedRow < (padTopRows + sourceRows) &&
                    requestedChunk >= padLeftChunks &&
                    requestedChunk < (padLeftChunks + sourceChunks)) begin
                    
                    upstreamRequestFifoWriteEnable <= 1'b1;
                    upstreamRequestFifoWriteData <= upstreamRequest;
                end
                
                // Remember to service the downstream request later
                pendingDownstreamResponseFifoWriteEnable <= 1'b1;
                
                downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
            end

            default: begin
                downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
            end
        endcase
        
        
        // TODO downstream response state machine
        
    end
end

endmodule
