//
// TextScreenRam - Storage of code point and attribute data used to render a text screen
//
// This module is a RAM block designed to store data for an 80x25 character screen, each cell
// having a code point byte and an attribute byte, for a total of 2000 16-bit words or
// 4000 bytes.  This size is rounded up to the nearest power of 2 - 2048 words, 4096 bytes.
//
// The optional parameter MEM_INIT_FILE can be used to specify a text file containing hex codes
// to initialize the RAM.  If MEM_INIT_FILE is left as an empty string (""), the RAM will be
// initialized with all zero bytes.  It is a dual-port RAM - a read-only port is used by the text
// renderer, while a second read/write port allows the text screen to be changed by software.
//
// To help ensure that synthesis tools will infer block RAM resources for this RAM, this module
// wraps the more generic BlockRamDualPort module.
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

module TextScreenRam #(parameter MEM_INIT_FILE = "", MEM_INIT_VAL = 16'h0000)
(
    // Read-only Port A
    input wire clockA,
    input wire enableA,
    input wire [ADDR_WIDTH-1:0] addressA,
    output wire [DATA_WIDTH-1:0] dataOutA,
    
    // Read/Write Port B
    input wire clockB,
    input wire enableB,
    input wire writeEnableB,
    input wire [ADDR_WIDTH-1:0] addressB,
    input wire [DATA_WIDTH-1:0] dataInB,
    output wire [DATA_WIDTH-1:0] dataOutB
);

localparam DATA_WIDTH = 16;
localparam ADDR_WIDTH = 11;

BlockRamDualPort #(.HEX_MEM_INIT_FILE(MEM_INIT_FILE),
                   .MEM_INIT_VAL(MEM_INIT_VAL),
                   .DATA_WIDTH(DATA_WIDTH),
                   .ADDR_WIDTH(ADDR_WIDTH)) textScreenRam
(
    .clockA(clockA),
    .enableA(enableA),
    .writeEnableA(1'b0),
    .addressA(addressA),
    .dataInA({DATA_WIDTH{1'b0}}),
    .dataOutA(dataOutA),
    
    .clockB(clockB),
    .enableB(enableB),
    .writeEnableB(writeEnableB),
    .addressB(addressB),
    .dataInB(dataInB),
    .dataOutB(dataOutB)
);

endmodule
