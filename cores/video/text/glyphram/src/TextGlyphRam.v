//
// TextGlyphRam - Storage of font bitmap data used to render a character set
//
// This module is a RAM block designed to store 8x16 glyphs for 256 code points, for a total of
// 4096 bytes of storage.  It is a dual-port RAM - a read-only port is used by the text renderer,
// while a second read/write port allows the character set to be changed by software.
//
// The optional parameter MEM_INIT_FILE can be used to specify a text file containing 1s and 0s
// to initialize the RAM.  If MEM_INIT_FILE is left as an empty string (""), the RAM will be
// initialized with all zero bytes.
//
// To help ensure that synthesis tools will infer block RAM resources for this RAM, this module
// roughly follows Xilinx UG627 "Dual-Port Block RAM With Two Write Ports Verilog Coding Example".
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

module TextGlyphRam #(parameter MEM_INIT_FILE = "", MEM_INIT_VAL = 8'h00)
(
    // Read-only Port A
    input wire clockA,
    input wire enableA,
    input wire [ADDR_WIDTH-1:0] addressA,
    output reg [DATA_WIDTH-1:0] dataOutA,
    
    // Read/Write Port B
    input wire clockB,
    input wire enableB,
    input wire writeEnableB,
    input wire [ADDR_WIDTH-1:0] addressB,
    input wire [DATA_WIDTH-1:0] dataInB,
    output reg [DATA_WIDTH-1:0] dataOutB
);

localparam DATA_WIDTH = 8;
localparam ADDR_WIDTH = 12;
localparam RAM_SIZE = 1 << ADDR_WIDTH;

reg [DATA_WIDTH-1:0] ram [0:RAM_SIZE-1];

initial begin
    if (MEM_INIT_FILE == "") begin
        integer j;
        for(j = 0; j < RAM_SIZE; j = j + 1)
            ram[j] = MEM_INIT_VAL;
    end else begin
        $readmemb(MEM_INIT_FILE, ram);
    end
end

always @(posedge clockA) begin
    if (enableA) begin
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
