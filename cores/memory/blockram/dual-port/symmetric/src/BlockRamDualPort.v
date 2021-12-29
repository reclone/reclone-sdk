//
// BlockRamDualPort - Block RAM module with byte lanes and dual symmetric read/write ports
//
// This module represents a dual-port block RAM resource inside the FPGA of parameterized size.
// To help ensure that synthesis tools will infer block RAM resources for this RAM, this module
// roughly follows coding examples in Xilinx UG687, section "RAM HDL Coding Guidelines".
//
// The block RAM to be inferred has the following features:
//  - Flexible RAM initialization source based on parameters
//      o MEM_INIT_VAL: the RAM will be filled with this init value
//      o BIN_MEM_INIT_FILE: text file containing '1'/'0' characters
//      o HEX_MEM_INIT_FILE: text file containing [0-9|A-F] characters
//      o RAW_MEM_INIT_FILE: binary file containing the raw bytes used for init
//  - Read-first read/write synchronization - old content is read before new content is loaded
//  - Symmetric port aspect ratios - the two read/write ports have the same data widths
//  - Byte-wide write enable - individually enable writing to each byte column in RAM
//  - Resettable data outputs - synchronous reset of each data output register to a constant value
//  - Optional parity bits - adds an additional bit to each byte column to form 9-bit columns
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

module BlockRamDualPort # ( parameter DATA_BYTES = 2,
                                      PARITY_BITS = 0,
                                      ADDR_WIDTH = 10,
                                      BIN_MEM_INIT_FILE = "",
                                      HEX_MEM_INIT_FILE = "",
                                      RAW_MEM_INIT_FILE = "",
                                      MEM_INIT_VAL = {DATA_WIDTH{1'b0}},
                                      DATA_OUT_RESET_VAL = MEM_INIT_VAL )
(
    // Read/Write Port A
    input wire clockA,
    input wire enableA,
    input wire resetA,
    input wire [DATA_BYTES-1:0] writeEnableA,
    input wire [ADDR_WIDTH-1:0] addressA,
    input wire [DATA_WIDTH-1:0] dataInA,
    output reg [DATA_WIDTH-1:0] dataOutA,
    
    // Read/Write Port B
    input wire clockB,
    input wire enableB,
    input wire resetB,
    input wire [DATA_BYTES-1:0] writeEnableB,
    input wire [ADDR_WIDTH-1:0] addressB,
    input wire [DATA_WIDTH-1:0] dataInB,
    output reg [DATA_WIDTH-1:0] dataOutB
);

localparam COLUMN_WIDTH = 8 + PARITY_BITS;
localparam DATA_WIDTH = DATA_BYTES * COLUMN_WIDTH;
localparam RAM_SIZE = 1 << ADDR_WIDTH;

/* verilator lint_off MULTIDRIVEN */
reg [DATA_WIDTH-1:0] ram [0:RAM_SIZE-1];
/* verilator lint_on MULTIDRIVEN */

integer j;
integer fd;
initial begin
    for (j = 0; j < RAM_SIZE; j = j + 1)
        ram[j] = MEM_INIT_VAL;
    if (BIN_MEM_INIT_FILE != "") begin
        $readmemb(BIN_MEM_INIT_FILE, ram);
    end else if (HEX_MEM_INIT_FILE != "") begin
        $readmemh(HEX_MEM_INIT_FILE, ram);
    end else if (RAW_MEM_INIT_FILE != "") begin
        fd = $fopen(RAW_MEM_INIT_FILE, "rb");
        $fread(ram,fd);
        $fclose(fd);
    end
end

always @(posedge clockA) begin
    if (enableA) begin
        if (resetA) begin
            dataOutA <= DATA_OUT_RESET_VAL;
        end else begin
            dataOutA <= ram[addressA];
        end
    end
end

always @(posedge clockB) begin
    if (enableB) begin
        if (resetB) begin
            dataOutB <= DATA_OUT_RESET_VAL;
        end else begin
            dataOutB <= ram[addressB];
        end
    end
end

generate
    genvar i;
    for (i = 0; i < DATA_BYTES; i = i + 1) begin
        always @(posedge clockA) begin
            if (enableA) begin
                if (writeEnableA[i]) begin
                    ram[addressA][(i+1)*COLUMN_WIDTH-1:i*COLUMN_WIDTH] <= dataInA[(i+1)*COLUMN_WIDTH-1:i*COLUMN_WIDTH];
                end
            end
        end
        always @(posedge clockB) begin
            if (enableB) begin
                if (writeEnableB[i]) begin
                    ram[addressB][(i+1)*COLUMN_WIDTH-1:i*COLUMN_WIDTH] <= dataInB[(i+1)*COLUMN_WIDTH-1:i*COLUMN_WIDTH];
                end
            end
        end
    end
endgenerate

endmodule
