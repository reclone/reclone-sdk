//
// BlockRamDualPort - Block RAM module with dual read/write ports
//
// This module represents a dual-port block RAM resource inside the FPGA of parameterized size.
// To help ensure that synthesis tools will infer block RAM resources for this RAM, this module
// roughly follows Xilinx UG627 "Dual-Port Block RAM With Two Write Ports Verilog Coding Example".
//
// The optional parameters BIN_MEM_INIT_FILE or HEX_MEM_INIT_FILE can be used to specify a
// text file containing '1'/'0' or hex digits, respectively, to initialize the RAM.
// If BIN_MEM_INIT_FILE and HEX_MEM_INIT_FILE are both left as empty strings (""), the RAM will be
// initialized with bytes of value MEM_INIT_VAL (default: 8'h00 bytes).
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

module BlockRamDualPort # ( parameter DATA_WIDTH = 16,
                                      ADDR_WIDTH = 10,
                                      BIN_MEM_INIT_FILE = "",
                                      HEX_MEM_INIT_FILE = "",
                                      MEM_INIT_VAL = {DATA_WIDTH{1'b0}})
(
    // Read/Write Port A
    input wire clockA,
    input wire enableA,
    input wire writeEnableA,
    input wire [ADDR_WIDTH-1:0] addressA,
    input wire [DATA_WIDTH-1:0] dataInA,
    output reg [DATA_WIDTH-1:0] dataOutA,
    
    // Read/Write Port B
    input wire clockB,
    input wire enableB,
    input wire writeEnableB,
    input wire [ADDR_WIDTH-1:0] addressB,
    input wire [DATA_WIDTH-1:0] dataInB,
    output reg [DATA_WIDTH-1:0] dataOutB
);

localparam RAM_SIZE = 1 << ADDR_WIDTH;

reg [DATA_WIDTH-1:0] ram [0:RAM_SIZE-1];

integer j;
initial begin
    if (BIN_MEM_INIT_FILE != "") begin
        $readmemb(BIN_MEM_INIT_FILE, ram);
    end else if (HEX_MEM_INIT_FILE != "") begin
        $readmemh(HEX_MEM_INIT_FILE, ram);
    end else begin
        for (j = 0; j < RAM_SIZE; j = j + 1)
            ram[j] = MEM_INIT_VAL;
    end
end

always @(posedge clockA) begin
    if (enableA) begin
        if (writeEnableA)
            ram[addressA] <= dataInA;
        dataOutA <= ram[addressA];
    end
end

always @(posedge clockB) begin
    if (enableB) begin
        if (writeEnableB)
            ram[addressB] <= dataInB;
        dataOutB <= ram[addressB];
    end
end


endmodule
