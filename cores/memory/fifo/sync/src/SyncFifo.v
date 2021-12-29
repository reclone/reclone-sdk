//
// SyncFifo - First in, first out buffer (queue) for read and write in the same clock domain
//
// A "synchronous" fifo uses the same clock input for both reading and writing.  It is useful
// for buffering (queueing) bursts of data within a single clock domain.
//
// Address width (ADDR_WIDTH) and data width (DATA_WIDTH) are parameterized in order to size the
// data words, FIFO depth, and dual-port RAM used as the buffer memory.  This FIFO is designed to
// store up to (2^ADDR_WIDTH) data words in a circular buffer.
//
// You may read from the FIFO by asserting 'readEnable' whenever 'empty'==0, and you may write to
// the FIFO by asserting 'writeEnable' whenever 'full'==0.  It is perfectly fine to both
// read and write in the same clock cycle, as long as 'full' and 'empty' are both zero.
//
// The design of this module is much simpler and leaner than AsyncFifo, because this module
// does not have to deal with crossing clock domains.
//
// The RAM encapsulated by this FIFO uses the BlockRamDualPort module, so that large FIFOs
// may infer block RAM resources instead of consuming LUTs, slices, distributed RAM, etc.
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

module SyncFifo # (parameter DATA_WIDTH = 8, ADDR_WIDTH = 3)
(
    input wire asyncReset,
    input wire clock,
    
    input wire readEnable,
    output reg empty = 1'b1,
    output wire [DATA_WIDTH-1:0] readData,
    
    input wire writeEnable,
    output reg full = 1'b0,
    input wire [DATA_WIDTH-1:0] writeData
);

localparam DATA_BYTES = 1;
localparam DATA_REMAINDER = DATA_WIDTH - (DATA_BYTES * 8);

// Read and write pointers are equal whenever the FIFO is empty or full.
// Observe the 'empty' and 'full' output registers to distinguish.
reg [ADDR_WIDTH-1:0] readPointer = {ADDR_WIDTH{1'b0}};
reg [ADDR_WIDTH-1:0] writePointer = {ADDR_WIDTH{1'b0}};

BlockRamDualPort # (.DATA_BYTES(DATA_BYTES), .PARITY_BITS(DATA_REMAINDER), .ADDR_WIDTH(ADDR_WIDTH)) mem
(
    // Write Port
    .clockA(clock),
    .enableA(1'b1),
    .resetA(1'b0),
    .writeEnableA({DATA_BYTES{writeEnable}}),
    .addressA(writePointer),
    .dataInA(writeData),
    .dataOutA(),
    
    // Read Port
    .clockB(clock),
    .enableB(readEnable),
    .resetB(1'b0),
    .writeEnableB({DATA_BYTES{1'b0}}),
    .addressB(readPointer),
    .dataInB({DATA_WIDTH{1'b0}}),
    .dataOutB(readData)
);


always @ (posedge clock or posedge asyncReset) begin
    if (asyncReset == 1'b1) begin
        full <= 1'b0;
        empty <= 1'b1;
        readPointer <= {ADDR_WIDTH{1'b0}};
        writePointer <= {ADDR_WIDTH{1'b0}};
    end else begin
        if (readEnable && !empty && writeEnable && !full) begin
            // Both read and write in the same clock cycle

            // Increment both pointers
            readPointer <= readPointer + {{(ADDR_WIDTH-1){1'b0}}, 1'b1};
            writePointer <= writePointer + {{(ADDR_WIDTH-1){1'b0}}, 1'b1};
            // Not possible to go full or empty in this circumstance
        end else if (readEnable && !empty) begin
            // Just read
            readPointer <= readPointer + {{(ADDR_WIDTH-1){1'b0}}, 1'b1};
            // No longer full
            full <= 1'b0;
            // Empty if readPointer + 1 == writePointer
            if ((readPointer + {{(ADDR_WIDTH-1){1'b0}}, 1'b1}) == writePointer)
                empty <= 1'b1;
        end else if (writeEnable && !full) begin
            // Just write
            writePointer <= writePointer + {{(ADDR_WIDTH-1){1'b0}}, 1'b1};
            // No longer empty
            empty <= 1'b0;
            // Full if writePointer + 1 == readPointer
            if ((writePointer + {{(ADDR_WIDTH-1){1'b0}}, 1'b1}) == readPointer)
                full <= 1'b1;
        end
    end
end

endmodule
