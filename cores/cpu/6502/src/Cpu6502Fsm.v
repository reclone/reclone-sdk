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

module Cpu6502Fsm
(
    input           clock,
    input           enable,
    input [8:0]     currentState,
    input [7:0]     opcode,
    input           interrupt_N,
    input           nonMaskableInterrupt_N,
    input           reset_N,
    input           negativeFlag,
    input           zeroFlag,
    input           overflowFlag,
    input           carryFlag,
    output [8:0]    nextState
);

// Next State Determination
parameter   NEXT_STATE_DEFAULT = 3'h0,      // Next state is OptionA
            NEXT_STATE_OPCODE = 3'h1,       // Next state is (9'h100 | opcode)
            NEXT_STATE_CARRY = 3'h2,        // Next state is OptionA if carry flag set, otherwise OptionB
            NEXT_STATE_OVERFLOW = 3'h3,     // Next state is OptionA if overflow flag set, otherwise OptionB
            NEXT_STATE_NEGATIVE = 3'h4,     // Next state is OptionA if sign flag set, otherwise OptionB
            NEXT_STATE_ZERO = 3'h5,         // Next state is OptionA if zero flag set, otherwise OptionB
            NEXT_STATE_WRITE_BACK = 3'h6,   // Next state is OptionA if write back is needed, otherwise OptionB
            NEXT_STATE_BRANCH_PAGE = 3'h7;  // Next state is OptionA if page correction is needed, otherwise OptionB

// Opcodes
parameter   BRK = 8'h00, ORA_X_IND = 8'h01, ORA_ZPG = 8'h05, ASL_ZPG = 8'h06, PHP = 8'h08, ORA_IMM = 8'h09,
            ASL_A = 8'h0A, ORA_ABS = 8'h0D, ASL_ABS = 8'h0E, BPL = 8'h10, ORA_IND_Y = 8'h11, ORA_ZPG_X = 8'h15,
            ASL_ZPG_X = 8'h16, CLC = 8'h18, ORA_ABS_Y = 8'h19, ORA_ABS_X = 8'h1D, ASL_ABS_X = 8'h1E, JSR = 8'h20,
            AND_X_IND = 8'h21, BIT_ZPG = 8'h24, AND_ZPG = 8'h25, ROL_ZPG = 8'h26, PLP = 8'h28, AND_IMM = 8'h29,
            ROL_A = 8'h2A, BIT_ABS = 8'h2C, AND_ABS = 8'h2D, ROL_ABS = 8'h2E, BMI = 8'h30, AND_IND_Y = 8'h31,
            AND_ZPG_X = 8'h35, ROL_ZPG_X = 8'h36, SEC = 8'h38, AND_ABS_Y = 8'h39, AND_ABS_X = 8'h3D,
            ROL_ABS_X = 8'h3E, RTI = 8'h40, EOR_X_IND = 8'h41, EOR_ZPG = 8'h45, LSR_ZPG = 8'h46, PHA = 8'h48,
            EOR_IMM = 8'h49, LSR_A = 8'h4A, JMP_ABS = 8'h4C, EOR_ABS = 8'h4D, LSR_ABS = 8'4E, BVC = 8'h50,
            EOR_IND_Y = 8'h51, EOR_ZPG_X = 8'h55, LSR_ZPG_X = 8'h56, CLI = 8'h58, EOR_ABS_Y = 8'h59,
            EOR_ABS_X = 8'h5D, LSR_ABS_X = 8'h5E, RTS = 8'h60, ADC_X_IND = 8'h61, ADC_ZPG = 8'h65,
            ROR_ZPG = 8'h66, PLA = 8'h68, ADC_IMM = 8'h69, ROR_A = 8'h6A, JMP_IND = 8'h6C, ADC_ABS = 8'h6D,
            ROR_ABS = 8'h6E, BVS = 8'h70, ADC_IND_Y = 8'h71, ADC_ZPG_X = 8'h75, ROR_ZPG_X = 8'h76,
            SEI = 8'h78, ADC_ABS_Y = 8'h79, ADC_ABS_X = 8'h7D, ROR_ABS_X = 8'h7E, STA_X_IND = 8'h81,
            STY_ZPG = 8'h84, STA_ZPG = 8'h85, STX_ZPG = 8'h86, DEY = 8'h88, TXA = 8'h8A, STY_ABS = 8'h8C,
            STA_ABS = 8'h8D, STX_ABS = 8'h8E, BCC = 8'h90, STA_IND_Y = 8'h91, STY_ZPG_X = 8'h94, 
            STA_ZPG_X = 8'h95, STX_ZPG_Y = 8'h96, TYA = 8'h98, STA_ABS_Y = 8'h99, TXS = 8'h9A, STA_ABS_X = 8'h9D,
            LDY_IMM = 8'hA0, LDA_X_IND = 8'hA1, LDX_IMM = 8'hA2, LDY_ZPG = 8'hA4, LDA_ZPG = 8'hA5,
            LDX_ZPG = 8'hA6, TAY = 8'hA8, LDA_IMM = 8'hA9, TAX = 8'hAA, LDY_ABS = 8'hAC, LDA_ABS = 8'hAD,
            LDX_ABS = 8'hAE, BCS = 8'hB0, LDA_IND_Y = 8'hB1, LDY_ZPG_X = 8'hB4, LDA_ZPG_X =  8'hB5,
            LDX_ZPG_Y = 8'hB6, CLV = 8'hB8, LDA_ABS_Y = 8'hB9, TSX = 8'hBA, LDY_ABS_X = 8'hBC, LDA_ABS_X = 8'hBD,
            LDX_ABS_Y = 8'hBE, CPY_IMM = 8'hC0, CMP_X_IND = 8'hC1, CPY_ZPG = 8'hC4, CMP_ZPG = 8'hC5,
            DEC_ZPG = 8'hC6, INY = 8'hC8, CMP_IMM = 8'hC9, DEX = 8'hCA, CPY_ABS = 8'hCC, CMP_ABS = 8'hCD,
            DEC_ABS = 8'hCE, BNE = 8'hD0, CMP_IND_Y = 8'hD1, CMP_ZPG_X = 8'hD5, DEC_ZPG_X = 8'hD6, CLD = 8'hD8,
            CMP_ABS_Y = 8'hD9, CMP_ABS_X = 8'hDD, DEC_ABS_X = 8'hDE, CPX_IMM = 8'hE0, SBC_X_IND = 8'hE1,
            CPX_ZPG = 8'hE4, SBC_ZPG = 8'hE5, INC_ZPG = 8'hE6, INX = 8'hE8, SBC_IMM = 8'hE9, NOP = 8'hEA,
            CPX_ABS = 8'hEC, SBC_ABS = 8'hED, INC_ABS = 8'hEE, BEQ = 8'hF0, SBC_IND_Y = 8'hF1, SBC_ZPG_X = 8'hF5,
            INC_ZPG_X = 8'hF6, SED = 8'hF8, SBC_ABS_Y = 8'hF9, SBC_ABS_X = 8'hFD, INC_ABS_X = 8'hFE;
            
parameter   DECODE = 9'h000,
            LDA_IMM = 9'1A9;

reg [63:0] stateData;
wire [7:0] nextStateOptionA = stateData[7:0];
wire [7:0] nextStateOptionB = stateData[15:8];
wire [2:0] nextStateDetermination = stateData[18:16];
wire [2:0] aluOperandA = stateData[21:19];
wire [2:0] aluOperandB = stateData[24:22];
wire [2:0] aluOperation = stateData[27:25];

always @ (posedge clock)
begin
    case (currentState)
        DECODE: stateData <= NEXT_STATE_OPCODE;
        LDA_IMM: stateData <= ;
        default: stateData <= 9'h000;
    endcase
end

endmodule




