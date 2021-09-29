//
// VideoCroppingFilter - Crop the left and/or top sides of the video frame
//
// This simple cropping filter trims a number of pixel rows from the top of the video frame, and/or
// a number of pixel chunks from the left side of the video frame.  It does this simply by
// adding the crop amount to each requested row and/or chunk number.  To keep the design simple,
// it is only possible to crop a multiple of CHUNK_SIZE pixels from the left side, but any number
// of rows can be cropped from the top of the frame.
//
// To crop from the bottom or right side of the frame, simply do not request those chunks.
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

module VideoCroppingFilter #(parameter CHUNK_BITS = 5)
(
    // Cropping configuration
    input wire [VACTIVE_BITS-1:0] cropRows,
    input wire [CHUNKNUM_BITS-1:0] cropChunks,

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

assign downstreamResponseFifoWriteEnable = upstreamResponseFifoWriteEnable;
assign upstreamResponseFifoFull = downstreamResponseFifoFull;
assign downstreamResponseFifoWriteData = upstreamResponseFifoWriteData;

assign downstreamRequestFifoReadEnable = upstreamRequestFifoReadEnable;
assign upstreamRequestFifoEmpty = downstreamRequestFifoEmpty;

wire [VACTIVE_BITS-1:0] requestRow = downstreamRequestFifoReadData[REQUEST_BITS-1:CHUNKNUM_BITS] + cropRows;
wire [CHUNKNUM_BITS-1:0] requestChunk = downstreamRequestFifoReadData[CHUNKNUM_BITS-1:0] + cropChunks;
assign upstreamRequestFifoReadData = {requestRow, requestChunk};

endmodule
