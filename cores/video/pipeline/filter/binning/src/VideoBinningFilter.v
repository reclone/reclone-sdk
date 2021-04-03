//
// VideoBinningFilter - Average four pixels into one to effectively halve video height and width
//
// A binning filter is useful for downscaling.  If a video frame is downscaled with bilinear
// interpolation such that the output width or height is less than 50% of the input dimension,
// then some input rows or columns are skipped and the output video frame looks horrible.
// Binning, however, combines each square of pixels into a single pixel, by averaging the color
// values into one pixel.  This results a better looking downscale because each input pixel is
// represented equally in the output frame.
//
// For simplicity, and to limit latency, this binning filter is hard coded to combine each 2x2
// square of pixels into one pixel, effectively scaling width and height to half of the original.
// To scale by 1/4x, 1/8x, etc., instances of this binning filter can be cascaded.
//
// To achieve scale factors between 25% and 50%, use a binning filter followed by a non-integer
// scaler that uses bilinear interpolation.
//
// Because no two downstream rows utilize the same upstream row, caching a whole upstream row
// would not provide any benefits.  Instead, four upstream chunks are requested for each downstream
// chunk request.  Once the four upstream chunks are cached, the downstream chunk can be calculated
// and provided to the downstream response FIFO.
//
// Upstream pixels are pushed into two 32-bit-wide FIFO buffers, one buffer for the even row and
// one buffer for the odd row, with each 32 bit word containing two 16 bit pixels.  That makes it
// very simple to calculate downstream pixels - if both buffers are not empty, pop one word from
// each buffer, calculate the binned pixel color, and provide it to the downstream response FIFO.
//
// The upstream video source must have a width that is a multiple of CHUNK_SIZE*2, or at least
// have padding of some sort to ensure that the remainder can be provided.
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

module VideoBinningFilter #(parameter CHUNK_BITS = 5)
(
    input wire scalerClock,
    input wire reset,
    
    // Binning configuration
    input wire enableBinning,
    
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
localparam ROW_BUFFER_WORD_BITS = BITS_PER_PIXEL * 2;

// One-hot states for downstream request state machine
localparam DOWNSTREAM_REQUEST_IDLE = 3'b001, DOWNSTREAM_REQUEST_READ = 3'b010, DOWNSTREAM_REQUEST_STORE = 3'b100;
reg[2:0] downstreamRequestState = DOWNSTREAM_REQUEST_IDLE;

// One-hot states for upstream response state machine
localparam UPSTREAM_RESPONSE_FIRST_PIXEL = 2'b01, UPSTREAM_RESPONSE_SECOND_PIXEL = 2'b10;
reg [1:0] upstreamResponseState = UPSTREAM_RESPONSE_FIRST_PIXEL;

// One-hot states for downstream response state machine
localparam DOWNSTREAM_RESPONSE_IDLE = 2'b01, DOWNSTREAM_RESPONSE_STORE = 2'b10;
reg [1:0] downstreamResponseState = DOWNSTREAM_RESPONSE_IDLE;


// evenRowBuffer and oddRowBuffer queue received upstream pixels to be binned

reg evenRowBufferReadEnable = 1'b0;
reg evenRowBufferWriteEnable = 1'b0;
wire evenRowBufferEmpty;
wire evenRowBufferFull;
wire [ROW_BUFFER_WORD_BITS-1:0] evenRowBufferReadData;
reg [ROW_BUFFER_WORD_BITS-1:0] evenRowBufferWriteData = {ROW_BUFFER_WORD_BITS{1'b0}};
SyncFifo #(.DATA_WIDTH(ROW_BUFFER_WORD_BITS), .ADDR_WIDTH(CHUNK_BITS)) evenRowBuffer
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(evenRowBufferReadEnable),
    .empty(evenRowBufferEmpty),
    .readData(evenRowBufferReadData),
    .writeEnable(evenRowBufferWriteEnable),
    .full(evenRowBufferFull),
    .writeData(evenRowBufferWriteData)
);

reg oddRowBufferReadEnable = 1'b0;
reg oddRowBufferWriteEnable = 1'b0;
wire oddRowBufferEmpty;
wire oddRowBufferFull;
wire [ROW_BUFFER_WORD_BITS-1:0] oddRowBufferReadData;
reg [ROW_BUFFER_WORD_BITS-1:0] oddRowBufferWriteData = {ROW_BUFFER_WORD_BITS{1'b0}};
SyncFifo #(.DATA_WIDTH(ROW_BUFFER_WORD_BITS), .ADDR_WIDTH(CHUNK_BITS)) oddRowBuffer
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(oddRowBufferReadEnable),
    .empty(oddRowBufferEmpty),
    .readData(oddRowBufferReadData),
    .writeEnable(oddRowBufferWriteEnable),
    .full(oddRowBufferFull),
    .writeData(oddRowBufferWriteData)
);

reg responseRowOdd = 1'b0;
reg [CHUNK_BITS-1:0] responseCount = {CHUNK_BITS{1'b0}};

function [BITS_PER_PIXEL-1:0] binningBlend;
    input [BITS_PER_PIXEL-1:0] pixelA;
    input [BITS_PER_PIXEL-1:0] pixelB;
    input [BITS_PER_PIXEL-1:0] pixelC;
    input [BITS_PER_PIXEL-1:0] pixelD;
    
    /* verilator lint_off UNUSED */
    reg [4:0] pixelARed = 5'd0;
    reg [5:0] pixelAGreen = 6'd0;
    reg [4:0] pixelABlue = 5'd0;
    reg [4:0] pixelBRed = 5'd0;
    reg [5:0] pixelBGreen = 6'd0;
    reg [4:0] pixelBBlue = 5'd0;
    reg [4:0] pixelCRed = 5'd0;
    reg [5:0] pixelCGreen = 6'd0;
    reg [4:0] pixelCBlue = 5'd0;
    reg [4:0] pixelDRed = 5'd0;
    reg [5:0] pixelDGreen = 6'd0;
    reg [4:0] pixelDBlue = 5'd0;
    /* verilator lint_on UNUSED */
    
    reg [4:0] blendedRed = 5'd0;
    reg [5:0] blendedGreen = 6'd0;
    reg [4:0] blendedBlue = 5'd0;
    begin
        pixelARed = pixelA[15:11];
        pixelAGreen = pixelA[10:5];
        pixelABlue = pixelA[4:0];
        pixelBRed = pixelB[15:11];
        pixelBGreen = pixelB[10:5];
        pixelBBlue = pixelB[4:0];
        pixelCRed = pixelC[15:11];
        pixelCGreen = pixelC[10:5];
        pixelCBlue = pixelC[4:0];
        pixelDRed = pixelD[15:11];
        pixelDGreen = pixelD[10:5];
        pixelDBlue = pixelD[4:0];
        
        blendedRed = {2'b00, pixelARed[4:2]} + {2'b00, pixelBRed[4:2]} + {2'b00, pixelCRed[4:2]} + {2'b00, pixelDRed[4:2]};
        blendedGreen = {2'b00, pixelAGreen[5:2]} + {2'b00, pixelBGreen[5:2]} + {2'b00, pixelCGreen[5:2]} + {2'b00, pixelDGreen[5:2]};
        blendedBlue = {2'b00, pixelABlue[4:2]} + {2'b00, pixelBBlue[4:2]} + {2'b00, pixelCBlue[4:2]} + {2'b00, pixelDBlue[4:2]};
        
        binningBlend = {blendedRed, blendedGreen, blendedBlue};
    end
endfunction

wire [BITS_PER_PIXEL-1:0] blendedPixel = binningBlend(evenRowBufferReadData[ROW_BUFFER_WORD_BITS-1:BITS_PER_PIXEL],
                                                      evenRowBufferReadData[BITS_PER_PIXEL-1:0],
                                                      oddRowBufferReadData[ROW_BUFFER_WORD_BITS-1:BITS_PER_PIXEL],
                                                      oddRowBufferReadData[BITS_PER_PIXEL-1:0]);



// Four upstream requests per downstream request
// High bit specifies even/odd row number; low bit specifies even/odd chunk number
reg [1:0] upstreamRequestCount = 2'd0;
reg [REQUEST_BITS-1:0] upstreamRequestFifoWriteData = {REQUEST_BITS{1'b0}};
wire [REQUEST_BITS-1:0] nextUpstreamRequest = 
    {downstreamRequestFifoReadData[REQUEST_BITS-2:CHUNKNUM_BITS], upstreamRequestCount[1],
     downstreamRequestFifoReadData[CHUNKNUM_BITS-2:0], upstreamRequestCount[0]};

// upstreamRequests FIFO provides chunk requests to the upstream pipeline element
reg upstreamRequestFifoWriteEnable = 1'b0;
wire upstreamRequestFifoFull;
wire [REQUEST_BITS-1:0] upstreamRequestFifoReadDataBinning;
wire upstreamRequestFifoEmptyBinning;
wire upstreamRequestFifoReadEnableBinning;
SyncFifo #(.DATA_WIDTH(REQUEST_BITS), .ADDR_WIDTH(CHUNKNUM_BITS)) upstreamRequests
(
    .asyncReset(reset),
    .clock(scalerClock),
    .readEnable(upstreamRequestFifoReadEnableBinning),
    .empty(upstreamRequestFifoEmptyBinning),
    .readData(upstreamRequestFifoReadDataBinning),
    .writeEnable(upstreamRequestFifoWriteEnable),
    .full(upstreamRequestFifoFull),
    .writeData(upstreamRequestFifoWriteData)
);

reg downstreamRequestFifoReadEnableBinning = 1'b0;
reg downstreamResponseFifoWriteEnableBinning = 1'b0;

assign downstreamResponseFifoWriteData = enableBinning ? blendedPixel : upstreamResponseFifoWriteData;
assign downstreamResponseFifoWriteEnable = enableBinning ? downstreamResponseFifoWriteEnableBinning : upstreamResponseFifoWriteEnable;
assign upstreamRequestFifoReadData = enableBinning ? upstreamRequestFifoReadDataBinning : downstreamRequestFifoReadData;
assign upstreamRequestFifoEmpty = enableBinning ? upstreamRequestFifoEmptyBinning : downstreamRequestFifoEmpty;
assign upstreamRequestFifoReadEnableBinning = enableBinning ? upstreamRequestFifoReadEnable : 1'b0;
assign downstreamRequestFifoReadEnable = enableBinning ? downstreamRequestFifoReadEnableBinning : upstreamRequestFifoReadEnable;
assign upstreamResponseFifoFull = enableBinning ? (evenRowBufferFull || oddRowBufferFull) : downstreamResponseFifoFull;

always @ (posedge scalerClock or posedge reset) begin
    if (reset) begin
        // Asynchronous reset
        evenRowBufferReadEnable <= 1'b0;
        evenRowBufferWriteEnable <= 1'b0;
        oddRowBufferReadEnable <= 1'b0;
        oddRowBufferWriteEnable <= 1'b0;
        upstreamRequestFifoWriteEnable <= 1'b0;
        upstreamRequestCount <= 2'd0;
        downstreamRequestFifoReadEnableBinning <= 1'b0;
        downstreamResponseFifoWriteEnableBinning <= 1'b0;
        upstreamRequestFifoWriteData <= {REQUEST_BITS{1'b0}};
        responseRowOdd <= 1'b0;
        responseCount <= {CHUNK_BITS{1'b0}};
        evenRowBufferWriteData <= {ROW_BUFFER_WORD_BITS{1'b0}};
        oddRowBufferWriteData <= {ROW_BUFFER_WORD_BITS{1'b0}};
        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
        upstreamResponseState <= UPSTREAM_RESPONSE_FIRST_PIXEL;
        downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
    end else begin
        
        // Request state machine - Get downstream chunk requests and enqueue upstream chunk requests
        case (downstreamRequestState)
            DOWNSTREAM_REQUEST_IDLE: begin
                // Reset write enable
                upstreamRequestFifoWriteEnable <= 1'b0;
            
                // Wait for a request
                if (enableBinning && !downstreamRequestFifoEmpty && !upstreamRequestFifoFull) begin
                    // Read the request
                    // It should be available during DOWNSTREAM_REQUEST_STORE
                    downstreamRequestFifoReadEnableBinning <= 1'b1;
                    
                    downstreamRequestState <= DOWNSTREAM_REQUEST_READ;
                end
            end

            DOWNSTREAM_REQUEST_READ: begin
                downstreamRequestFifoReadEnableBinning <= 1'b0;
                // Reset the upstream request count
                upstreamRequestCount <= 2'd0;
                // Request should be available next cycle
                downstreamRequestState <= DOWNSTREAM_REQUEST_STORE;
            end

            DOWNSTREAM_REQUEST_STORE: begin
                if (upstreamRequestFifoFull) begin
                    // Cannot write another request into the FIFO
                    upstreamRequestFifoWriteEnable <= 1'b0;
                end else begin
                    // Can write the next request into the FIFO
                    upstreamRequestFifoWriteEnable <= 1'b1;
                    upstreamRequestFifoWriteData <= nextUpstreamRequest;
                    
                    if (upstreamRequestCount == 2'd3) begin
                        // This is the fourth and last upstream request for this downstream request, so go back to idle
                        downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
                        upstreamRequestCount <= 2'd0;
                    end else begin
                        // Move on to the next upstream request
                        upstreamRequestCount <= upstreamRequestCount + 2'd1;
                    end
                end
            end
            
            default: begin
                downstreamRequestState <= DOWNSTREAM_REQUEST_IDLE;
            end
        endcase
        
        // Upstream response state machine - Copy received upstream pixel data into cache FIFOs
        case (upstreamResponseState)

            UPSTREAM_RESPONSE_FIRST_PIXEL: begin
                if (upstreamResponseFifoWriteEnable && !upstreamResponseFifoFull) begin
                    // Save the first pixel into the appropriate write data register
                    if (responseRowOdd) begin
                        // Odd row
                        oddRowBufferWriteData[BITS_PER_PIXEL-1:0] <= upstreamResponseFifoWriteData;
                    end else begin
                        // Even row
                        evenRowBufferWriteData[BITS_PER_PIXEL-1:0] <= upstreamResponseFifoWriteData;
                    end
                    
                    upstreamResponseState <= UPSTREAM_RESPONSE_SECOND_PIXEL;
                end
                
                oddRowBufferWriteEnable <= 1'b0;
                evenRowBufferWriteEnable <= 1'b0;
            end
            
            UPSTREAM_RESPONSE_SECOND_PIXEL: begin
                if (upstreamResponseFifoWriteEnable && !upstreamResponseFifoFull) begin
                    // Save the second pixel into the appropriate write data register, and write the two-pixel word into the FIFO
                    if (responseRowOdd) begin
                        // Odd row
                        oddRowBufferWriteData[ROW_BUFFER_WORD_BITS-1:BITS_PER_PIXEL] <= upstreamResponseFifoWriteData;
                        oddRowBufferWriteEnable <= 1'b1;
                    end else begin
                        // Even row
                        evenRowBufferWriteData[ROW_BUFFER_WORD_BITS-1:BITS_PER_PIXEL] <= upstreamResponseFifoWriteData;
                        evenRowBufferWriteEnable <= 1'b1;
                    end
                    
                    if (responseCount == {CHUNK_BITS{1'b1}}) begin
                        // Last response word for this row
                        responseCount <= {CHUNK_BITS{1'b0}};
                        responseRowOdd <= !responseRowOdd;
                    end else begin
                        responseCount <= responseCount + {{(CHUNK_BITS-1){1'b0}}, 1'b1};
                    end
                    
                    upstreamResponseState <= UPSTREAM_RESPONSE_FIRST_PIXEL;
                end
            end

            default: begin
                upstreamResponseState <= UPSTREAM_RESPONSE_FIRST_PIXEL;
            end

        endcase
        
        // Downstream response state machine - When both the even and odd cache FIFOs are not empty,
        // pop both 32-bit words, blend the four pixels into one 16-bit pixel, and write it to the downstream FIFO.
        case (downstreamResponseState)

            DOWNSTREAM_RESPONSE_IDLE: begin
                // Do not write any pixels into the response FIFO
                downstreamResponseFifoWriteEnableBinning <= 1'b0;
                
                // Wait until both cache FIFOs are not empty
                if (!evenRowBufferEmpty && !oddRowBufferEmpty) begin
                    // Read a two-pixel word from each row buffer
                    evenRowBufferReadEnable <= 1'b1;
                    oddRowBufferReadEnable <= 1'b1;
                    downstreamResponseState <= DOWNSTREAM_RESPONSE_STORE;
                end
            end
            
            DOWNSTREAM_RESPONSE_STORE: begin
                // Row buffer words will be available next cycle
                evenRowBufferReadEnable <= 1'b0;
                oddRowBufferReadEnable <= 1'b0;
                // Write the blended pixel when it is available
                downstreamResponseFifoWriteEnableBinning <= 1'b1;
                downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
            end
            
            default: begin
                downstreamResponseState <= DOWNSTREAM_RESPONSE_IDLE;
            end

        endcase
    end
end

endmodule
