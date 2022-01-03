//
// AsyncSemaphore - First in, first out buffer (queue) for different read and write clock domains
//
// An "asynchronous" semaphore is useful for clock domain crossing (CDC), that is, for passing
// flags from one clock domain to another.  The design of the semaphore has to handle several potential
// pitfalls of crossing clock domains, including differing clock rates, metastability, and release
// from reset.
//
// The design of AsyncSemaphore is similar to AsyncFifo, with the exception that there is no
// underlying RAM for memory associated with the read and write pointers.  "Put" increments the
// semaphore counter, and "get" decrements the semaphore counter.  See AsyncFifo for background
// info about the design of this module.
//
// Counter width (COUNTER_WIDTH) is parameterized in order to size the gray counter used by the
// semaphore.  This semaphore is designed to count up to (2^ADDR_WIDTH-1) using circular pointers.
//
// The asyncReset signal has logic to synchronously release the reset in each clock domain.
//
//
// Copyright 2019-2022 Reclone Labs <reclonelabs.com>
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

module AsyncSemaphore # (parameter COUNTER_WIDTH = 3)
(
    input wire asyncReset,
    
    input wire getClock,
    input wire getEnable,
    output reg empty = 1'b1,
    
    input wire putClock,
    input wire putEnable,
    output reg full = 1'b0
);

wire [COUNTER_WIDTH-1:0] writePointer;
wire [COUNTER_WIDTH-1:0] readPointer;

wire pushEnable = putEnable && !full;
wire popEnable = getEnable && !empty;

wire [COUNTER_WIDTH-1:0] writePointerNext;
wire [COUNTER_WIDTH-1:0] writePointerNextNext;
reg [COUNTER_WIDTH-1:0] writePointerSync1 = {COUNTER_WIDTH{1'b0}};
reg [COUNTER_WIDTH-1:0] writePointerSync2 = {COUNTER_WIDTH{1'b0}};

wire [COUNTER_WIDTH-1:0] readPointerNext;
reg [COUNTER_WIDTH-1:0] readPointerSync1 = {COUNTER_WIDTH{1'b0}};
reg [COUNTER_WIDTH-1:0] readPointerSync2 = {COUNTER_WIDTH{1'b0}};

reg readSyncReset = 1'b0;
reg writeSyncReset = 1'b0;

GrayCounter #(.WIDTH(COUNTER_WIDTH)) putGrayCounter
(
    .clock(putClock),
    .enable(pushEnable),
    .reset(writeSyncReset),
    .grayCount(writePointer),
    .grayCountNext(writePointerNext),
    .grayCountNextNext(writePointerNextNext)
);

GrayCounter #(.WIDTH(COUNTER_WIDTH)) getGrayCounter
(
    .clock(getClock),
    .enable(popEnable),
    .reset(readSyncReset),
    .grayCount(readPointer),
    .grayCountNext(readPointerNext),
    .grayCountNextNext()
);

always @ (posedge putClock) begin
    if (writeSyncReset) begin
        readPointerSync1 <= {COUNTER_WIDTH{1'b0}};
        readPointerSync2 <= {COUNTER_WIDTH{1'b0}};
        full <= 1'b0;
    end else begin
        readPointerSync2 <= readPointerSync1;
        readPointerSync1 <= readPointer;
        
        if (pushEnable == 1'b1) begin
            full <= (writePointerNextNext == readPointerSync2);
        end else begin
            full <= (writePointerNext == readPointerSync2);
        end
        
        
    end
end

always @ (posedge getClock) begin
    if (readSyncReset) begin
        writePointerSync1 <= {COUNTER_WIDTH{1'b0}};
        writePointerSync2 <= {COUNTER_WIDTH{1'b0}};
        empty <= 1'b1;
    end else begin
        writePointerSync2 <= writePointerSync1;
        writePointerSync1 <= writePointer;
        
        if (popEnable == 1'b1) begin
            empty <= (readPointerNext == writePointerSync2);
        end else begin
            empty <= (readPointer == writePointerSync2);
        end
    end
end

reg readResetPipe = 1'b0;
always @ (posedge getClock, posedge asyncReset) begin
    if (asyncReset) begin
        readSyncReset <= 1'b1;
        readResetPipe <= 1'b1;
    end else begin
        readSyncReset <= readResetPipe;
        readResetPipe <= 1'b0;
    end
end

reg writeResetPipe = 1'b0;
always @ (posedge putClock, posedge asyncReset) begin
    if (asyncReset) begin
        writeSyncReset <= 1'b1;
        writeResetPipe <= 1'b1;
    end else begin
        writeSyncReset <= writeResetPipe;
        writeResetPipe <= 1'b0;
    end
end

endmodule
