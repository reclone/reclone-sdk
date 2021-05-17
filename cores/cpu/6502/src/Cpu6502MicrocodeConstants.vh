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
localparam ADDR_PC          = 3'h0;
localparam ADDR_SP          = 3'h1;
localparam ADDR_ALU         = 3'h2;
localparam ADDR_IND         = 3'h3;

// Data bus read/write
localparam DATA_READ        = 1'b0;
localparam DATA_WRITE       = 1'b1;

// Data bus mux selector
localparam DATA_NONE        = 4'h0;
localparam DATA_OP          = 4'h1;
localparam DATA_PCL         = 4'h2;
localparam DATA_PCH         = 4'h3;
localparam DATA_P           = 4'h4;

// ALU Operations
localparam ALU_OP_SBC       = 3'h0;
localparam ALU_OP_ADC       = 3'h1;
localparam ALU_OP_AND       = 3'h2;
localparam ALU_OP_OR        = 3'h3;
localparam ALU_OP_EOR       = 3'h4;
localparam ALU_OP_ROR       = 3'h5;
localparam ALU_OP_SETBIT    = 3'h6;
localparam ALU_OP_CLRBIT    = 3'h7;

// ALU Operand A Sources
localparam ALU_A_ZERO       = 4'h0;
localparam ALU_A_DI         = 4'h2;
localparam ALU_A_P          = 4'h3;
localparam ALU_A_A          = 4'h4;
localparam ALU_A_X          = 4'h5;
localparam ALU_A_Y          = 4'h6;
localparam ALU_A_S          = 4'h7;
localparam ALU_A_PC         = 4'h8;
localparam ALU_A_IND        = 4'h9;

// ALU Operand B Sources
localparam ALU_B_ZERO       = 3'h0;
localparam ALU_B_ONE        = 3'h1;
localparam ALU_B_TWO        = 3'h2;

// Bit positions (used as Operand B for ALU_OP_SETBIT and ALU_OP_CLRBIT)
localparam C_BIT_IN_P       = 3'h0;
localparam I_BIT_IN_P       = 3'h2;
localparam B_BIT_IN_P       = 3'h4;

// ALU Result Storage
localparam ALU_O_NULL       = 3'h0;
localparam ALU_O_PC         = 3'h1;
localparam ALU_O_P          = 3'h2;
localparam ALU_O_IND        = 3'h3;
localparam ALU_O_S          = 3'h4;

// Whether to increment the Program Counter (PC)
localparam PC_INC           = 1'b1;
localparam PC_NOP           = 1'b0;

// Microsequencer branch mode
localparam USEQ_INC         = 2'd0;
localparam USEQ_OP          = 2'd1;
localparam USEQ_IMM         = 2'd2;
localparam USEQ_COND        = 2'd3;

// Microsequencer branch addresses
localparam USEQ_ADDR_RESET  = 8'h00;
localparam USEQ_ADDR_FETCH  = 8'h05;
localparam USEQ_ADDR_IRQ    = 8'h06;
localparam USEQ_ADDR_INT    = 8'h07;
localparam USEQ_ADDR_NMI    = 8'h0D;
localparam USEQ_ADDR_RTI    = 8'h13;
localparam USEQ_ADDR_NONE   = 8'hFF;
localparam USEQ_ADDR_HALT   = 8'hFF;

// Microcode pages
localparam UPAGE_BRANCH     = 1'b0;
localparam UPAGE_OP         = 1'b1;

`endif //__CPU6502MICROCODECONSTANTS_VH_
