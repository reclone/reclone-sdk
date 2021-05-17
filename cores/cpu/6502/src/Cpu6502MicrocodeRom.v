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

module Cpu6502MicrocodeRom
(
    input               clock,
    input               enable,
    input [8:0]         address,
    output wire [2:0]   addrBusMux,
    output wire         dataBusWriteEnable,
    output wire [3:0]   dataBusMux,
    output wire [2:0]   aluOperation,
    output wire [3:0]   aluOperandA,
    output wire [2:0]   aluOperandB,
    output wire [2:0]   aluResultStorage,
    output wire         incrementPC,
    output wire [1:0]   uSeqBranchMode,
    output wire [7:0]   uSeqBranchAddr
);

`include "Cpu6502MicrocodeConstants.vh"

reg [31:0] d = 32'h00000000;

assign addrBusMux = d[31:29];
assign dataBusWriteEnable = d[28];
assign dataBusMux = d[27:24];
assign aluOperation = d[23:21];
assign aluOperandA = d[20:17];
assign aluOperandB = d[16:14];
assign aluResultStorage = d[13:11];
assign incrementPC = d[10];
assign uSeqBranchMode = d[9:8];
assign uSeqBranchAddr = d[7:0];

// Microcode ROM is updated on the negative edge of the clock, so that
// if the ALU and data bus operate on the positive edge of the clock, then
// an opcode can effectively be fetched and decoded in the same cycle.
always @ (negedge clock)
begin
    if (enable)
    begin
        case (address)
            /* BRANCH MICROCODE PAGE - microcode ROM page that can be used as destination for microcode branches */
        
            /* RESET - Load PC with vector at $FFFC, and set I - should take 6 cycles */
            {UPAGE_BRANCH, USEQ_ADDR_RESET}: 
                // Clear C flag so that the next couple SBC operations do not involve carry (TODO is this not needed for ALU_IND???)
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_CLRBIT, ALU_A_P, C_BIT_IN_P, ALU_O_P, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_RESET + 8'd1}:
                // IND <= $FFFE [IND <= ($0000 - 2)]
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_SBC, ALU_A_ZERO, ALU_B_TWO, ALU_O_IND, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_RESET + 8'd2}:
                // IND <= $FFFC [IND <= (IND - 2)]
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_SBC, ALU_A_IND, ALU_B_TWO, ALU_O_IND, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_RESET + 8'd3}:
                // PCL <= (IND), IND <= IND + 1
                d <= {ADDR_IND, DATA_READ, DATA_PCL, ALU_OP_ADC, ALU_A_IND, ALU_B_ONE, ALU_O_IND, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_RESET + 8'd4}:
                // PCH <= (IND), Set I flag (disable interrupts)
                d <= {ADDR_IND, DATA_READ, DATA_PCH, ALU_OP_SETBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, PC_NOP, USEQ_IMM, USEQ_ADDR_FETCH};

            /* FETCH - Load OP with byte at (PC), increment PC, then decode opcode next */
            {UPAGE_BRANCH, USEQ_ADDR_FETCH}:
                // OP <= (PC), PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_OP, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_INC, USEQ_OP, USEQ_ADDR_NONE};

            /* IRQ - Read the next instruction byte, throw it away, increment PC, then do INT sequence*/
            {UPAGE_BRANCH, USEQ_ADDR_IRQ}:
                // PC <= PC + 1
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_INC, USEQ_IMM, USEQ_ADDR_INT};
                
            /* INT - push PC and P onto stack, then set I and fetch IRQ vector at ($FFFE) into PC */
            {UPAGE_BRANCH, USEQ_ADDR_INT}:
                // ($0100,S) <= PCH, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCH, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_INT + 8'd1}:
                // ($0100,S) <= PCL, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCL, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_INT + 8'd2}:
                // ($0100,S) <= P, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_P, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_INT + 8'd3}:
                // PCL <= ($FFFE)
                d <= {ADDR_ALU, DATA_READ, DATA_PCL, ALU_OP_SBC, ALU_A_ZERO, ALU_B_TWO, ALU_O_NULL, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_INT + 8'd4}:
                // PCH <= ($FFFF)
                d <= {ADDR_ALU, DATA_READ, DATA_PCH, ALU_OP_SBC, ALU_A_ZERO, ALU_B_ONE, ALU_O_NULL, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_INT + 8'd5}:
                // OP <= (PC), PC <= PC + 1, I <= 1
                d <= {ADDR_PC, DATA_READ, DATA_OP, ALU_OP_SETBIT, ALU_A_P, I_BIT_IN_P, ALU_O_P, PC_INC, USEQ_OP, USEQ_ADDR_NONE};

            /* NMI - push PC and P onto stack, then fetch NMI vector at ($FFFA) into PC */
            {UPAGE_BRANCH, USEQ_ADDR_NMI}:
                // ($0100,S) <= PCH, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCH, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_NMI + 8'd1}:
                // ($0100,S) <= PCL, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_PCL, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_NMI + 8'd2}:
                // ($0100,S) <= P, S <= S - 1
                d <= {ADDR_SP, DATA_WRITE, DATA_P, ALU_OP_SBC, ALU_A_S, ALU_B_ONE, ALU_O_S, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_NMI + 8'd3}:
                // IND <= $FFFF
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_SBC, ALU_A_ZERO, ALU_B_ONE, ALU_O_IND, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_NMI + 8'd4}:
                // PCH <= ($FFFB), IND <= $FFFB
                d <= {ADDR_ALU, DATA_READ, DATA_PCH, ALU_OP_CLRBIT, ALU_A_IND, 3'h2, ALU_O_IND, PC_NOP, USEQ_INC, USEQ_ADDR_NONE};
            {UPAGE_BRANCH, USEQ_ADDR_NMI + 8'd5}:
                // PCL <= ($FFFA)
                d <= {ADDR_ALU, DATA_READ, DATA_PCL, ALU_OP_CLRBIT, ALU_A_IND, 3'h0, ALU_O_NULL, PC_NOP, USEQ_IMM, USEQ_ADDR_FETCH};

            /* RTI - */
            //{UPAGE_BRANCH, USEQ_ADDR_RTI}:
                //

            /* HALT - Lock up the microsequencer until reset */
            {UPAGE_BRANCH, USEQ_ADDR_HALT}:
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_NOP, USEQ_IMM, USEQ_ADDR_HALT};



            /* OPCODE MICROCODE PAGE - Entry points for each opcode, using the opcode as ROM address within the page */
            
            {UPAGE_OP, BRK}:
                // Read the next instruction byte, throw it away, increment PC, set B flag, then do INT sequence
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_SETBIT, ALU_A_P, B_BIT_IN_P, ALU_O_P, PC_INC, USEQ_IMM, USEQ_ADDR_INT};
            {UPAGE_OP, RTI}:
                // Read the next instruction byte, throw it away, then do RTI sequence
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_NOP, USEQ_IMM, USEQ_ADDR_RTI};
            
            default: // Halt
                d <= {ADDR_PC, DATA_READ, DATA_NONE, ALU_OP_AND, ALU_A_ZERO, ALU_B_ZERO, ALU_O_NULL, PC_NOP, USEQ_IMM, USEQ_ADDR_HALT};
        endcase
    end
end


endmodule
