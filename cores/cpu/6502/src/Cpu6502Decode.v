//
// 6502Decode - ROM-based decoder for 6502-series instruction opcodes
//
//
// Copyright 2018 Reclone Labs <reclonelabs.com>
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

module Cpu6502Decode
(
    input                       clock,
    input                       reset,
    input [7:0]                 opcode,
    input                       loadOpcode,
    
    output reg [7:0]            loadedOpcode
    //output [4:0]                aluOperation
);
/* verilator lint_off UNUSED */
wire [31:0] decodedSignals;
/* verilator lint_on UNUSED */

Cpu6502DecodeRom decodeRom
(
    .clock(clock),
    .enable(loadOpcode),
    .address(opcode),
    .data(decodedSignals)
);

always @ (posedge clock)
begin
    if (reset)
        loadedOpcode <= 8'hEA; //NOP
    else
    begin
        if (loadOpcode)
            loadedOpcode <= opcode;
            
        
    end
end


endmodule
