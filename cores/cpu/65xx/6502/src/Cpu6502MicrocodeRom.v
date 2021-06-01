//
// 6502MicrocodeRom - ROM containing microinstructions for each cycle of the 6502 opcodes.
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

`include "Cpu6502Opcodes.vh"
`include "Cpu65xxMicrocodeConstants.vh"

module Cpu6502MicrocodeRom
(
    input               clock,
    input               enable,
    input [9:0]         address,
    output wire [1:0]   addrBusMux,
    output wire         dataBusWriteEnable,
    output wire [1:0]   dataBusMux,
    output wire [3:0]   aluOperation,
    output wire [3:0]   aluOperandA,
    output wire [2:0]   aluOperandB,
    output wire [3:0]   aluResultStorage,
    output wire         incrementAddr,
    output wire         uSeqBranchCondition,
    output wire [9:0]   uSeqBranchAddr
);

reg [31:0] d = 32'h00000000;

assign addrBusMux = d[31:30];
assign dataBusWriteEnable = d[29];
assign dataBusMux = d[28:27];
assign aluOperation = d[26:23];
assign aluOperandA = d[22:19];
assign aluOperandB = d[18:16];
assign aluResultStorage = d[15:12];
assign incrementAddr = d[11];
assign uSeqBranchCondition = d[10];
assign uSeqBranchAddr = d[9:0];

// Microsequencer branch addresses
localparam USEQ_ADDR_FETCH  = USEQ_ADDR_NMI + 10'd7;
localparam USEQ_ADDR_WASTE1  = USEQ_ADDR_NMI + 10'd6;
localparam USEQ_ADDR_LDA_ABS = {UPAGE_OP, LDA_IMM, 1'b1};
localparam USEQ_ADDR_HALT   = 10'h2FF;
localparam USEQ_ADDR_NONE   = USEQ_ADDR_HALT;
localparam USEQ_ADDR_LDA_ZPG_X = USEQ_ADDR_NMI + 10'd8;
localparam USEQ_ADDR_LDX_ZPG_Y = USEQ_ADDR_LDA_ZPG_X + 10'd2;
localparam USEQ_ADDR_LDY_ZPG_X = USEQ_ADDR_LDX_ZPG_Y + 10'd2;
localparam USEQ_ADDR_LDA_ABS_XY = USEQ_ADDR_LDY_ZPG_X + 10'd2;
localparam USEQ_ADDR_LDA_IMM_INDL = {UPAGE_OP, LDX_ZPG_Y, 1'b1};
localparam USEQ_ADDR_LDA_IMM_FETCH = {UPAGE_OP, LDA_ZPG_X, 1'b1};
localparam USEQ_ADDR_LDA_X_IND = USEQ_ADDR_LDA_ABS_XY + 10'd3;
localparam USEQ_ADDR_LDA_IND_Y = USEQ_ADDR_LDA_X_IND + 10'd3;
localparam USEQ_ADDR_BR_REL = USEQ_ADDR_LDA_IND_Y + 10'd4;
localparam USEQ_ADDR_JSR = USEQ_ADDR_BR_REL + 10'd2;
localparam USEQ_ADDR_RTS = USEQ_ADDR_JSR + 10'd3;
localparam USEQ_ADDR_RTI = USEQ_ADDR_RTS + 10'd3;
localparam USEQ_ADDR_PLA = USEQ_ADDR_RTI + 10'd3;
localparam USEQ_ADDR_PLP = USEQ_ADDR_PLA + 10'd1;
localparam USEQ_ADDR_STA_ABS = USEQ_ADDR_PLP + 10'd1;
localparam USEQ_ADDR_CMP_IND = USEQ_ADDR_STA_ABS + 10'd1;
localparam USEQ_ADDR_JMP_IND = USEQ_ADDR_CMP_IND + 10'd1;
localparam USEQ_ADDR_STA_ABS_Y = USEQ_ADDR_JMP_IND + 10'd2;
localparam USEQ_ADDR_CMP_ABS_XY = USEQ_ADDR_STA_ABS_Y + 10'd4;
localparam USEQ_ADDR_LDX_ABS_Y = USEQ_ADDR_CMP_ABS_XY + 10'd2;
localparam USEQ_ADDR_LDX_IMM_INDL = USEQ_ADDR_LDX_ABS_Y + 10'd3;
localparam USEQ_ADDR_LDX_IMM_FETCH = USEQ_ADDR_LDX_IMM_INDL + 10'd1;
localparam USEQ_ADDR_STX_ZPG_Y = USEQ_ADDR_LDX_IMM_FETCH + 10'd1;
localparam USEQ_ADDR_STY_ZPG_X = USEQ_ADDR_STX_ZPG_Y + 10'd2;
localparam USEQ_ADDR_STA_ZPG_X = USEQ_ADDR_STY_ZPG_X + 10'd2;
localparam USEQ_ADDR_STA_ABS_XY = USEQ_ADDR_STA_ZPG_X + 10'd2;
localparam USEQ_ADDR_LDY_ABS_X = USEQ_ADDR_STA_ABS_XY + 10'd4;
localparam USEQ_ADDR_CMP_ZPG_X = USEQ_ADDR_LDY_ABS_X + 10'd3;
localparam USEQ_ADDR_CMP_ZPG = USEQ_ADDR_CMP_ZPG_X + 10'd1;
localparam USEQ_ADDR_STX_ABS = USEQ_ADDR_CMP_ZPG + 10'd1;
localparam USEQ_ADDR_STY_ABS = USEQ_ADDR_STX_ABS + 10'd1;
localparam USEQ_ADDR_LDX_ABS = USEQ_ADDR_STY_ABS + 10'd1;
localparam USEQ_ADDR_LDY_ABS = USEQ_ADDR_LDX_ABS + 10'd1;
localparam USEQ_ADDR_CPX_IND = USEQ_ADDR_LDY_ABS + 10'd1;
localparam USEQ_ADDR_CPY_IND = USEQ_ADDR_CPX_IND + 10'd1;
localparam USEQ_ADDR_STA_IND_Y = USEQ_ADDR_CPY_IND + 10'd1;
localparam USEQ_ADDR_CMP_IND_Y = USEQ_ADDR_STA_IND_Y + 10'd5;
localparam USEQ_ADDR_STA_X_IND = USEQ_ADDR_CMP_IND_Y + 10'd4;
localparam USEQ_ADDR_BIT_ABS = USEQ_ADDR_STA_X_IND + 10'd3;
localparam USEQ_ADDR_CMP_X_IND = USEQ_ADDR_BIT_ABS + 10'd1;
localparam USEQ_ADDR_ASL_ZPG = USEQ_ADDR_CMP_X_IND + 10'd3;
localparam USEQ_ADDR_LSR_ZPG = USEQ_ADDR_ASL_ZPG + 10'd2;
localparam USEQ_ADDR_ROL_ZPG = USEQ_ADDR_LSR_ZPG + 10'd2;
localparam USEQ_ADDR_ROR_ZPG = USEQ_ADDR_ROL_ZPG + 10'd2;
localparam USEQ_ADDR_ASL_ABS = USEQ_ADDR_ROR_ZPG + 10'd2;
localparam USEQ_ADDR_LSR_ABS = USEQ_ADDR_ASL_ABS + 10'd3;
localparam USEQ_ADDR_ROL_ABS = USEQ_ADDR_LSR_ABS + 10'd3;
localparam USEQ_ADDR_ROR_ABS = USEQ_ADDR_ROL_ABS + 10'd3;
localparam USEQ_ADDR_ASL_ZPG_X = USEQ_ADDR_ROR_ABS + 10'd3;
localparam USEQ_ADDR_LSR_ZPG_X = USEQ_ADDR_ASL_ZPG_X + 10'd3;
localparam USEQ_ADDR_ROL_ZPG_X = USEQ_ADDR_LSR_ZPG_X + 10'd3;
localparam USEQ_ADDR_ROR_ZPG_X = USEQ_ADDR_ROL_ZPG_X + 10'd3;
localparam USEQ_ADDR_ASL_ABS_X = USEQ_ADDR_ROR_ZPG_X + 10'd3;
localparam USEQ_ADDR_LSR_ABS_X = USEQ_ADDR_ASL_ABS_X + 10'd6;
localparam USEQ_ADDR_ROL_ABS_X = USEQ_ADDR_LSR_ABS_X + 10'd6;
localparam USEQ_ADDR_ROR_ABS_X = USEQ_ADDR_ROL_ABS_X + 10'd6;
localparam USEQ_ADDR_DEC_ZPG = USEQ_ADDR_ROR_ABS_X + 10'd6;
localparam USEQ_ADDR_INC_ZPG = USEQ_ADDR_DEC_ZPG + 10'd2;
localparam USEQ_ADDR_DEC_ZPG_X = USEQ_ADDR_INC_ZPG + 10'd2;
localparam USEQ_ADDR_INC_ZPG_X = USEQ_ADDR_DEC_ZPG_X + 10'd3;
localparam USEQ_ADDR_DEC_ABS = USEQ_ADDR_INC_ZPG_X + 10'd3;
localparam USEQ_ADDR_INC_ABS = USEQ_ADDR_DEC_ABS + 10'd3;
localparam USEQ_ADDR_DEC_ABS_X = USEQ_ADDR_INC_ABS + 10'd3;
localparam USEQ_ADDR_INC_ABS_X = USEQ_ADDR_DEC_ABS_X + 10'd6;
localparam USEQ_ADDR_AND_IND = {UPAGE_OP, AND_ZPG_X, 1'b1};
localparam USEQ_ADDR_AND_ZPG_X = USEQ_ADDR_INC_ABS_X + 10'd6;
localparam USEQ_ADDR_AND_ABS_XY = USEQ_ADDR_AND_ZPG_X + 10'd2;
localparam USEQ_ADDR_AND_X_IND = USEQ_ADDR_AND_ABS_XY + 10'd2;
localparam USEQ_ADDR_AND_IND_Y = USEQ_ADDR_AND_X_IND + 10'd2;
localparam USEQ_ADDR_EOR_IND = {UPAGE_OP, EOR_ZPG_X, 1'b1};
localparam USEQ_ADDR_EOR_ZPG_X = USEQ_ADDR_AND_IND_Y + 10'd3;
localparam USEQ_ADDR_EOR_ABS_XY = USEQ_ADDR_EOR_ZPG_X + 10'd2;
localparam USEQ_ADDR_EOR_X_IND = USEQ_ADDR_EOR_ABS_XY + 10'd2;
localparam USEQ_ADDR_EOR_IND_Y = USEQ_ADDR_EOR_X_IND + 10'd2;
localparam USEQ_ADDR_ORA_IND = {UPAGE_OP, ORA_ZPG_X, 1'b1};
localparam USEQ_ADDR_ORA_ZPG_X = USEQ_ADDR_EOR_IND_Y + 10'd3;
localparam USEQ_ADDR_ORA_ABS_XY = USEQ_ADDR_ORA_ZPG_X + 10'd2;
localparam USEQ_ADDR_ORA_X_IND = USEQ_ADDR_ORA_ABS_XY + 10'd2;
localparam USEQ_ADDR_ORA_IND_Y = USEQ_ADDR_ORA_X_IND + 10'd2;
localparam USEQ_ADDR_ADC_IND = {UPAGE_OP, ADC_ZPG_X, 1'b1};
localparam USEQ_ADDR_ADC_ZPG_X = USEQ_ADDR_ORA_IND_Y + 10'd3;
localparam USEQ_ADDR_ADC_ABS_XY = USEQ_ADDR_ADC_ZPG_X + 10'd2;
localparam USEQ_ADDR_ADC_X_IND = USEQ_ADDR_ADC_ABS_XY + 10'd2;
localparam USEQ_ADDR_ADC_IND_Y = USEQ_ADDR_ADC_X_IND + 10'd2;
localparam USEQ_ADDR_SBC_IND = {UPAGE_OP, SBC_ZPG_X, 1'b1};
localparam USEQ_ADDR_SBC_ZPG_X = USEQ_ADDR_ADC_IND_Y + 10'd3;
localparam USEQ_ADDR_SBC_ABS_XY = USEQ_ADDR_SBC_ZPG_X + 10'd2;
localparam USEQ_ADDR_SBC_X_IND = USEQ_ADDR_SBC_ABS_XY + 10'd2;
localparam USEQ_ADDR_SBC_IND_Y = USEQ_ADDR_SBC_X_IND + 10'd2;

// Microcode ROM is updated on the negative edge of the clock, so that
// if the ALU and data bus operate on the positive edge of the clock, then
// an opcode can effectively be fetched and decoded in the same cycle.
always @ (negedge clock)
begin
    if (enable)
    begin
        case (address)
        
            /* RESET - Read PC for 3 cycles, read/dec SP for 3 cycles, Load PC with vector at $FFFC, set B, and set I */
            USEQ_ADDR_RESET:
                // (PC), Z <= 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SETBIT, ALU_A_P, Z_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd1};
            USEQ_ADDR_RESET + 10'd1:
                // (PC), INDL <= $FC
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_DEC, ALU_A_FD, ALU_B_ZERO, ALU_O_INDL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd2};
            USEQ_ADDR_RESET + 10'd2:
                // (PC), INDH <= $FF
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_FF, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd3};
            USEQ_ADDR_RESET + 10'd3:
                // ($0100,S), S <= S - 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd4};
            USEQ_ADDR_RESET + 10'd4:
                // ($0100,S), S <= S - 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd5};
            USEQ_ADDR_RESET + 10'd5:
                // ($0100,S), S <= S - 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd6};
            USEQ_ADDR_RESET + 10'd6:
                // PCL <= (IND), IND <= IND + 1, I <= 1
                d <= {ADDR_IND, DATA_READ, DATA_PCL, ALU_OP_SETBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd7};
            USEQ_ADDR_RESET + 10'd7:
                // PCH <= (IND), B <= 1
                d <= {ADDR_IND, DATA_READ, DATA_PCH, ALU_OP_SETBIT, ALU_A_P, B_BIT_IN_P, ALU_O_P, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            /* IRQ - push PC and P onto stack, then fetch IRQ vector at ($FFFE) into PC and set I */
            USEQ_ADDR_IRQ:
                // ($0100,S) <= PCH, INDH <= $FF, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCH, ALU_OP_COPY, ALU_A_FF, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd1};
            USEQ_ADDR_IRQ + 10'd1:
                // ($0100,S) <= PCL, INDL <= $FE, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCL, ALU_OP_DEC, ALU_A_FF, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd2};
            USEQ_ADDR_IRQ + 10'd2:
                // ($0100,S) <= P, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_P, ALU_B_ZERO, ALU_O_DO, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd3};
            USEQ_ADDR_IRQ + 10'd3:
                // PCL <= (IND), IND <= IND + 1
                d <= {ADDR_IND, DATA_READ, DATA_PCL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd4};
            USEQ_ADDR_IRQ + 10'd4:
                // PCH <= (IND), I <= 1
                d <= {ADDR_IND, DATA_READ, DATA_PCH, ALU_OP_SETBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            /* NMI - push PC and P onto stack, then fetch NMI vector at ($FFFA) into PC */
            USEQ_ADDR_NMI:
                // ($0100,S) <= PCH, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCH, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd1};
            USEQ_ADDR_NMI + 10'd1:
                // ($0100,S) <= PCL, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCL, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd2};
            USEQ_ADDR_NMI + 10'd2:
                // IMM <= P
                d <= {ADDR_SP, DATA_READ, DATA_IMM, ALU_OP_OR, ALU_A_P, ALU_B_ZERO, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd3};
            USEQ_ADDR_NMI + 10'd3:
                // ($0100,S) <= IMM, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_IMM, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd4};
            USEQ_ADDR_NMI + 10'd4:
                // PCH <= ($FFFB), INDL <= $FA
                d <= {ADDR_IND, DATA_READ, DATA_PCH, ALU_OP_OR, ALU_A_FB, ALU_B_FF, ALU_O_ADDR, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd5};
            USEQ_ADDR_NMI + 10'd5:
                // PCL <= ($FFFA)
                d <= {ADDR_IND, DATA_READ, DATA_PCL, ALU_OP_IADD, ALU_A_FB, ALU_B_FF, ALU_O_ADDR, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            /* WASTE1 - Waste one cycle doing nothing, then fetch */
            USEQ_ADDR_WASTE1:
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            /* FETCH - Load OP with byte at (PC), increment PC, then decode opcode next - no ALU operation */
            USEQ_ADDR_FETCH:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            /* HALT - Lock up the microsequencer until reset */
            USEQ_ADDR_HALT:
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_HALT};

            {UPAGE_OP, BRK, 1'b0}:
                // B <= 1, PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SETBIT, ALU_A_P, B_BIT_IN_P, ALU_O_P, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ};

            {UPAGE_OP, BCC, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if carry flag is clear
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_C, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BCC, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, BCS, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if carry flag is set
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_C, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BCS, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, BNE, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if zero flag is clear
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_Z, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BNE, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, BEQ, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if zero flag is set
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_Z, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BEQ, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, BPL, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if negative flag is clear
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_N, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BPL, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, BMI, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if negative flag is set
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_N, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BMI, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, BVC, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if overflow flag is clear
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_V, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BVC, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, BVS, 1'b0}:
                // IMM <= (PC), PC <= PC + 1, branch if overflow flag is set
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_SGL, ALU_A_P, ALU_SOP_TEST_V, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_BR_REL};
            {UPAGE_OP, BVS, 1'b1}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            USEQ_ADDR_BR_REL:
                // OP <= PC (dummy), PCL <= PCL + IMM, if no carry skip PCH fixup and goto fetch
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_RADD, ALU_A_PCL, ALU_B_IMM, ALU_O_PCL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};
            USEQ_ADDR_BR_REL + 10'd1:
                // Fix PCH:
                //  If IMM[7] == 1: PCH <= PCH - 1
                //  If IMM[7] == 0: PCH <= PCH + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_FIXUP, ALU_A_PCH, ALU_B_IMM, ALU_O_PCH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* SET/CLEAR FLAGS - CLC, CLD, CLI, CLV, SEC, SED, SEI */

            {UPAGE_OP, CLC, 1'b0}:
                // P[0] <= 0
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_CLRBIT, ALU_A_P, C_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CLD, 1'b0}:
                // P[3] <= 0
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_CLRBIT, ALU_A_P, D_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CLI, 1'b0}:
                // P[2] <= 0
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_CLRBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CLV, 1'b0}:
                // P[6] <= 0
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_CLRBIT, ALU_A_P, V_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, SEC, 1'b0}:
                // P[0] <= 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SETBIT, ALU_A_P, C_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, SED, 1'b0}:
                // P[3] <= 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SETBIT, ALU_A_P, D_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, SEI, 1'b0}:
                // P[2] <= 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SETBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* INCREMENT/DECREMENT - INC, INX, INY, DEC, DEX, DEY */

            {UPAGE_OP, DEC_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, DEC_ZPG, 1'b1}};
            {UPAGE_OP, DEC_ZPG, 1'b1}:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ZPG};
            USEQ_ADDR_DEC_ZPG:
                // (ZPG) <= IMM, IMM <= IMM - 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_DEC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ZPG + 10'd1};
            USEQ_ADDR_DEC_ZPG + 10'd1:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, DEC_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ZPG_X};
            USEQ_ADDR_DEC_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ZPG_X + 10'd1};
            USEQ_ADDR_DEC_ZPG_X + 10'd1:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ZPG_X + 10'd2};
            USEQ_ADDR_DEC_ZPG_X + 10'd2:
                // (ZPG) <= IMM, IMM <= IMM - 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_DEC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, DEC_ZPG_X, 1'b1}};
            {UPAGE_OP, DEC_ZPG_X, 1'b1}:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, DEC_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, DEC_ABS, 1'b1}};
            {UPAGE_OP, DEC_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS};
            USEQ_ADDR_DEC_ABS:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS + 10'd1};
            USEQ_ADDR_DEC_ABS + 10'd1:
                // (IND) <= IMM, IMM <= IMM - 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_DEC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS + 10'd2};
            USEQ_ADDR_DEC_ABS + 10'd2:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, DEC_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_DEC_ABS_X + 10'd1};
            {UPAGE_OP, DEC_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS_X};
            USEQ_ADDR_DEC_ABS_X:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS_X + 10'd3};
            USEQ_ADDR_DEC_ABS_X + 10'd1:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS_X + 10'd2};
            USEQ_ADDR_DEC_ABS_X + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS_X + 10'd3};
            USEQ_ADDR_DEC_ABS_X + 10'd3:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS_X + 10'd4};
            USEQ_ADDR_DEC_ABS_X + 10'd4:
                // (IND) <= IMM, IMM <= IMM - 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_DEC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ABS_X + 10'd5};
            USEQ_ADDR_DEC_ABS_X + 10'd5:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, INC_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, INC_ZPG, 1'b1}};
            {UPAGE_OP, INC_ZPG, 1'b1}:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ZPG};
            USEQ_ADDR_INC_ZPG:
                // (ZPG) <= IMM, IMM <= IMM + 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_INC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_DEC_ZPG + 10'd1};
            USEQ_ADDR_INC_ZPG + 10'd1:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, INC_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ZPG_X};
            USEQ_ADDR_INC_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ZPG_X + 10'd1};
            USEQ_ADDR_INC_ZPG_X + 10'd1:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ZPG_X + 10'd2};
            USEQ_ADDR_INC_ZPG_X + 10'd2:
                // (ZPG) <= IMM, IMM <= IMM + 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_INC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, INC_ZPG_X, 1'b1}};
            {UPAGE_OP, INC_ZPG_X, 1'b1}:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, INC_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, INC_ABS, 1'b1}};
            {UPAGE_OP, INC_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS};
            USEQ_ADDR_INC_ABS:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS + 10'd1};
            USEQ_ADDR_INC_ABS + 10'd1:
                // (IND) <= IMM, IMM <= IMM + 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_INC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS + 10'd2};
            USEQ_ADDR_INC_ABS + 10'd2:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, INC_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_INC_ABS_X + 10'd1};
            {UPAGE_OP, INC_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS_X};
            USEQ_ADDR_INC_ABS_X:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS_X + 10'd3};
            USEQ_ADDR_INC_ABS_X + 10'd1:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS_X + 10'd2};
            USEQ_ADDR_INC_ABS_X + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS_X + 10'd3};
            USEQ_ADDR_INC_ABS_X + 10'd3:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS_X + 10'd4};
            USEQ_ADDR_INC_ABS_X + 10'd4:
                // (IND) <= IMM, IMM <= IMM + 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_INC, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_INC_ABS_X + 10'd5};
            USEQ_ADDR_INC_ABS_X + 10'd5:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, DEX, 1'b0}:
                // X <= X - 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_DEC, ALU_A_X, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, DEY, 1'b0}:
                // Y <= Y - 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_DEC, ALU_A_Y, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, INX, 1'b0}:
                // X <= X + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_X, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, INY, 1'b0}:
                // Y <= Y + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_Y, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* JUMP - JMP */

            {UPAGE_OP, JMP_ABS, 1'b0}:
                // IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, JMP_ABS, 1'b1}};
            {UPAGE_OP, JMP_ABS, 1'b1}:
                // PCH <= (PC), PCL <= IMM
                d <= {ADDR_PC, DATA_READ, DATA_PCH, ALU_OP_COPY, ALU_A_IMM, ALU_B_ZERO, ALU_O_PCL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, JMP_IND, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, JMP_IND, 1'b1}};
            {UPAGE_OP, JMP_IND, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_JMP_IND};
            USEQ_ADDR_JMP_IND:
                // IMM <= (IND), IND <= IND + 1
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_JMP_IND + 10'd1};
            USEQ_ADDR_JMP_IND + 10'd1:
                // PCH <= (IND), PCL <= IMM
                d <= {ADDR_IND, DATA_READ, DATA_PCH, ALU_OP_COPY, ALU_A_IMM, ALU_B_ZERO, ALU_O_PCL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* STACK - JSR RTS RTI PHA PHP PLA PLP */

            {UPAGE_OP, JSR, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, JSR, 1'b1}};
            {UPAGE_OP, JSR, 1'b1}:
                // ($0100,S) Dummy internal operation
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_JSR};
            USEQ_ADDR_JSR:
                // ($0100,S) <= PCH, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCH, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_JSR + 10'd1};
            USEQ_ADDR_JSR + 10'd1:
                // ($0100,S) <= PCL, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCL, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_JSR + 10'd2};
            USEQ_ADDR_JSR + 10'd2:
                // PCH <= (PC), PCL <= INDL
                d <= {ADDR_PC, DATA_READ, DATA_PCH, ALU_OP_COPY, ALU_A_INDL, ALU_B_ZERO, ALU_O_PCL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, RTS, 1'b0}:
                // (PC) Dummy read
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, RTS, 1'b1}};
            {UPAGE_OP, RTS, 1'b1}:
                // S <= S + 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RTS};
            USEQ_ADDR_RTS:
                // PCL <= ($0100,S), S <= S + 1
                d <= {ADDR_SP, DATA_READ, DATA_PCL, ALU_OP_INC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RTS + 10'd1};
            USEQ_ADDR_RTS + 10'd1:
                // PCH <= ($0100,S)
                d <= {ADDR_SP, DATA_READ, DATA_PCH, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RTS + 10'd2};
            USEQ_ADDR_RTS + 10'd2:
                // PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, RTI, 1'b0}:
                // (PC) Dummy read
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, RTI, 1'b1}};
            {UPAGE_OP, RTI, 1'b1}:
                // S <= S + 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RTI};
            USEQ_ADDR_RTI:
                // P <= ($0100,S), S <= S + 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_P, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_RTI + 10'd1};
            USEQ_ADDR_RTI + 10'd1:
                // PCL <= ($0100,S), S <= S + 1
                d <= {ADDR_SP, DATA_READ, DATA_PCL, ALU_OP_INC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RTI + 10'd2};
            USEQ_ADDR_RTI + 10'd2:
                // PCH <= ($0100,S)
                d <= {ADDR_SP, DATA_READ, DATA_PCH, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, PHA, 1'b0}:
                // IMM <= A, (PC) Dummy read
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_A, ALU_B_ZERO, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, PHA, 1'b1}};
            {UPAGE_OP, PHA, 1'b1}:
                // ($0100,S) <= IMM, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_IMM, ALU_OP_DEC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, PHP, 1'b0}: //PHP always pushes the Break (B) flag as a '1' to the stack.
                // IMM <= P, (PC) Dummy read
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SETBIT, ALU_A_P, B_BIT_IN_P, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, PHA, 1'b1}};

            {UPAGE_OP, PLA, 1'b0}:
                // (PC) Dummy read
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, PLA, 1'b1}};
            {UPAGE_OP, PLA, 1'b1}:
                // S <= S + 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_PLA};
            USEQ_ADDR_PLA:
                // A <= ($0100,S)
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, PLP, 1'b0}:
                // (PC) Dummy read
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, PLP, 1'b1}};
            {UPAGE_OP, PLP, 1'b1}:
                // S <= S + 1
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_S, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_PLP};
            USEQ_ADDR_PLP:
                // P <= ($0100,S)
                d <= {ADDR_SP, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_P, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* LOAD FROM MEMORY */

            {UPAGE_OP, LDA_IMM, 1'b0}:
                // A <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_OR, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDA_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LDA_ZPG, 1'b1}};
            {UPAGE_OP, LDA_ZPG, 1'b1}:
                // A <= ({$00,ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDX_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LDX_ZPG, 1'b1}};
            {UPAGE_OP, LDX_ZPG, 1'b1}:
                // A <= ({$00,ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDY_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LDY_ZPG, 1'b1}};
            {UPAGE_OP, LDY_ZPG, 1'b1}:
                // A <= ({$00,ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDA_ZPG_X, 1'b0}:
                // IMM <= (PC), ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ZPG_X};
            USEQ_ADDR_LDA_ZPG_X:
                // ({$00, ZPG}), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ZPG_X + 10'd1};
            USEQ_ADDR_LDA_ZPG_X + 10'd1:
                // A <= ({$00, ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDX_ZPG_Y, 1'b0}:
                // IMM <= (PC), ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDX_ZPG_Y};
            USEQ_ADDR_LDX_ZPG_Y:
                // ({$00, ZPG}), ZPG <= Y + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDX_ZPG_Y + 10'd1};
            USEQ_ADDR_LDX_ZPG_Y + 10'd1:
                // X <= ({$00, ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDY_ZPG_X, 1'b0}:
                // IMM <= (PC), ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDY_ZPG_X};
            USEQ_ADDR_LDY_ZPG_X:
                // ({$00, ZPG}), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDY_ZPG_X + 10'd1};
            USEQ_ADDR_LDY_ZPG_X + 10'd1:
                // Y <= ({$00, ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDA_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LDA_ABS, 1'b1}};
            {UPAGE_OP, LDA_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ABS};
            USEQ_ADDR_LDA_ABS:
                // A <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDX_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LDX_ABS, 1'b1}};
            {UPAGE_OP, LDX_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDX_ABS};
            USEQ_ADDR_LDX_ABS:
                // X <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDY_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LDY_ABS, 1'b1}};
            {UPAGE_OP, LDY_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDY_ABS};
            USEQ_ADDR_LDY_ABS:
                // Y <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDA_ABS_X, 1'b0}:
                // INDL <= (PC) + X, PC <= PC + 1 [check carry]
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_LDA_ABS_XY};
            {UPAGE_OP, LDA_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ABS_XY + 10'd2};
            USEQ_ADDR_LDA_ABS_XY:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ABS_XY + 10'd1};
            USEQ_ADDR_LDA_ABS_XY + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ABS_XY + 10'd2};
            USEQ_ADDR_LDA_ABS_XY + 10'd2:
                // A <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDA_ABS_Y, 1'b0}:
                // INDL <= (PC) + X, PC <= PC + 1 [check carry]
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_LDA_ABS_XY};
            {UPAGE_OP, LDA_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ABS_XY + 10'd2};

            {UPAGE_OP, LDX_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y, PC <= PC + 1 [check carry]
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_LDX_ABS_Y};
            {UPAGE_OP, LDX_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDX_ABS_Y + 10'd2};
            USEQ_ADDR_LDX_ABS_Y:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDX_ABS_Y + 10'd1};
            USEQ_ADDR_LDX_ABS_Y + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDX_ABS_Y + 10'd2};
            USEQ_ADDR_LDX_ABS_Y + 10'd2:
                // X <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDY_ABS_X, 1'b0}:
                // INDL <= (PC) + X, PC <= PC + 1 [check carry]
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_LDY_ABS_X};
            {UPAGE_OP, LDY_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDY_ABS_X + 10'd2};
            USEQ_ADDR_LDY_ABS_X:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDY_ABS_X + 10'd1};
            USEQ_ADDR_LDY_ABS_X + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDY_ABS_X + 10'd2};
            USEQ_ADDR_LDY_ABS_X + 10'd2:
                // Y <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            USEQ_ADDR_LDA_IMM_INDL:
                // IMM <= ({IMM, INDL})
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_INDL, ALU_B_IMM, ALU_O_ADDR, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_IMM_FETCH};
            USEQ_ADDR_LDA_IMM_FETCH:
                // A <= IMM, OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_A, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            USEQ_ADDR_LDX_IMM_INDL:
                // IMM <= ({IMM, INDL})
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_INDL, ALU_B_IMM, ALU_O_ADDR, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDX_IMM_FETCH};
            USEQ_ADDR_LDX_IMM_FETCH:
                // X <= IMM, OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_IMM, ALU_B_ZERO_FLG, ALU_O_X, ADDR_INC, USEQ_BR_IF_CLR, USEQ_OP};

            {UPAGE_OP, LDA_X_IND, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_X_IND};
            USEQ_ADDR_LDA_X_IND:
                // (ZPG), ZPG <= IMM + X
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_X_IND + 10'd1};
            USEQ_ADDR_LDA_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_X_IND + 10'd2};
            USEQ_ADDR_LDA_X_IND + 10'd2:
                // INDH <= ZPG
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, LDA_X_IND, 1'b1}};
            {UPAGE_OP, LDA_X_IND, 1'b1}:
                // A <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDA_IND_Y, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_IND_Y};
            USEQ_ADDR_LDA_IND_Y:
                // INDL <= ({$00,ZPG}) + Y, ZPG <= ZPG + 1, detect page crossing
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_LDA_IND_Y + 10'd2};
            USEQ_ADDR_LDA_IND_Y + 10'd1:
                // No page crossing:    INDH <= ({$00,ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, LDA_IND_Y, 1'b1}};
            USEQ_ADDR_LDA_IND_Y + 10'd2:
                // With page crossing:  INDH <= ({$00,ZPG})
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_IND_Y + 10'd3};
            USEQ_ADDR_LDA_IND_Y + 10'd3:
                // With page crossing: INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, LDA_IND_Y, 1'b1}};
            {UPAGE_OP, LDA_IND_Y, 1'b1}:
                // A <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDX_IMM, 1'b0}:
                // X <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_X, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDY_IMM, 1'b0}:
                // X <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* STORE TO MEMORY */

            {UPAGE_OP, STA_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, STA_ABS, 1'b1}};
            {UPAGE_OP, STA_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ABS};
            USEQ_ADDR_STA_ABS:
                // (IND) <= A
                d <= {ADDR_IND, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_A, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STX_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, STX_ABS, 1'b1}};
            {UPAGE_OP, STX_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STX_ABS};
            USEQ_ADDR_STX_ABS:
                // (IND) <= X
                d <= {ADDR_IND, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_X, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STY_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, STY_ABS, 1'b1}};
            {UPAGE_OP, STY_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STY_ABS};
            USEQ_ADDR_STY_ABS:
                // (IND) <= Y
                d <= {ADDR_IND, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_Y, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STA_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_STA_ABS_XY + 10'd1};
            {UPAGE_OP, STA_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ABS_XY};
            USEQ_ADDR_STA_ABS_XY:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ABS_XY + 10'd3};
            USEQ_ADDR_STA_ABS_XY + 10'd1:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ABS_XY + 10'd2};
            USEQ_ADDR_STA_ABS_XY + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ABS_XY + 10'd3};
            USEQ_ADDR_STA_ABS_XY + 10'd3:
                // (IND) <= A
                d <= {ADDR_IND, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_A, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STA_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y [check carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_STA_ABS_XY + 10'd1};
            {UPAGE_OP, STA_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ABS_XY};

            {UPAGE_OP, STA_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, STA_ZPG, 1'b1}};
            {UPAGE_OP, STA_ZPG, 1'b1}:
                // ({$00,ZPG}) <= A
                d <= {ADDR_ZPG, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_A, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STX_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, STX_ZPG, 1'b1}};
            {UPAGE_OP, STX_ZPG, 1'b1}:
                // ({$00,ZPG}) <= X
                d <= {ADDR_ZPG, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_X, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STY_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, STY_ZPG, 1'b1}};
            {UPAGE_OP, STY_ZPG, 1'b1}:
                // ({$00,ZPG}) <= X
                d <= {ADDR_ZPG, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_Y, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STX_ZPG_Y, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STX_ZPG_Y};
            USEQ_ADDR_STX_ZPG_Y:
                // (ZPG), ZPG <= IMM + Y
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STX_ZPG_Y + 10'd1};
            USEQ_ADDR_STX_ZPG_Y + 10'd1:
                // (ZPG) <= X
                d <= {ADDR_ZPG, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_X, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STY_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STY_ZPG_X};
            USEQ_ADDR_STY_ZPG_X:
                // (ZPG), ZPG <= IMM + X
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STY_ZPG_X + 10'd1};
            USEQ_ADDR_STY_ZPG_X + 10'd1:
                // (ZPG) <= Y
                d <= {ADDR_ZPG, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_Y, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STA_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ZPG_X};
            USEQ_ADDR_STA_ZPG_X:
                // (ZPG), ZPG <= IMM + X
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STA_ZPG_X + 10'd1};
            USEQ_ADDR_STA_ZPG_X + 10'd1:
                // A <= (ZPG)
                d <= {ADDR_ZPG, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_A, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, STA_X_IND, 1'b0}:
                // ZPG <= (PC), IMM < (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_X_IND};
            USEQ_ADDR_STA_X_IND:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STA_X_IND + 10'd1};
            USEQ_ADDR_STA_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_X_IND + 10'd2};
            USEQ_ADDR_STA_X_IND + 10'd2:
                // INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, STA_X_IND, 1'b1}};
            {UPAGE_OP, STA_X_IND, 1'b1}:
                // (IND) <= A
                d <= {ADDR_IND, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_A, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};


            {UPAGE_OP, STA_IND_Y, 1'b0}:
                // ZPG <= PC, PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_STA_IND_Y};
            USEQ_ADDR_STA_IND_Y:
                // INDL <= (ZPG) + Y [check for carry], ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_STA_IND_Y + 10'd3};
            USEQ_ADDR_STA_IND_Y + 10'd1:
                // [no carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STA_IND_Y + 10'd2};
            USEQ_ADDR_STA_IND_Y + 10'd2:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, STA_IND_Y, 1'b1}};
            USEQ_ADDR_STA_IND_Y + 10'd3:
                // [carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_STA_IND_Y + 10'd4};
            USEQ_ADDR_STA_IND_Y + 10'd4:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, STA_IND_Y, 1'b1}};
            {UPAGE_OP, STA_IND_Y, 1'b1}:
                // (IND) <= A
                d <= {ADDR_IND, DATA_WRITE, DATA_NULL, ALU_OP_COPY, ALU_A_A, ALU_B_ZERO, ALU_O_DO, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* TRANSFER BETWEEN REGISTERS */

            {UPAGE_OP, TAX, 1'b0}:
                // X <= A
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_A, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, TAY, 1'b0}:
                // Y <= A
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_A, ALU_B_ZERO_FLG, ALU_O_Y, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, TYA, 1'b0}:
                // A <= Y
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_Y, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, TSX, 1'b0}:
                // X <= S
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_S, ALU_B_ZERO_FLG, ALU_O_X, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, TXA, 1'b0}:
                // A <= X
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_X, ALU_B_ZERO_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, TXS, 1'b0}:
                // S <= X
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_X, ALU_B_ZERO, ALU_O_S, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* MATHEMATICS - ADC SBC CMP CPX CPY */

            {UPAGE_OP, ADC_IMM, 1'b0}:
                // A <= A + (PC) + C, PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_ADC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ADC_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ADC_ZPG, 1'b1}};
            {UPAGE_OP, ADC_ZPG, 1'b1}:
                // A <= A + (ZPG) + C
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_ADC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ADC_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_ZPG_X};
            USEQ_ADDR_ADC_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_ZPG_X + 10'd1};
            USEQ_ADDR_ADC_ZPG_X + 10'd1:
                // A <= A + (ZPG) + C
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_ADC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ADC_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ADC_ABS, 1'b1}};
            {UPAGE_OP, ADC_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND};
            USEQ_ADDR_ADC_IND:
                // A <= A + (IND) + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_ADC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ADC_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_ADC_ABS_XY};
            {UPAGE_OP, ADC_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND};
            USEQ_ADDR_ADC_ABS_XY:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_ABS_XY + 10'd1};
            USEQ_ADDR_ADC_ABS_XY + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND};

            {UPAGE_OP, ADC_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_ADC_ABS_XY};
            {UPAGE_OP, ADC_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND};

            {UPAGE_OP, ADC_X_IND, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_X_IND};
            USEQ_ADDR_ADC_X_IND:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_X_IND + 10'd1};
            USEQ_ADDR_ADC_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ADC_X_IND, 1'b1}};
            {UPAGE_OP, ADC_X_IND, 1'b1}:
                // INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND};

            {UPAGE_OP, ADC_IND_Y, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND_Y};
            USEQ_ADDR_ADC_IND_Y:
                // INDL <= (ZPG) + Y [check for carry], ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ADC_IND_Y, 1'b1}};
            USEQ_ADDR_ADC_IND_Y + 10'd1:
                // [carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND_Y + 10'd2};
            USEQ_ADDR_ADC_IND_Y + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND};
            {UPAGE_OP, ADC_IND_Y, 1'b1}:
                // [no carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ADC_IND};

            {UPAGE_OP, SBC_IMM, 1'b0}:
                // A <= A - (PC) - !C, PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SBC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, SBC_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, SBC_ZPG, 1'b1}};
            {UPAGE_OP, SBC_ZPG, 1'b1}:
                // A <= A - (PC) - !C
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_SBC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, SBC_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_ZPG_X};
            USEQ_ADDR_SBC_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_ZPG_X + 10'd1};
            USEQ_ADDR_SBC_ZPG_X + 10'd1:
                // A <= A - (PC) - !C
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_SBC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, SBC_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, SBC_ABS, 1'b1}};
            {UPAGE_OP, SBC_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND};
            USEQ_ADDR_SBC_IND:
                // A <= A + (IND) + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_SBC, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, SBC_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_SBC_ABS_XY};
            {UPAGE_OP, SBC_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND};
            USEQ_ADDR_SBC_ABS_XY:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_ABS_XY + 10'd1};
            USEQ_ADDR_SBC_ABS_XY + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND};

            {UPAGE_OP, SBC_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_SBC_ABS_XY};
            {UPAGE_OP, SBC_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND};

            {UPAGE_OP, SBC_X_IND, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_X_IND};
            USEQ_ADDR_SBC_X_IND:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_X_IND + 10'd1};
            USEQ_ADDR_SBC_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, SBC_X_IND, 1'b1}};
            {UPAGE_OP, SBC_X_IND, 1'b1}:
                // INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND};

            {UPAGE_OP, SBC_IND_Y, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND_Y};
            USEQ_ADDR_SBC_IND_Y:
                // INDL <= (ZPG) + Y [check for carry], ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, SBC_IND_Y, 1'b1}};
            USEQ_ADDR_SBC_IND_Y + 10'd1:
                // [carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND_Y + 10'd2};
            USEQ_ADDR_SBC_IND_Y + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND};
            {UPAGE_OP, SBC_IND_Y, 1'b1}:
                // [no carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_SBC_IND};

            {UPAGE_OP, CMP_IMM, 1'b0}:
                // A - (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_A, ALU_B_DI_FLG, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CPX_IMM, 1'b0}:
                // X - (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_X, ALU_B_DI_FLG, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CPY_IMM, 1'b0}:
                // Y - (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_Y, ALU_B_DI_FLG, ALU_O_NULL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CMP_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_ZPG};

            {UPAGE_OP, CPX_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, CPX_ZPG, 1'b1}};
            {UPAGE_OP, CPX_ZPG, 1'b1}:
                // X - (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_X, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CPY_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, CPY_ZPG, 1'b1}};
            {UPAGE_OP, CPY_ZPG, 1'b1}:
                // Y - (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_Y, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CMP_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_ZPG_X};
            USEQ_ADDR_CMP_ZPG_X:
                // (ZPG), ZPG <= IMM + X
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_ZPG};
            USEQ_ADDR_CMP_ZPG:
                // A - (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_A, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CMP_ABS, 1'b0}:
                // INDL <= (PC), PC = PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, CMP_ABS, 1'b1}};
            {UPAGE_OP, CMP_ABS, 1'b1}:
                // INDH <= (PC), PC = PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_IND};
            USEQ_ADDR_CMP_IND:
                // A - (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_A, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CPX_ABS, 1'b0}:
                // INDL <= (PC), PC = PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, CPX_ABS, 1'b1}};
            {UPAGE_OP, CPX_ABS, 1'b1}:
                // INDH <= (PC), PC = PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CPX_IND};
            USEQ_ADDR_CPX_IND:
                // X - (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_X, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CPY_ABS, 1'b0}:
                // INDL <= (PC), PC = PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, CPY_ABS, 1'b1}};
            {UPAGE_OP, CPY_ABS, 1'b1}:
                // INDH <= (PC), PC = PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CPY_IND};
            USEQ_ADDR_CPY_IND:
                // Y - (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_Y, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CMP_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y [branch if carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_CMP_ABS_XY};
            {UPAGE_OP, CMP_ABS_Y, 1'b1}:
                // [no INDL carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_IND};
            USEQ_ADDR_CMP_ABS_XY:
                // [was INDL carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_ABS_XY + 10'd1};
            USEQ_ADDR_CMP_ABS_XY + 10'd1:
                // (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_IND};

            {UPAGE_OP, CMP_ABS_X, 1'b0}:
                // INDL <= (PC) + X [branch if carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_CMP_ABS_XY};
            {UPAGE_OP, CMP_ABS_X, 1'b1}:
                // [no INDL carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_IND};

            {UPAGE_OP, CMP_X_IND, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_X_IND};
            USEQ_ADDR_CMP_X_IND:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_X_IND + 10'd1};
            USEQ_ADDR_CMP_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_X_IND + 10'd2};
            USEQ_ADDR_CMP_X_IND + 10'd2:
                // INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, CMP_X_IND, 1'b1}};
            {UPAGE_OP, CMP_X_IND, 1'b1}:
                // A - (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_A, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, CMP_IND_Y, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_IND_Y};
            USEQ_ADDR_CMP_IND_Y:
                // INDL <= (ZPG) + Y [check for carry], ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_CMP_IND_Y + 10'd2};
            USEQ_ADDR_CMP_IND_Y + 10'd1:
                // [no carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, CMP_IND_Y, 1'b1}};
            USEQ_ADDR_CMP_IND_Y + 10'd2:
                // [carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_CMP_IND_Y + 10'd3};
            USEQ_ADDR_CMP_IND_Y + 10'd3:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, CMP_IND_Y, 1'b1}};
            {UPAGE_OP, CMP_IND_Y, 1'b1}:
                // A - (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_CMP, ALU_A_A, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* BIT SHIFTING - ASL LSR ROL ROR  */

            {UPAGE_OP, ASL_A, 1'b0}:
                // A <= A << 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SGL, ALU_A_A, ALU_SOP_ASL, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ASL_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ASL_ZPG, 1'b1}};
            {UPAGE_OP, ASL_ZPG, 1'b1}:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ZPG};
            USEQ_ADDR_ASL_ZPG:
                // (ZPG) <= IMM, IMM <= IMM << 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ASL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ZPG + 10'd1};
            USEQ_ADDR_ASL_ZPG + 10'd1:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ASL_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ZPG_X};
            USEQ_ADDR_ASL_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ZPG_X + 10'd1};
            USEQ_ADDR_ASL_ZPG_X + 10'd1:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ZPG_X + 10'd2};
            USEQ_ADDR_ASL_ZPG_X + 10'd2:
                // (ZPG) <= IMM, IMM <= IMM << 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ASL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, ASL_ZPG_X, 1'b1}};
            {UPAGE_OP, ASL_ZPG_X, 1'b1}:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ASL_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ASL_ABS, 1'b1}};
            {UPAGE_OP, ASL_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS};
            USEQ_ADDR_ASL_ABS:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS + 10'd1};
            USEQ_ADDR_ASL_ABS + 10'd1:
                // (IND) <= IMM, IMM <= IMM << 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ASL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS + 10'd2};
            USEQ_ADDR_ASL_ABS + 10'd2:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ASL_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_ASL_ABS_X + 10'd1};
            {UPAGE_OP, ASL_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS_X};
            USEQ_ADDR_ASL_ABS_X:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS_X + 10'd3};
            USEQ_ADDR_ASL_ABS_X + 10'd1:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS_X + 10'd2};
            USEQ_ADDR_ASL_ABS_X + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS_X + 10'd3};
            USEQ_ADDR_ASL_ABS_X + 10'd3:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS_X + 10'd4};
            USEQ_ADDR_ASL_ABS_X + 10'd4:
                // (IND) <= IMM, IMM <= IMM << 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ASL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ASL_ABS_X + 10'd5};
            USEQ_ADDR_ASL_ABS_X + 10'd5:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LSR_A, 1'b0}:
                // A <= A >> 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SGL, ALU_A_A, ALU_SOP_LSR, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LSR_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LSR_ZPG, 1'b1}};
            {UPAGE_OP, LSR_ZPG, 1'b1}:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ZPG};
            USEQ_ADDR_LSR_ZPG:
                // (ZPG) <= IMM, IMM <= IMM << 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_LSR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ZPG + 10'd1};
            USEQ_ADDR_LSR_ZPG + 10'd1:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LSR_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ZPG_X};
            USEQ_ADDR_LSR_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ZPG_X + 10'd1};
            USEQ_ADDR_LSR_ZPG_X + 10'd1:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ZPG_X + 10'd2};
            USEQ_ADDR_LSR_ZPG_X + 10'd2:
                // (ZPG) <= IMM, IMM <= IMM >> 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_LSR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, LSR_ZPG_X, 1'b1}};
            {UPAGE_OP, LSR_ZPG_X, 1'b1}:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LSR_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, LSR_ABS, 1'b1}};
            {UPAGE_OP, LSR_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS};
            USEQ_ADDR_LSR_ABS:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS + 10'd1};
            USEQ_ADDR_LSR_ABS + 10'd1:
                // (IND) <= IMM, IMM <= IMM >> 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_LSR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS + 10'd2};
            USEQ_ADDR_LSR_ABS + 10'd2:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LSR_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_LSR_ABS_X + 10'd1};
            {UPAGE_OP, LSR_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS_X};
            USEQ_ADDR_LSR_ABS_X:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS_X + 10'd3};
            USEQ_ADDR_LSR_ABS_X + 10'd1:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS_X + 10'd2};
            USEQ_ADDR_LSR_ABS_X + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS_X + 10'd3};
            USEQ_ADDR_LSR_ABS_X + 10'd3:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS_X + 10'd4};
            USEQ_ADDR_LSR_ABS_X + 10'd4:
                // (IND) <= IMM, IMM <= IMM >> 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_LSR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_LSR_ABS_X + 10'd5};
            USEQ_ADDR_LSR_ABS_X + 10'd5:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROL_A, 1'b0}:
                // A <= A << 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SGL, ALU_A_A, ALU_SOP_ROL, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROL_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ROL_ZPG, 1'b1}};
            {UPAGE_OP, ROL_ZPG, 1'b1}:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ZPG};
            USEQ_ADDR_ROL_ZPG:
                // (ZPG) <= IMM, IMM <= IMM << 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ZPG + 10'd1};
            USEQ_ADDR_ROL_ZPG + 10'd1:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROL_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ZPG_X};
            USEQ_ADDR_ROL_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ZPG_X + 10'd1};
            USEQ_ADDR_ROL_ZPG_X + 10'd1:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ZPG_X + 10'd2};
            USEQ_ADDR_ROL_ZPG_X + 10'd2:
                // (ZPG) <= IMM, IMM <= IMM << 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, ROL_ZPG_X, 1'b1}};
            {UPAGE_OP, ROL_ZPG_X, 1'b1}:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROL_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ROL_ABS, 1'b1}};
            {UPAGE_OP, ROL_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS};
            USEQ_ADDR_ROL_ABS:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS + 10'd1};
            USEQ_ADDR_ROL_ABS + 10'd1:
                // (IND) <= IMM, IMM <= IMM << 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS + 10'd2};
            USEQ_ADDR_ROL_ABS + 10'd2:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROL_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_ROL_ABS_X + 10'd1};
            {UPAGE_OP, ROL_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS_X};
            USEQ_ADDR_ROL_ABS_X:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS_X + 10'd3};
            USEQ_ADDR_ROL_ABS_X + 10'd1:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS_X + 10'd2};
            USEQ_ADDR_ROL_ABS_X + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS_X + 10'd3};
            USEQ_ADDR_ROL_ABS_X + 10'd3:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS_X + 10'd4};
            USEQ_ADDR_ROL_ABS_X + 10'd4:
                // (IND) <= IMM, IMM <= IMM << 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROL, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROL_ABS_X + 10'd5};
            USEQ_ADDR_ROL_ABS_X + 10'd5:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROR_A, 1'b0}:
                // A <= A >> 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SGL, ALU_A_A, ALU_SOP_ROR, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROR_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ROR_ZPG, 1'b1}};
            {UPAGE_OP, ROR_ZPG, 1'b1}:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ZPG};
            USEQ_ADDR_ROR_ZPG:
                // (ZPG) <= IMM, IMM <= IMM >> 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ZPG + 10'd1};
            USEQ_ADDR_ROR_ZPG + 10'd1:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROR_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ZPG_X};
            USEQ_ADDR_ROR_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ZPG_X + 10'd1};
            USEQ_ADDR_ROR_ZPG_X + 10'd1:
                // IMM <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ZPG_X + 10'd2};
            USEQ_ADDR_ROR_ZPG_X + 10'd2:
                // (ZPG) <= IMM, IMM <= IMM >> 1
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, {UPAGE_OP, ROR_ZPG_X, 1'b1}};
            {UPAGE_OP, ROR_ZPG_X, 1'b1}:
                // (ZPG) <= IMM
                d <= {ADDR_ZPG, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROR_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ROR_ABS, 1'b1}};
            {UPAGE_OP, ROR_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS};
            USEQ_ADDR_ROR_ABS:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS + 10'd1};
            USEQ_ADDR_ROR_ABS + 10'd1:
                // (IND) <= IMM, IMM <= IMM >> 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS + 10'd2};
            USEQ_ADDR_ROR_ABS + 10'd2:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ROR_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_ROR_ABS_X + 10'd1};
            {UPAGE_OP, ROR_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS_X};
            USEQ_ADDR_ROR_ABS_X:
                // [no carry] (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS_X + 10'd3};
            USEQ_ADDR_ROR_ABS_X + 10'd1:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS_X + 10'd2};
            USEQ_ADDR_ROR_ABS_X + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS_X + 10'd3};
            USEQ_ADDR_ROR_ABS_X + 10'd3:
                // IMM <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS_X + 10'd4};
            USEQ_ADDR_ROR_ABS_X + 10'd4:
                // (IND) <= IMM, IMM <= IMM >> 1
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_SGL, ALU_A_IMM, ALU_SOP_ROR, ALU_O_IMM, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ROR_ABS_X + 10'd5};
            USEQ_ADDR_ROR_ABS_X + 10'd5:
                // (IND) <= IMM
                d <= {ADDR_IND, DATA_WRITE, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

/* LOGICAL - AND EOR ORA BIT */

            {UPAGE_OP, AND_IMM, 1'b0}:
                // A <= A & (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, AND_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, AND_ZPG, 1'b1}};
            {UPAGE_OP, AND_ZPG, 1'b1}:
                // A <= A & (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, AND_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_AND_ZPG_X};
            USEQ_ADDR_AND_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_AND_ZPG_X + 10'd1};
            USEQ_ADDR_AND_ZPG_X + 10'd1:
                // A <= A & (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, AND_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, AND_ABS, 1'b1}};
            {UPAGE_OP, AND_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND};
            USEQ_ADDR_AND_IND:
                // A <= A & (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, AND_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_AND_ABS_XY};
            {UPAGE_OP, AND_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND};
            USEQ_ADDR_AND_ABS_XY:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_AND_ABS_XY + 10'd1};
            USEQ_ADDR_AND_ABS_XY + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND};

            {UPAGE_OP, AND_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_AND_ABS_XY};
            {UPAGE_OP, AND_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND};

            {UPAGE_OP, AND_X_IND, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_AND_X_IND};
            USEQ_ADDR_AND_X_IND:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_AND_X_IND + 10'd1};
            USEQ_ADDR_AND_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, AND_X_IND, 1'b1}};
            {UPAGE_OP, AND_X_IND, 1'b1}:
                // INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND};

            {UPAGE_OP, AND_IND_Y, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND_Y};
            USEQ_ADDR_AND_IND_Y:
                // INDL <= (ZPG) + Y [check for carry], ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, AND_IND_Y, 1'b1}};
            USEQ_ADDR_AND_IND_Y + 10'd1:
                // [carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND_Y + 10'd2};
            USEQ_ADDR_AND_IND_Y + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND};
            {UPAGE_OP, AND_IND_Y, 1'b1}:
                // [no carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_AND_IND};

            {UPAGE_OP, EOR_IMM, 1'b0}:
                // A <= A ^ (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_EOR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, EOR_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, EOR_ZPG, 1'b1}};
            {UPAGE_OP, EOR_ZPG, 1'b1}:
                // A <= A ^ (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_EOR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, EOR_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_ZPG_X};
            USEQ_ADDR_EOR_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_ZPG_X + 10'd1};
            USEQ_ADDR_EOR_ZPG_X + 10'd1:
                // A <= A ^ (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_EOR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP,EOR_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, EOR_ABS, 1'b1}};
            {UPAGE_OP, EOR_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND};
            USEQ_ADDR_EOR_IND:
                // A <= A ^ (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_EOR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, EOR_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_EOR_ABS_XY};
            {UPAGE_OP, EOR_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND};
            USEQ_ADDR_EOR_ABS_XY:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_ABS_XY + 10'd1};
            USEQ_ADDR_EOR_ABS_XY + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND};

            {UPAGE_OP, EOR_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_EOR_ABS_XY};
            {UPAGE_OP, EOR_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND};

            {UPAGE_OP, EOR_X_IND, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_X_IND};
            USEQ_ADDR_EOR_X_IND:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_X_IND + 10'd1};
            USEQ_ADDR_EOR_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, EOR_X_IND, 1'b1}};
            {UPAGE_OP, EOR_X_IND, 1'b1}:
                // INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND};

            {UPAGE_OP, EOR_IND_Y, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND_Y};
            USEQ_ADDR_EOR_IND_Y:
                // INDL <= (ZPG) + Y [check for carry], ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, EOR_IND_Y, 1'b1}};
            USEQ_ADDR_EOR_IND_Y + 10'd1:
                // [carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND_Y + 10'd2};
            USEQ_ADDR_EOR_IND_Y + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND};
            {UPAGE_OP, EOR_IND_Y, 1'b1}:
                // [no carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_EOR_IND};

            {UPAGE_OP, ORA_IMM, 1'b0}:
                // A <= A | (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ORA_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ORA_ZPG, 1'b1}};
            {UPAGE_OP, ORA_ZPG, 1'b1}:
                // A <= A | (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ORA_ZPG_X, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_ZPG_X};
            USEQ_ADDR_ORA_ZPG_X:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_ZPG_X + 10'd1};
            USEQ_ADDR_ORA_ZPG_X + 10'd1:
                // A <= A | (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ORA_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ORA_ABS, 1'b1}};
            {UPAGE_OP, ORA_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND};
            USEQ_ADDR_ORA_IND:
                // A <= A | (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_A, ALU_B_DI_FLG, ALU_O_A, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, ORA_ABS_X, 1'b0}:
                // INDL <= (PC) + X [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_ORA_ABS_XY};
            {UPAGE_OP, ORA_ABS_X, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND};
            USEQ_ADDR_ORA_ABS_XY:
                // [carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_ABS_XY + 10'd1};
            USEQ_ADDR_ORA_ABS_XY + 10'd1:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND};

            {UPAGE_OP, ORA_ABS_Y, 1'b0}:
                // INDL <= (PC) + Y [check for carry], PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_SET, USEQ_ADDR_ORA_ABS_XY};
            {UPAGE_OP, ORA_ABS_Y, 1'b1}:
                // [no carry] INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND};

            {UPAGE_OP, ORA_X_IND, 1'b0}:
                // ZPG <= (PC), IMM <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_IMM, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_X_IND};
            USEQ_ADDR_ORA_X_IND:
                // (ZPG), ZPG <= X + IMM
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_X, ALU_B_IMM, ALU_O_ZPG, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_X_IND + 10'd1};
            USEQ_ADDR_ORA_X_IND + 10'd1:
                // INDL <= (ZPG), ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ORA_X_IND, 1'b1}};
            {UPAGE_OP, ORA_X_IND, 1'b1}:
                // INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND};

            {UPAGE_OP, ORA_IND_Y, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND_Y};
            USEQ_ADDR_ORA_IND_Y:
                // INDL <= (ZPG) + Y [check for carry], ZPG <= ZPG + 1
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_IADD, ALU_A_Y, ALU_B_DI, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, ORA_IND_Y, 1'b1}};
            USEQ_ADDR_ORA_IND_Y + 10'd1:
                // [carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND_Y + 10'd2};
            USEQ_ADDR_ORA_IND_Y + 10'd2:
                // [carry] (IND), INDH <= INDH + 1
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_INC, ALU_A_INDH, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND};
            {UPAGE_OP, ORA_IND_Y, 1'b1}:
                // [no carry] INDH <= (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_ORA_IND};

            {UPAGE_OP, BIT_ZPG, 1'b0}:
                // ZPG <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_ZPG, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, BIT_ZPG, 1'b1}};
            {UPAGE_OP, BIT_ZPG, 1'b1}:
                // A & (ZPG)
                d <= {ADDR_ZPG, DATA_READ, DATA_NULL, ALU_OP_BIT, ALU_A_A, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, BIT_ABS, 1'b0}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDL, ADDR_INC, USEQ_BR_IF_CLR, {UPAGE_OP, BIT_ABS, 1'b1}};
            {UPAGE_OP, BIT_ABS, 1'b1}:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_COPY, ALU_A_DI, ALU_B_ZERO, ALU_O_INDH, ADDR_INC, USEQ_BR_IF_CLR, USEQ_ADDR_BIT_ABS};
            USEQ_ADDR_BIT_ABS:
                // A & (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_BIT, ALU_A_A, ALU_B_DI_FLG, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, NOP, 1'b0}:
                // Do nothing too serious
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            default: // Halt
                d <= {ADDR_SP, DATA_READ, DATA_IMM, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, ADDR_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_HALT};
        endcase
    end
end


endmodule
