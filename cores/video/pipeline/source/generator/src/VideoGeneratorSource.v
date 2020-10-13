//
// VideoGeneratorSource - Supply pixel chunks from a video generation module to a video pipeline
//
// 
//
//
// Copyright 2020 Reclone Labs <reclonelabs.com>
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

module VideoGeneratorSource #(parameter CHUNK_BITS = 5)
(
    input wire scalerClock,
    input wire reset,

    output reg requestFifoReadEnable = 1'b0,
    input wire requestFifoEmpty,
    input wire [REQUEST_BITS-1:0] requestFifoReadData,
    
    output wire responseFifoWriteEnable,
    input wire responseFifoFull,
    output wire [BITS_PER_PIXEL-1:0] responseFifoWriteData,
    
    output wire [HACTIVE_BITS-1:0] hPos,
    output wire [VACTIVE_BITS-1:0] vPos,
    output reg dataEnable = 1'b0,
    input wire [7:0] r,
    input wire [7:0] g,
    input wire [7:0] b,
    input wire dataEnableDelayed
);

localparam CHUNK_SIZE = 1 << CHUNK_BITS;
localparam HACTIVE_BITS = 11;
localparam VACTIVE_BITS = 11;
localparam CHUNKNUM_BITS = HACTIVE_BITS - CHUNK_BITS;
localparam REQUEST_BITS = VACTIVE_BITS + CHUNKNUM_BITS;
localparam BITS_PER_PIXEL = 16;

// Round/truncate r, g, b to the nearest 5, 6, 5 bit values
/* verilator lint_off UNUSED */
wire [7:0] rRounded = (r[7:3] == 5'h1F) ? r : (r + 8'd4);
wire [7:0] gRounded = (g[7:2] == 6'h3F) ? g : (g + 8'd2);
wire [7:0] bRounded = (b[7:3] == 5'h1F) ? b : (b + 8'd4);
/* verilator lint_on UNUSED */
wire [4:0] rTruncated = rRounded[7:3];
wire [5:0] gTruncated = gRounded[7:2];
wire [4:0] bTruncated = bRounded[7:3];
assign responseFifoWriteData = {rTruncated, gTruncated, bTruncated};
assign responseFifoWriteEnable = dataEnableDelayed;

// Request is {vPos, chunkNum}.  hPos will be (chunkNum << CHUNK_BITS + pixelCount).
reg [CHUNK_BITS-1:0] pixelCount = {CHUNK_BITS{1'b0}};
assign vPos = requestFifoReadData[REQUEST_BITS-1:CHUNKNUM_BITS];
assign hPos = {requestFifoReadData[CHUNKNUM_BITS-1:0], pixelCount};

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        requestFifoReadEnable <= 1'b0;
        dataEnable <= 1'b0;
        pixelCount <= {CHUNK_BITS{1'b0}};
    end else if (dataEnable) begin
        // dataEnable is active, indicating that we ARE trying to get pixels out of the generator
        if (pixelCount == {CHUNK_BITS{1'b1}}) begin
            // Now responding with the last pixel in the chunk
            if (requestFifoReadEnable) begin
                // Next requested chunk number is now present on requestFifoReadData
                requestFifoReadEnable <= 1'b0;
            end else begin
                // De-assert dataEnable because there are no more chunk requests to handle
                dataEnable <= 1'b0;
            end
            // Reset pixel counter to the first pixel of the chunk
            pixelCount <= {CHUNK_BITS{1'b0}};
        end else begin
            if ((pixelCount == {{(CHUNK_BITS-1){1'b1}}, 1'b0}) && !requestFifoEmpty && !responseFifoFull) begin
                // Now responding with the second to last pixel in the chunk, with a new request already queued
                // Get a request from the request FIFO, which will be on requestFifoReadData next clock
                requestFifoReadEnable <= 1'b1;
            end else begin
                requestFifoReadEnable <= 1'b0;
            end
            // Increment pixel counter
            pixelCount <= pixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
        end
    end else begin
        // dataEnable is inactive, indicating that we are NOT yet trying to get pixels out of the generator
        if (!requestFifoReadEnable && !requestFifoEmpty && !responseFifoFull) begin
            // Get a request from the request FIFO, which will be on requestFifoReadData next clock
            requestFifoReadEnable <= 1'b1;
        end else if (requestFifoReadEnable) begin
            // Requested chunk number is now present on requestFifoReadData
            requestFifoReadEnable <= 1'b0;
            // Assert dataEnable which is our flag that we are requesting pixel data out of the generator
            dataEnable <= 1'b1;
            // Start with the first pixel of the chunk
            pixelCount <= {CHUNK_BITS{1'b0}};
        end
    end
end

endmodule

