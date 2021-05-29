//
// 6502MicrocodeConstants - Constants used to build 6502 microinstruction words
//
// A 32-bit microinstruction provides CPU control signals that drive what the CPU does on each
// 6502 clock cycle.
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

`ifndef __CPU6502MICROCODECONSTANTS_VH_
`define __CPU6502MICROCODECONSTANTS_VH_

// Address bus mux selector
localparam ADDR_PC          = 2'h0; // addr <= PC
localparam ADDR_SP          = 2'h1; // addr <= {$01, SP}
localparam ADDR_IND         = 2'h2; // addr <= {INDH, INDL}
localparam ADDR_ZPG         = 2'h3; // addr <= {$00, ZPG}

// Data bus read/write
localparam DATA_READ        = 1'b1;
localparam DATA_WRITE       = 1'b0;

// Data bus mux selector
localparam DATA_NULL        = 2'h0;
localparam DATA_IMM         = 2'h1;
localparam DATA_PCL         = 2'h2;
localparam DATA_PCH         = 2'h3;

// ALU Operations
localparam ALU_OP_SBC       = 4'h0;
localparam ALU_OP_ADC       = 4'h1;
localparam ALU_OP_AND       = 4'h2;
localparam ALU_OP_BIT       = 4'h3;
localparam ALU_OP_RADD      = 4'h4;
localparam ALU_OP_CMP       = 4'h5;
localparam ALU_OP_IADD      = 4'h6;
localparam ALU_OP_OR        = 4'h7;
localparam ALU_OP_EOR       = 4'h8;
localparam ALU_OP_COPY      = 4'h9;
localparam ALU_OP_INC       = 4'hA;
localparam ALU_OP_DEC       = 4'hB;
localparam ALU_OP_FIXUP     = 4'hC;
localparam ALU_OP_SGL       = 4'hD; // Single operand - Operand B is the operation
localparam ALU_OP_SETBIT    = 4'hE; // Set single bit - Operand B is bit position
localparam ALU_OP_CLRBIT    = 4'hF; // Clear single bit - Operand B is bit position

// ALU Operand A Sources
localparam ALU_A_PCL        = 4'h0;
localparam ALU_A_INDL       = 4'h1;
localparam ALU_A_S          = 4'h2;
localparam ALU_A_IMM        = 4'h3;
localparam ALU_A_PCH        = 4'h4;
localparam ALU_A_INDH       = 4'h5;
localparam ALU_A_DI         = 4'h6;
localparam ALU_A_P          = 4'h7;
localparam ALU_A_A          = 4'h8;
localparam ALU_A_X          = 4'h9;
localparam ALU_A_Y          = 4'hA;
localparam ALU_A_ZPG        = 4'hB;
localparam ALU_A_ZERO       = 4'hC;
localparam ALU_A_FB         = 4'hD;
localparam ALU_A_FD         = 4'hE;
localparam ALU_A_FF         = 4'hF;

// ALU Operand B Sources
// Low bit: whether to save resulting flags to P
localparam ALU_B_ZERO       = 3'h0;
localparam ALU_B_ZERO_FLG   = 3'h1;
localparam ALU_B_DI         = 3'h2;
localparam ALU_B_DI_FLG     = 3'h3;
localparam ALU_B_IMM        = 3'h4;
localparam ALU_B_IMM_FLG    = 3'h5;
localparam ALU_B_FF         = 3'h6;
localparam ALU_B_FF_FLG     = 3'h7;

// Bit positions (used as Operand B for ALU_OP_SETBIT and ALU_OP_CLRBIT)
// Never save resulting flags to P for ALU_OP_SETBIT or ALU_OP_CLRBIT
localparam C_BIT_IN_P       = 3'h0;
localparam Z_BIT_IN_P       = 3'h1;
localparam I_BIT_IN_P       = 3'h2;
localparam D_BIT_IN_P       = 3'h3;
localparam B_BIT_IN_P       = 3'h4;
localparam V_BIT_IN_P       = 3'h6;
localparam N_BIT_IN_P       = 3'h7;

// Single-operand operations (used as Operand B for ALU_OP_SGL)
// Low bit: whether to save resulting flags to P
localparam ALU_SOP_TEST_N   = 3'h0; // Never save flags to P
localparam ALU_SOP_TEST_C   = 3'h2; // "
localparam ALU_SOP_TEST_V   = 3'h4; // "
localparam ALU_SOP_TEST_Z   = 3'h6; // "
localparam ALU_SOP_ASL      = 3'h1; // Always save flags to P
localparam ALU_SOP_LSR      = 3'h3; // "
localparam ALU_SOP_ROL      = 3'h5; // "
localparam ALU_SOP_ROR      = 3'h7; // "

// ALU Output Storage
localparam ALU_O_NULL       = 4'h0;
localparam ALU_O_PCH        = 4'h1;
localparam ALU_O_PCL        = 4'h2;
localparam ALU_O_A          = 4'h3;
localparam ALU_O_S          = 4'h4;
localparam ALU_O_X          = 4'h5;
localparam ALU_O_Y          = 4'h6;
localparam ALU_O_P          = 4'h7;
localparam ALU_O_INDL       = 4'h8;
localparam ALU_O_INDH       = 4'h9;
localparam ALU_O_IMM        = 4'hA;
localparam ALU_O_DO         = 4'hB;
localparam ALU_O_ADDR       = 4'hC; // addr <= {aluOperandB, aluResult}
localparam ALU_O_ZPG        = 4'hD;

// Whether to increment the register selected on the address mux,
// i.e. PC, ZPG, or IND
localparam ADDR_INC         = 1'b1;
localparam ADDR_NOP         = 1'b0;

// Opcode table - contains the first two microinstructions of each opcode
// First bit of the microcode address
localparam UPAGE_OP         = 1'b1;

// Special address to tell the microsequencer to use
// the new opcode as an address within UPAGE_OP
localparam USEQ_OP          = {UPAGE_OP, 9'h0};

// Microsequencer branch condition polarity
// Use ALU_OP_SGL:ALU_A_P:ALU_SOP_TEST_* to set which flag in P to check,
// or do a 16-bit addition (which determines whether a page boundary is crossed),
// then use USEQ_BR_* as the high bit of the branch address to specify polarity.
localparam USEQ_BR_IF_CLR   = 1'b0; // Branch if flag is clear (0) or no page boundary crossed
localparam USEQ_BR_IF_SET   = 1'b1; // Branch if flag is set (1) or page boundary is crossed

// Microsequencer branch addresses for reset and interrupts
localparam USEQ_ADDR_RESET  = 10'h000;
localparam USEQ_ADDR_IRQ    = 10'h008;
localparam USEQ_ADDR_NMI    = 10'h010;

`endif //__CPU6502MICROCODECONSTANTS_VH_
