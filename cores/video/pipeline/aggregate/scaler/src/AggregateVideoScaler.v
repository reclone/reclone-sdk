//
// AggregateVideoScaler - Combine video pipeline filter elements into one configurable element
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
//  --> VideoBinningFilter
//      |
//      --> VideoIntegerScale
//          |
//          --> VideoNonIntegerScale
//              |
//              --> VideoPaddingFilter
//
// Here are some use cases that this aggregate scaler element should be able to handle:
//  - Upscaling low-resolution video content for rendering on higher-resolution displays
//  - Downscaling high-resolution video content for rendering on lower-resolution displays
//  - Hiding or showing overscan lines in source video content
//  - Adjusting aspect ratio of video content, including letterboxing as needed
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

module AggregateVideoScaler #(parameter CHUNK_BITS = 5, SCALE_BITS = 4)
(
    input wire scalerClock,
    input wire reset,

    // Scaling configuration
    input wire [SCALE_BITS-1:0] hScaleFactor, // 1 to 15
    input wire [SCALE_BITS-1:0] vScaleFactor, // 1 to 15
    
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

// TODO add other elements as they are developed (for now this aggregate is just integer scaler)
VideoIntegerScale #(.CHUNK_BITS(CHUNK_BITS), .SCALE_BITS(SCALE_BITS)) integerScale
(
    .scalerClock(scalerClock),
    .reset(reset),
    .hScaleFactor(hScaleFactor),
    .vScaleFactor(vScaleFactor),
    .backgroundColor(backgroundColor),
    .hScanlineEnable(hScanlineEnable),
    .vScanlineEnable(vScanlineEnable),
    .scanlineIntensity(scanlineIntensity),
    .downstreamRequestFifoReadEnable(downstreamRequestFifoReadEnable),
    .downstreamRequestFifoEmpty(downstreamRequestFifoEmpty),
    .downstreamRequestFifoReadData(downstreamRequestFifoReadData),
    .downstreamResponseFifoWriteEnable(downstreamResponseFifoWriteEnable),
    .downstreamResponseFifoFull(downstreamResponseFifoFull),
    .downstreamResponseFifoWriteData(downstreamResponseFifoWriteData),
    .upstreamRequestFifoReadEnable(upstreamRequestFifoReadEnable),
    .upstreamRequestFifoEmpty(upstreamRequestFifoEmpty),
    .upstreamRequestFifoReadData(upstreamRequestFifoReadData),
    .upstreamResponseFifoWriteEnable(upstreamResponseFifoWriteEnable),
    .upstreamResponseFifoFull(upstreamResponseFifoFull),
    .upstreamResponseFifoWriteData(upstreamResponseFifoWriteData)
);

endmodule
