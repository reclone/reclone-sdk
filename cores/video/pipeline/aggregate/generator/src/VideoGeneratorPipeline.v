//
// VideoGeneratorPipeline - Combine generator source, scaler, and timing sink into one module
//
// This module encapsulates one use case for the video pipeline.
// It wires together generator source, scaler aggregate filter, and timing sink elements.
//
// The video generator pipeline connects elements in this sequence:
//
//  VideoGeneratorSource --> VideoAggregateScaler --> VideoTimingSink
//
// Since the source element of this pipeline is VideoGeneratorSource, the input pixel colors are
// some function of the horizontal and vertical position of the pixel.  This is useful when
// testing the scaler filter elements using a simple test pattern, or when implementing a
// video chip that calculates each pixel "just in time" as each line is scanned.
// However, that also means that it is only possible to run the video chip at exactly real-time,
// since pausing, speeding up, or slowing down the chip may result in corrupted pixel data or
// loss of video sync.  Consider VideoFramebufferSource if you want more timing flexibility,
// at the expense of additional memory requirements and memory bandwidth utilization.
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

module VideoGeneratorPipeline #(parameter CHUNK_BITS = 5, SCALE_FRACTION_BITS = 6)
(
    input wire scalerClock,
    input wire pixelClock,
    input wire reset,

    // Cropping configuration
    input wire [VACTIVE_BITS-1:0] cropRows,
    input wire [CHUNKNUM_BITS-1:0] cropChunks,

    // Padding configuration
    input wire [VACTIVE_BITS-1:0] padTopRows,
    input wire [HACTIVE_BITS-1:0] padLeftColumns,
    input wire [VACTIVE_BITS-1:0] sourceRows,
    input wire [HACTIVE_BITS-1:0] sourceColumns,
    input wire [BITS_PER_PIXEL-1:0] padColor,

    // Integer scaling configuration
    input wire [INTEGER_SCALE_BITS-1:0] hScaleFactor,
    input wire [INTEGER_SCALE_BITS-1:0] vScaleFactor,

    // Stretching configuration
    input wire [STRETCH_SCALE_BITS-1:0] hShrinkFactor,
    input wire [STRETCH_SCALE_BITS-1:0] vShrinkFactor,

    // Scanline effect configuration
    input wire [BITS_PER_PIXEL-1:0] backgroundColor,
    input wire hScanlineEnable,
    input wire vScanlineEnable,
    input wire [1:0] scanlineIntensity, // 0=25%, 1=50%, 2=75%, 3=100%

    // Video timing configuration
    input wire [6:0] hFrontPorch,
    input wire [7:0] hSyncPulse,
    input wire [7:0] hBackPorch,
    input wire [HACTIVE_BITS-1:0] hActive,
    input wire [5:0] vFrontPorch,
    input wire [3:0] vSyncPulse,
    input wire [5:0] vBackPorch,
    input wire [VACTIVE_BITS-1:0] vActive,
    input wire isInterlaced,

    // Video generator interface
    output wire [HACTIVE_BITS-1:0] generatorHPos,
    output wire [VACTIVE_BITS-1:0] generatorVPos,
    output wire generatorDataEnable,
    input wire [7:0] generatorR,
    input wire [7:0] generatorG,
    input wire [7:0] generatorB,
    input wire generatorDataEnableDelayed,
    
    // Video signal output
    output wire dataEnable,
    output wire hSync,
    output wire vSync,
    output wire activeVideoPreamble,
    output wire activeVideoGuardBand,
    output wire [7:0] blue,
    output wire [7:0] green,
    output wire [7:0] red,
    output wire late
);

localparam STRETCH_SCALE_BITS = SCALE_FRACTION_BITS + 1;
localparam INTEGER_SCALE_BITS = 3;
localparam CHUNK_SIZE = 1 << CHUNK_BITS;
localparam HACTIVE_BITS = 11;
localparam HACTIVE_COLUMNS = 1 << HACTIVE_BITS;
localparam VACTIVE_BITS = 11;
localparam CHUNKNUM_BITS = HACTIVE_BITS - CHUNK_BITS;
localparam MAX_CHUNKS_PER_ROW = 1 << CHUNKNUM_BITS;
localparam REQUEST_BITS = VACTIVE_BITS + CHUNKNUM_BITS;
localparam BITS_PER_PIXEL = 16;


wire generatorRequestFifoReadEnable;
wire generatorRequestFifoEmpty;
wire [REQUEST_BITS-1:0] generatorRequestFifoReadData;
wire generatorResponseFifoWriteEnable;
wire generatorResponseFifoFull;
wire [BITS_PER_PIXEL-1:0] generatorResponseFifoWriteData;
VideoGeneratorSource # (.CHUNK_BITS(CHUNK_BITS)) generatorSource
(
    .scalerClock(scalerClock),
    .reset(reset),

    .requestFifoReadEnable(generatorRequestFifoReadEnable),
    .requestFifoEmpty(generatorRequestFifoEmpty),
    .requestFifoReadData(generatorRequestFifoReadData),
    
    .responseFifoWriteEnable(generatorResponseFifoWriteEnable),
    .responseFifoFull(generatorResponseFifoFull),
    .responseFifoWriteData(generatorResponseFifoWriteData),
    
    .hPos(generatorHPos),
    .vPos(generatorVPos),
    .dataEnable(generatorDataEnable),
    .r(generatorR),
    .g(generatorG),
    .b(generatorB),
    .dataEnableDelayed(generatorDataEnableDelayed)
);


wire timingRequestFifoReadEnable;
wire timingRequestFifoEmpty;
wire [REQUEST_BITS-1:0] timingRequestFifoReadData;
wire timingResponseFifoWriteEnable;
wire timingResponseFifoFull;
wire [BITS_PER_PIXEL-1:0] timingResponseFifoWriteData;
VideoAggregateScaler #(.CHUNK_BITS(CHUNK_BITS), .SCALE_FRACTION_BITS(SCALE_FRACTION_BITS)) scaler
(
    .scalerClock(scalerClock),
    .reset(reset),

    // Cropping configuration
    .cropRows(cropRows),
    .cropChunks(cropChunks),

    // Padding configuration
    .padTopRows(padTopRows),
    .padLeftColumns(padLeftColumns),
    .sourceRows(sourceRows),
    .sourceColumns(sourceColumns),
    .padColor(padColor),

    // Integer scaling configuration
    .hScaleFactor(hScaleFactor),
    .vScaleFactor(vScaleFactor),

    // Stretching configuration
    .hShrinkFactor(hShrinkFactor),
    .vShrinkFactor(vShrinkFactor),

    // Scanline effect configuration
    .backgroundColor(backgroundColor),
    .hScanlineEnable(hScanlineEnable),
    .vScanlineEnable(vScanlineEnable),
    .scanlineIntensity(scanlineIntensity),

    // Filter module reads from the downstream request FIFO...
    .downstreamRequestFifoReadEnable(timingRequestFifoReadEnable),
    .downstreamRequestFifoEmpty(timingRequestFifoEmpty),
    .downstreamRequestFifoReadData(timingRequestFifoReadData),
    // ...and writes to the downstream response FIFO.
    .downstreamResponseFifoWriteEnable(timingResponseFifoWriteEnable),
    .downstreamResponseFifoFull(timingResponseFifoFull),
    .downstreamResponseFifoWriteData(timingResponseFifoWriteData),
    
    // Filter module exposes upstream request FIFO for reading...
    .upstreamRequestFifoReadEnable(generatorRequestFifoReadEnable),
    .upstreamRequestFifoEmpty(generatorRequestFifoEmpty),
    .upstreamRequestFifoReadData(generatorRequestFifoReadData),
    // ...and exposes upstream response FIFO for writing.
    .upstreamResponseFifoWriteEnable(generatorResponseFifoWriteEnable),
    .upstreamResponseFifoFull(generatorResponseFifoFull),
    .upstreamResponseFifoWriteData(generatorResponseFifoWriteData)
);


VideoTimingSink # (.CHUNK_BITS(CHUNK_BITS)) timingSink
(
    .pixelClock(pixelClock),
    .scalerClock(scalerClock),
    .reset(reset),
    
    .hFrontPorch(hFrontPorch),
    .hSyncPulse(hSyncPulse),
    .hBackPorch(hBackPorch),
    .hActive(hActive),
    .vFrontPorch(vFrontPorch),
    .vSyncPulse(vSyncPulse),
    .vBackPorch(vBackPorch),
    .vActive(vActive),
    .isInterlaced(isInterlaced),
    
    .requestFifoReadEnable(timingRequestFifoReadEnable),
    .requestFifoEmpty(timingRequestFifoEmpty),
    .requestFifoReadData(timingRequestFifoReadData),
    
    .responseFifoWriteEnable(timingResponseFifoWriteEnable),
    .responseFifoFull(timingResponseFifoFull),
    .responseFifoWriteData(timingResponseFifoWriteData),

    .dataEnable(dataEnable),
    .hSync(hSync),
    .vSync(vSync),
    .activeVideoPreamble(activeVideoPreamble),
    .activeVideoGuardBand(activeVideoGuardBand),
    .blue(blue),
    .green(green),
    .red(red),
    .late(late)

);

endmodule

