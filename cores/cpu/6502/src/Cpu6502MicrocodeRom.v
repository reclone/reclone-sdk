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
`include "Cpu6502MicrocodeConstants.vh"

module Cpu6502MicrocodeRom
(
    input               clock,
    input               enable,
    input [9:0]         address,
    output wire [1:0]   addrBusMux,
    output wire         dataBusWriteEnable,
    output wire [3:0]   dataBusMux,
    output wire [2:0]   aluOperation,
    output wire [3:0]   aluOperandA,
    output wire [2:0]   aluOperandB,
    output wire [2:0]   aluResultStorage,
    output wire         incrementPC,
    output wire         uSeqBranchCondition,
    output wire [9:0]   uSeqBranchAddr
);

reg [31:0] d = 32'h00000000;

assign addrBusMux = d[31:30];
assign dataBusWriteEnable = d[29];
assign dataBusMux = d[28:25];
assign aluOperation = d[24:22];
assign aluOperandA = d[21:18];
assign aluOperandB = d[17:15];
assign aluResultStorage = d[14:12];
assign incrementPC = d[11];
assign uSeqBranchCondition = d[10];
assign uSeqBranchAddr = d[9:0];

// Microsequencer branch addresses
localparam USEQ_ADDR_FETCH  = 10'h005;
localparam USEQ_ADDR_LDA_ABS = 10'h015;
localparam USEQ_ADDR_HALT   = 10'h2FF;
localparam USEQ_ADDR_NONE   = USEQ_ADDR_HALT;

// Microcode ROM is updated on the negative edge of the clock, so that
// if the ALU and data bus operate on the positive edge of the clock, then
// an opcode can effectively be fetched and decoded in the same cycle.
always @ (negedge clock)
begin
    if (enable)
    begin
        case (address)
        
            /* RESET - Load PC with vector at $FFFC, and set I - normally takes 6 cycles */
            USEQ_ADDR_RESET:
                // PCL <= ($FFFC)
                d <= {ADDR_VEC, DATA_READ, DATA_PCL, ALU_OP_CLRBIT, ALU_A_FE, 3'd1, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd1};
            USEQ_ADDR_RESET + 10'd1:
                // PCH <= ($FFFD)
                d <= {ADDR_VEC, DATA_READ, DATA_PCH, ALU_OP_CLRBIT, ALU_A_FF, 3'd1, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_RESET + 10'd2};
            USEQ_ADDR_RESET + 10'd2:
                // OP <= (PC), I <= 1
                d <= {ADDR_PC, DATA_READ, DATA_OP, ALU_OP_SETBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, PC_INC, USEQ_BR_IF_CLR, USEQ_OP};

            /* IRQ - push PC and P onto stack, then fetch IRQ vector at ($FFFE) into PC and set I */
            USEQ_ADDR_IRQ:
                // ($0100,S) <= PCH, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCH, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd1};
            USEQ_ADDR_IRQ + 10'd1:
                // ($0100,S) <= PCL, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCL, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd2};
            USEQ_ADDR_IRQ + 10'd2:
                // ($0100,S) <= P, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_P, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd3};
            USEQ_ADDR_IRQ + 10'd3:
                // PCL <= ($FFFE)
                d <= {ADDR_VEC, DATA_READ, DATA_PCL, ALU_OP_OR, ALU_A_FE, ALU_B_ZERO, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd4};
            USEQ_ADDR_IRQ + 10'd4:
                // PCH <= ($FFFF)
                d <= {ADDR_VEC, DATA_READ, DATA_PCH, ALU_OP_OR, ALU_A_FF, ALU_B_ZERO, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ + 10'd5};
            USEQ_ADDR_IRQ + 10'd5:
                // OP <= (PC), PC <= PC + 1, I <= 1
                d <= {ADDR_PC, DATA_READ, DATA_OP, ALU_OP_SETBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, PC_INC, USEQ_BR_IF_CLR, USEQ_OP};

            /* NMI - push PC and P onto stack, then fetch NMI vector at ($FFFA) into PC */
            USEQ_ADDR_NMI:
                // ($0100,S) <= PCH, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCH, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd1};
            USEQ_ADDR_NMI + 10'd1:
                // ($0100,S) <= PCL, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCL, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd2};
            USEQ_ADDR_NMI + 10'd2:
                // ($0100,S) <= P, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_P, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd3};
            USEQ_ADDR_NMI + 10'd3:
                // PCL <= ($FFFA)
                d <= {ADDR_VEC, DATA_READ, DATA_PCL, ALU_OP_CLRBIT, ALU_A_FE, 3'h2, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_NMI + 10'd4};
            USEQ_ADDR_NMI + 10'd4:
                // PCH <= ($FFFB)
                d <= {ADDR_VEC, DATA_READ, DATA_PCH, ALU_OP_CLRBIT, ALU_A_FF, 3'h2, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            /* FETCH - Load OP with byte at (PC), increment PC, then decode opcode next */
            USEQ_ADDR_FETCH:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_OP, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_INC, USEQ_BR_IF_CLR, USEQ_OP};

            /* HALT - Lock up the microsequencer until reset */
            USEQ_ADDR_HALT:
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_HALT};

            {UPAGE_OP, BRK}:
                //  B <= 1, PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_SETBIT, ALU_A_P, B_BIT_IN_P, ALU_O_P, PC_INC, USEQ_BR_IF_CLR, USEQ_ADDR_IRQ};
                
            {UPAGE_OP, LDA_IMM}:
                // A <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, PC_INC, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            {UPAGE_OP, LDA_ABS}:
                // INDL <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_INDL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ABS};
            USEQ_ADDR_LDA_ABS:
                // INDH <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_INDH, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_INC, USEQ_BR_IF_CLR, USEQ_ADDR_LDA_ABS + 10'd1};
            USEQ_ADDR_LDA_ABS + 10'd1:
                // A <= (IND)
                d <= {ADDR_IND, DATA_READ, DATA_NULL, ALU_OP_OR, ALU_A_DI, ALU_B_ZERO_FLG, ALU_O_A, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_FETCH};

            default: // Halt
                d <= {ADDR_PC, DATA_READ, DATA_NULL, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_NOP, USEQ_BR_IF_CLR, USEQ_ADDR_HALT};
        endcase
    end
end


endmodule
