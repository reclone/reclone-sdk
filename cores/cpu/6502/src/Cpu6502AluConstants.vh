//
// Cpu6502AluConstants - Definitions of constants used by the 6502 arithmetic logic unit
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

`ifndef __CPU6502ALUCONSTANTS_VH_
`define __CPU6502ALUCONSTANTS_VH_

// ALU Operand Sources
`define ALU_OPERAND_ZERO    4'h0
`define ALU_OPERAND_ONE     4'h1
`define ALU_OPERAND_DI      4'h2
`define ALU_OPERAND_P       4'h3
`define ALU_OPERAND_A       4'h4
`define ALU_OPERAND_X       4'h5
`define ALU_OPERAND_Y       4'h6
`define ALU_OPERAND_S       4'h7
`define ALU_OPERAND_PCL     4'h8
`define ALU_OPERAND_PCH     4'h9
`define ALU_OPERAND_INDL    4'hA
`define ALU_OPERAND_INDH    4'hB

// ALU Operations
`define ALU_OPERATION_COPY  3'h0
`define ALU_OPERATION_AND   3'h1
`define ALU_OPERATION_OR    3'h2
`define ALU_OPERATION_EOR   3'h3
`define ALU_OPERATION_ADC   3'h4
`define ALU_OPERATION_SBC   3'h5
`define ALU_OPERATION_ROR   3'h6



`endif //__CPU6502ALUCONSTANTS_VH_
