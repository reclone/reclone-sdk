//
// BlockRamDualPort8and16 - Block RAM module with 8-bit-wide and 16-bit-wide read/write ports
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
//  - Asymmetric port aspect ratios - port A has data width of 8 bits; port B has data width of 16 bits
//  - Byte-wide write enable - individually enable writing to each byte column in RAM
//  - Resettable data outputs - synchronous reset of each data output register to a constant value
//  - Optional parity bits - adds an additional bit to each byte column to form 9-bit columns
//
// Per UG687: "The depth and width characteristics of the modeling signal or shared variable match
// the RAM port with the lower data width (subsequently the larger depth).  As a result of this
// modeling requirement, describing a read or write access for the port with the larger data width
// no longer implies one assignment, but several assignments.  The number of assignments equals the
// ratio between the two asymmetric data widths."
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

module BlockRamDualPort8and16 # ( parameter ADDR_WIDTH_A = 10,
                                            BIN_MEM_INIT_FILE = "",
                                            HEX_MEM_INIT_FILE = "",
                                            RAW_MEM_INIT_FILE = "",
                                            MEM_INIT_VAL_A = {DATA_WIDTH_A{1'b0}},
                                            DATA_OUT_RESET_VAL_A = MEM_INIT_VAL_A,
                                            DATA_OUT_RESET_VAL_B = {DATA_BYTES_B{MEM_INIT_VAL_A}})
(
    // Read/Write Port A
    input wire clockA,
    input wire enableA,
    input wire resetA,
    input wire writeEnableA,
    input wire [ADDR_WIDTH_A-1:0] addressA,
    input wire [DATA_WIDTH_A-1:0] dataInA,
    output reg [DATA_WIDTH_A-1:0] dataOutA,
    
    // Read/Write Port B
    input wire clockB,
    input wire enableB,
    input wire resetB,
    input wire [DATA_BYTES_B-1:0] writeEnableB,
    input wire [ADDR_WIDTH_A-2:0] addressB,
    input wire [DATA_WIDTH_B-1:0] dataInB,
    output reg [DATA_WIDTH_B-1:0] dataOutB
);

localparam DATA_BYTES_A = 1;
localparam DATA_BYTES_B = 2;
localparam COLUMN_WIDTH = 8;
localparam DATA_WIDTH_A = DATA_BYTES_A * COLUMN_WIDTH;
localparam DATA_WIDTH_B = DATA_BYTES_B * COLUMN_WIDTH;
localparam RAM_SIZE = 1 << ADDR_WIDTH_A;

/* verilator lint_off MULTIDRIVEN */
reg [DATA_WIDTH_A-1:0] ram [0:RAM_SIZE-1];
/* verilator lint_on MULTIDRIVEN */

integer j;
integer fd;
initial begin
    for (j = 0; j < RAM_SIZE; j = j + 1)
        ram[j] = MEM_INIT_VAL_A;
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
            dataOutA <= DATA_OUT_RESET_VAL_A;
        end else begin
            dataOutA <= ram[addressA];
        end
        
        if (writeEnableA) begin
            ram[addressA] <= dataInA;
        end
    end
end

always @(posedge clockB) begin
    if (enableB) begin
        if (resetB) begin
            dataOutB <= DATA_OUT_RESET_VAL_B;
        end else begin
            dataOutB <= {ram[{addressB, 1'b1}], ram[{addressB, 1'b0}]};
        end
        
        if (writeEnableB[1]) begin
            ram[{addressB, 1'b1}] <= dataInB[DATA_WIDTH_B-1:COLUMN_WIDTH];
        end
        if (writeEnableB[0]) begin
            ram[{addressB, 1'b0}] <= dataInB[COLUMN_WIDTH-1:0];
        end
    end
end

endmodule
