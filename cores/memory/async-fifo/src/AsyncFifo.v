//
// AsyncFifo - First in, first out buffer (queue) for different read and write clock domains
//
// An "asynchronous" fifo is useful for clock domain crossing (CDC), that is, for getting multi-bit
// values from one clock domain to another.  The design of the FIFO has to handle several potential
// pitfalls of crossing clock domains, including differing clock rates, metastability, and release
// from reset.
//
// Address width (ADDR_WIDTH) and data width (DATA_WIDTH) are parameterized in order to size the
// data words, FIFO depth, and dual-port RAM used as the buffer memory.  This FIFO is designed to
// store up to (2^ADDR_WIDTH-1) data words in a circular buffer.
//
// The asyncReset signal has logic to synchronously release the reset in each clock domain.
//
// For some interesting reading on clock domain crossing and asynchronous FIFO design, try these:
// http://www.sunburst-design.com/papers/CummingsSNUG2008Boston_CDC.pdf
// https://zipcpu.com/blog/2017/10/20/cdc.html
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// https://zipcpu.com/blog/2018/07/06/afifo.html
//
// This FIFO uses several design concepts presented in the above papers by
//      Clifford E. Cummings, Sunburst Design, Inc.
// and in blog posts by
//      Dan Gisselquist, Gisselquist Technology, LLC - zipcpu.com
// but this one is written from scratch to be a 2^n-1 item FIFO for a much simpler and leaner
// read/write pointer design, at the expense of one FIFO item.
//
//
// Copyright 2019 Reclone Labs <reclonelabs.com>
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

module AsyncFifo # (parameter DATA_WIDTH = 8, ADDR_WIDTH = 3)
(
    input wire asyncReset,
    
    input wire readClock,
    input wire readEnable,
    output reg empty = 1'b1,
    output wire[DATA_WIDTH-1:0] readData,
    
    input wire writeClock,
    input wire writeEnable,
    output reg full = 1'b0,
    input wire[DATA_WIDTH-1:0] writeData
);

localparam FIFO_DEPTH = 1 << ADDR_WIDTH;

wire [ADDR_WIDTH-1:0] writePointer;
wire [ADDR_WIDTH-1:0] readPointer;

reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
assign readData = mem[readPointer];

wire pushEnable = writeEnable && !full;
wire popEnable = readEnable && !empty;

wire [ADDR_WIDTH-1:0] writePointerNextNext;
reg [ADDR_WIDTH-1:0] writePointerSync1 = {ADDR_WIDTH{1'b0}};
reg [ADDR_WIDTH-1:0] writePointerSync2 = {ADDR_WIDTH{1'b0}};

wire [ADDR_WIDTH-1:0] readPointerNext;
reg [ADDR_WIDTH-1:0] readPointerSync1 = {ADDR_WIDTH{1'b0}};
reg [ADDR_WIDTH-1:0] readPointerSync2 = {ADDR_WIDTH{1'b0}};



reg readSyncReset = 1'b0;
reg writeSyncReset = 1'b0;

GrayCounter #(.WIDTH(ADDR_WIDTH)) writeGrayCounter
(
    .clock(writeClock),
    .enable(pushEnable),
    .reset(writeSyncReset),
    .grayCount(writePointer),
    .grayCountNext(),
    .grayCountNextNext(writePointerNextNext)
);

GrayCounter #(.WIDTH(ADDR_WIDTH)) readGrayCounter
(
    .clock(readClock),
    .enable(popEnable),
    .reset(readSyncReset),
    .grayCount(readPointer),
    .grayCountNext(readPointerNext),
    .grayCountNextNext()
);

always @ (posedge writeClock) begin
    if (writeSyncReset) begin
        readPointerSync1 <= {ADDR_WIDTH{1'b0}};
        readPointerSync2 <= {ADDR_WIDTH{1'b0}};
        full <= 1'b0;
    end else begin
        readPointerSync2 <= readPointerSync1;
        readPointerSync1 <= readPointer;
        
        if (pushEnable == 1'b1) begin
            mem[writePointer] <= writeData;
        end
        
        full <= (writePointerNextNext == readPointerSync2);
    end
end

always @ (posedge readClock) begin
    if (readSyncReset) begin
        writePointerSync1 <= {ADDR_WIDTH{1'b0}};
        writePointerSync2 <= {ADDR_WIDTH{1'b0}};
        empty <= 1'b1;
    end else begin
        writePointerSync2 <= writePointerSync1;
        writePointerSync1 <= writePointer;
        
        empty <= (readPointerNext == writePointerSync2);
    end
end

reg readResetPipe = 1'b0;
always @ (posedge readClock, posedge asyncReset) begin
    if (asyncReset) begin
        readSyncReset <= 1'b1;
        readResetPipe <= 1'b1;
    end else begin
        readSyncReset <= readResetPipe;
        readResetPipe <= 1'b0;
    end
end

reg writeResetPipe = 1'b0;
always @ (posedge writeClock, posedge asyncReset) begin
    if (asyncReset) begin
        writeSyncReset <= 1'b1;
        writeResetPipe <= 1'b1;
    end else begin
        writeSyncReset <= writeResetPipe;
        writeResetPipe <= 1'b0;
    end
end

endmodule
