//
// VideoAggregateScaler - Combine video pipeline filter elements into one configurable element
//
// A generic and flexible video scaling pipeline will connect together several filter modules in a
// specific sequence, to satisfy most of the anticipated scaling use cases of the video pipeline.
// This aggregate scaling module encapsulates a common sequence of pipeline elements utilized by
// top-level video pipeline modules, i.e. GeneratorVideoPipeline and FramebufferVideoPipeline.
//
// The aggregate element connects pipeline filter elements in this sequence:
//
//  VideoCroppingFilter
//  |
//  --> VideoIntegerScale
//      |
//      --> VideoVerticalStretch
//          |
//          --> VideoHorizontalStretch
//              |
//              --> VideoPaddingFilter
//
// Here are some use cases that this aggregate scaler element should be able to handle:
//  - Upscaling low-resolution video content for rendering on higher-resolution displays
//  - Downscaling high-resolution video content for rendering on lower-resolution displays
//  - Hiding or showing overscan lines in source video content
//  - Adjusting aspect ratio of video content, including letterboxing or pillarboxing as needed
//  - Applying simple scanline or LCD effects to better resemble legacy display hardware
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

module VideoAggregateScaler #(parameter CHUNK_BITS = 5, SCALE_FRACTION_BITS = 6)
(
    input wire scalerClock,
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


wire croppingDownstreamRequestFifoReadEnable;
wire croppingDownstreamRequestFifoEmpty;
wire [REQUEST_BITS-1:0] croppingDownstreamRequestFifoReadData;
wire croppingDownstreamResponseFifoWriteEnable;
wire croppingDownstreamResponseFifoFull;
wire [BITS_PER_PIXEL-1:0] croppingDownstreamResponseFifoWriteData;
VideoCroppingFilter #(.CHUNK_BITS(CHUNK_BITS)) croppingFilter
(
    .cropRows(cropRows),
    .cropChunks(cropChunks),
    
    .upstreamRequestFifoReadEnable(upstreamRequestFifoReadEnable),
    .upstreamRequestFifoEmpty(upstreamRequestFifoEmpty),
    .upstreamRequestFifoReadData(upstreamRequestFifoReadData),
    .upstreamResponseFifoWriteEnable(upstreamResponseFifoWriteEnable),
    .upstreamResponseFifoFull(upstreamResponseFifoFull),
    .upstreamResponseFifoWriteData(upstreamResponseFifoWriteData),
    
    .downstreamRequestFifoReadEnable(croppingDownstreamRequestFifoReadEnable),
    .downstreamRequestFifoEmpty(croppingDownstreamRequestFifoEmpty),
    .downstreamRequestFifoReadData(croppingDownstreamRequestFifoReadData),
    .downstreamResponseFifoWriteEnable(croppingDownstreamResponseFifoWriteEnable),
    .downstreamResponseFifoFull(croppingDownstreamResponseFifoFull),
    .downstreamResponseFifoWriteData(croppingDownstreamResponseFifoWriteData)
);

wire scaleDownstreamRequestFifoReadEnable;
wire scaleDownstreamRequestFifoEmpty;
wire [REQUEST_BITS-1:0] scaleDownstreamRequestFifoReadData;
wire scaleDownstreamResponseFifoWriteEnable;
wire scaleDownstreamResponseFifoFull;
wire [BITS_PER_PIXEL-1:0] scaleDownstreamResponseFifoWriteData;
VideoIntegerScale #(.CHUNK_BITS(CHUNK_BITS)) integerScale
(
    .scalerClock(scalerClock),
    .reset(reset),
    
    .hScaleFactor(hScaleFactor),
    .vScaleFactor(vScaleFactor),
    .backgroundColor(backgroundColor),
    .hScanlineEnable(hScanlineEnable),
    .vScanlineEnable(vScanlineEnable),
    .scanlineIntensity(scanlineIntensity),
    
    .upstreamRequestFifoReadEnable(croppingDownstreamRequestFifoReadEnable),
    .upstreamRequestFifoEmpty(croppingDownstreamRequestFifoEmpty),
    .upstreamRequestFifoReadData(croppingDownstreamRequestFifoReadData),
    .upstreamResponseFifoWriteEnable(croppingDownstreamResponseFifoWriteEnable),
    .upstreamResponseFifoFull(croppingDownstreamResponseFifoFull),
    .upstreamResponseFifoWriteData(croppingDownstreamResponseFifoWriteData),
    
    .downstreamRequestFifoReadEnable(scaleDownstreamRequestFifoReadEnable),
    .downstreamRequestFifoEmpty(scaleDownstreamRequestFifoEmpty),
    .downstreamRequestFifoReadData(scaleDownstreamRequestFifoReadData),
    .downstreamResponseFifoWriteEnable(scaleDownstreamResponseFifoWriteEnable),
    .downstreamResponseFifoFull(scaleDownstreamResponseFifoFull),
    .downstreamResponseFifoWriteData(scaleDownstreamResponseFifoWriteData)
);

wire vStretchDownstreamRequestFifoReadEnable;
wire vStretchDownstreamRequestFifoEmpty;
wire [REQUEST_BITS-1:0] vStretchDownstreamRequestFifoReadData;
wire vStretchDownstreamResponseFifoWriteEnable;
wire vStretchDownstreamResponseFifoFull;
wire [BITS_PER_PIXEL-1:0] vStretchDownstreamResponseFifoWriteData;
VideoVerticalStretch #(.CHUNK_BITS(CHUNK_BITS), .SCALE_FRACTION_BITS(SCALE_FRACTION_BITS)) verticalStretch
(
    .scalerClock(scalerClock),
    .reset(reset),
    
    .vShrinkFactor(vShrinkFactor),
    
    .upstreamRequestFifoReadEnable(scaleDownstreamRequestFifoReadEnable),
    .upstreamRequestFifoEmpty(scaleDownstreamRequestFifoEmpty),
    .upstreamRequestFifoReadData(scaleDownstreamRequestFifoReadData),
    .upstreamResponseFifoWriteEnable(scaleDownstreamResponseFifoWriteEnable),
    .upstreamResponseFifoFull(scaleDownstreamResponseFifoFull),
    .upstreamResponseFifoWriteData(scaleDownstreamResponseFifoWriteData),
    
    .downstreamRequestFifoReadEnable(vStretchDownstreamRequestFifoReadEnable),
    .downstreamRequestFifoEmpty(vStretchDownstreamRequestFifoEmpty),
    .downstreamRequestFifoReadData(vStretchDownstreamRequestFifoReadData),
    .downstreamResponseFifoWriteEnable(vStretchDownstreamResponseFifoWriteEnable),
    .downstreamResponseFifoFull(vStretchDownstreamResponseFifoFull),
    .downstreamResponseFifoWriteData(vStretchDownstreamResponseFifoWriteData)
);

wire hStretchDownstreamRequestFifoReadEnable;
wire hStretchDownstreamRequestFifoEmpty;
wire [REQUEST_BITS-1:0] hStretchDownstreamRequestFifoReadData;
wire hStretchDownstreamResponseFifoWriteEnable;
wire hStretchDownstreamResponseFifoFull;
wire [BITS_PER_PIXEL-1:0] hStretchDownstreamResponseFifoWriteData;
VideoHorizontalStretch #(.CHUNK_BITS(CHUNK_BITS), .SCALE_FRACTION_BITS(SCALE_FRACTION_BITS)) horizontalStretch
(
    .scalerClock(scalerClock),
    .reset(reset),
    
    .hShrinkFactor(hShrinkFactor),
    
    .upstreamRequestFifoReadEnable(vStretchDownstreamRequestFifoReadEnable),
    .upstreamRequestFifoEmpty(vStretchDownstreamRequestFifoEmpty),
    .upstreamRequestFifoReadData(vStretchDownstreamRequestFifoReadData),
    .upstreamResponseFifoWriteEnable(vStretchDownstreamResponseFifoWriteEnable),
    .upstreamResponseFifoFull(vStretchDownstreamResponseFifoFull),
    .upstreamResponseFifoWriteData(vStretchDownstreamResponseFifoWriteData),
    
    .downstreamRequestFifoReadEnable(hStretchDownstreamRequestFifoReadEnable),
    .downstreamRequestFifoEmpty(hStretchDownstreamRequestFifoEmpty),
    .downstreamRequestFifoReadData(hStretchDownstreamRequestFifoReadData),
    .downstreamResponseFifoWriteEnable(hStretchDownstreamResponseFifoWriteEnable),
    .downstreamResponseFifoFull(hStretchDownstreamResponseFifoFull),
    .downstreamResponseFifoWriteData(hStretchDownstreamResponseFifoWriteData)
);

VideoPaddingFilter #(.CHUNK_BITS(CHUNK_BITS)) paddingFilter
(
    .scalerClock(scalerClock),
    .reset(reset),
    
    .padTopRows(padTopRows),
    .padLeftColumns(padLeftColumns),
    .sourceRows(sourceRows),
    .sourceColumns(sourceColumns),
    .padColor(padColor),
    
    .upstreamRequestFifoReadEnable(hStretchDownstreamRequestFifoReadEnable),
    .upstreamRequestFifoEmpty(hStretchDownstreamRequestFifoEmpty),
    .upstreamRequestFifoReadData(hStretchDownstreamRequestFifoReadData),
    .upstreamResponseFifoWriteEnable(hStretchDownstreamResponseFifoWriteEnable),
    .upstreamResponseFifoFull(hStretchDownstreamResponseFifoFull),
    .upstreamResponseFifoWriteData(hStretchDownstreamResponseFifoWriteData),
    
    .downstreamRequestFifoReadEnable(downstreamRequestFifoReadEnable),
    .downstreamRequestFifoEmpty(downstreamRequestFifoEmpty),
    .downstreamRequestFifoReadData(downstreamRequestFifoReadData),
    .downstreamResponseFifoWriteEnable(downstreamResponseFifoWriteEnable),
    .downstreamResponseFifoFull(downstreamResponseFifoFull),
    .downstreamResponseFifoWriteData(downstreamResponseFifoWriteData)
);

endmodule
