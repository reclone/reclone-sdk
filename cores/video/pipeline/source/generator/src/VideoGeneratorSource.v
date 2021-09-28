//
// VideoGeneratorSource - Supply pixel chunks from a video generation module to a video pipeline
//
// A video generation module takes as inputs the row and column of a desired pixel, and outputs
// the color values of the pixel at that position.  This module converts a video generation module
// into a video pipeline source, so that requested pixel chunks from the generator can be provided
// to downstream pipeline modules.
//
// Given hPos and vPos, the generator module will respond with color data on r, g, and b some number
// of cycles later (generator modules can be pipelined).  It is expected that dataEnableDelayed is
// delayed the same number of cycles, such that dataEnableDelayed is kept in sync with r, g, and b.
//
// This module is useful for testing a video pipeline without the added complexity of a
// framebuffer.  Or, an application can render its display directly in a generator module, and
// utilize downstream video pipeline modules to scale, transform, filter, or otherwise manipulate
// the video frames, as needed.
//
// TODO cope with responseFifoFull
//
// Assumes 16-bit RGB pixel data (5-6-5 red-green-blue).
//
//
// Copyright 2020-2021 Reclone Labs <reclonelabs.com>
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

    output wire requestFifoReadEnable,
    input wire requestFifoEmpty,
    input wire [REQUEST_BITS-1:0] requestFifoReadData,
    
    output reg responseFifoWriteEnable = 1'b0,
    input wire responseFifoFull,
    output wire [BITS_PER_PIXEL-1:0] responseFifoWriteData,
    
    output reg [HACTIVE_BITS-1:0] hPos = {HACTIVE_BITS{1'b0}},
    output reg [VACTIVE_BITS-1:0] vPos = {VACTIVE_BITS{1'b0}},
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

// One-hot states for downstream request state machine
localparam DOWNSTREAM_REQUEST_IDLE = 3'b001, DOWNSTREAM_REQUEST_READ = 3'b010, DOWNSTREAM_REQUEST_STORE = 3'b100;
reg[2:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

wire responseBufferReadEnable;
wire responseBufferWriteEnable;
wire responseBufferEmpty;
wire responseBufferFull;
wire [BITS_PER_PIXEL-1:0] responseBufferReadData;
wire [BITS_PER_PIXEL-1:0] responseBufferWriteData;
SyncFifo #(.DATA_WIDTH(BITS_PER_PIXEL), .ADDR_WIDTH(3)) responseBuffer
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(responseBufferReadEnable),
    .empty(responseBufferEmpty),
    .readData(responseBufferReadData),
    .writeEnable(responseBufferWriteEnable),
    .full(responseBufferFull),
    .writeData(responseBufferWriteData)
);


// Round/truncate r, g, b to the nearest 5, 6, 5 bit values
/* verilator lint_off UNUSED */
wire [7:0] rRounded = (r[7:3] == 5'h1F) ? r : (r + 8'd4);
wire [7:0] gRounded = (g[7:2] == 6'h3F) ? g : (g + 8'd2);
wire [7:0] bRounded = (b[7:3] == 5'h1F) ? b : (b + 8'd4);
/* verilator lint_on UNUSED */
wire [4:0] rTruncated = rRounded[7:3];
wire [5:0] gTruncated = gRounded[7:2];
wire [4:0] bTruncated = bRounded[7:3];

// Write to response buffer whenever dataEnableDelayed is asserted;
// responseBuffer, by design, should never be full due to stalling dataEnable
// whenever responseFifoFull or responseBufferFull is asserted.
assign responseBufferWriteData = {rTruncated, gTruncated, bTruncated};
assign responseBufferWriteEnable = dataEnableDelayed;

// Read items from the response buffer whenever the downstream response FIFO is not full
assign responseBufferReadEnable = !responseBufferEmpty && !responseFifoFull;
assign responseFifoWriteData = responseBufferReadData;

// Request is {vPos, chunkNum}.  hPos will be (chunkNum << CHUNK_BITS + pixelCount).
reg [CHUNK_BITS-1:0] pixelCount = {CHUNK_BITS{1'b0}};

reg requestFifoReadEnableReg = 1'b0;
assign requestFifoReadEnable = requestFifoReadEnableReg && !responseFifoFull && !responseBufferFull;

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        requestFifoReadEnableReg <= 1'b0;
        dataEnable <= 1'b0;
        pixelCount <= {CHUNK_BITS{1'b0}};
        responseFifoWriteEnable <= 1'b0;
        hPos <= {HACTIVE_BITS{1'b0}};
        vPos <= {VACTIVE_BITS{1'b0}};
    end else begin
        
        // Request state machine - Get downstream chunk requests and enqueue upstream chunk requests
        case (downstreamRequestState)
            DOWNSTREAM_REQUEST_IDLE: begin
                dataEnable <= 1'b0;
                if (!requestFifoEmpty && !responseFifoFull && !responseBufferFull) begin
                    requestFifoReadEnableReg <= 1'b1;
                    downstreamRequestState <= DOWNSTREAM_REQUEST_READ;
                end
            end

            DOWNSTREAM_REQUEST_READ: begin
                requestFifoReadEnableReg <= 1'b0;
                dataEnable <= 1'b0;
                
                if (!responseFifoFull && !responseBufferFull) begin
                    // Request should be available next cycle
                    downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
                    pixelCount <= {CHUNK_BITS{1'b0}};
                end
            end

            DOWNSTREAM_REQUEST_STORE: begin
                if (!responseFifoFull && !responseBufferFull) begin
                    // Supply the next position to the generator module pipeline
                    dataEnable <= 1'b1;
                    vPos <= requestFifoReadData[REQUEST_BITS-1:CHUNKNUM_BITS];
                    hPos <= {requestFifoReadData[CHUNKNUM_BITS-1:0], pixelCount};
                    
                    if (pixelCount == {CHUNK_BITS{1'b1}}) begin
                        if (requestFifoReadEnableReg) begin
                            // Already reading the next chunk, so remain in DOWNSTREAM_REQUEST_STORE state
                            requestFifoReadEnableReg <= 1'b0;
                            pixelCount <= {CHUNK_BITS{1'b0}};
                        end else if (!requestFifoEmpty) begin
                            // Start reading the next chunk request
                            requestFifoReadEnableReg <= 1'b1;
                            downstreamRequestState <= DOWNSTREAM_REQUEST_READ;
                        end else begin
                            // Return to idle
                            downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
                        end
                    end else begin
                        pixelCount <= pixelCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
                        
                        // If second to last pixel in chunk
                        if (pixelCount == {{(CHUNK_BITS-1){1'b1}}, 1'b0}) begin
                            if (!requestFifoEmpty) begin
                                // Start reading the next chunk request
                                requestFifoReadEnableReg <= 1'b1;
                            end
                        end
                    end
                end else begin
                    // Do not request another pixel position 
                    dataEnable <= 1'b0;
                end
            end
            
            default: begin
                downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
            end
        endcase
        
        // Always write to the downstream FIFO immediately after reading the response buffer
        responseFifoWriteEnable <= responseBufferReadEnable;
        
    end
end

endmodule

