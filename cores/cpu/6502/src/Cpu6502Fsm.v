//
// Cpu6502Fsm - Finite state machine to direct operations in the 6502 processor core
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

`include "Cpu6502Opcodes.vh"
`include "Cpu6502StateConstants.vh"

module Cpu6502Fsm
(
    input           interrupt,
    input           nonMaskableInterrupt,
    input           reset,
    input           negativeFlag,
    input           zeroFlag,
    input           overflowFlag,
    input           carryFlag,
    input           fixPage,

    output [8:0]    nextState,
    input [63:0]    stateRomData,

    input [7:0]     opcode,
    input [31:0]    opcodeRomData,
);

wire [7:0] nextStateOptionA = stateData[7:0];
wire [7:0] nextStateOptionB = stateData[15:8];
wire [2:0] nextStateDetermination = stateData[18:16];
wire [2:0] aluOperandA = stateData[21:19];
wire [2:0] aluOperandB = stateData[24:22];
wire [2:0] aluOperation = stateData[27:25];
wire writeBack;

always @*
    case (nextStateDetermination)
        `NEXT_STATE_DEFAULT:
            nextState = {0, nextStateOptionA};
        `NEXT_STATE_OPCODE:
            nextState = {1, opcode};
        `NEXT_STATE_CARRY:
            nextState = carryFlag ? {0, nextStateOptionA} : {0, nextStateOptionB};
        `NEXT_STATE_OVERFLOW:
            nextState = overflowFlag ? {0, nextStateOptionA} : {0, nextStateOptionB};
        `NEXT_STATE_NEGATIVE:
            nextState = negativeFlag ? {0, nextStateOptionA} : {0, nextStateOptionB};
        `NEXT_STATE_ZERO:
            nextState = zeroFlag ? {0, nextStateOptionA} : {0, nextStateOptionB};
        `NEXT_STATE_WRITE_BACK:
            nextState = writeBack ? {0, nextStateOptionA} : {0, nextStateOptionB};
        `NEXT_STATE_FIX_PAGE:
            nextState = fixPage ? {0, nextStateOptionA} : {0, nextStateOptionB};
    endcase

endmodule




