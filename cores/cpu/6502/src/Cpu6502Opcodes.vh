//
// Cpu6502Opcodes - Definitions of all defined opcode values of the original MOS 6502 microprocessor
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

`ifndef __CPU6502OPCODES_VH_
`define __CPU6502OPCODES_VH_

`define BRK         8'h00
`define ORA_X_IND   8'h01
`define ORA_ZPG     8'h05
`define ASL_ZPG     8'h06
`define PHP         8'h08
`define ORA_IMM     8'h09
`define ASL_A       8'h0A
`define ORA_ABS     8'h0D
`define ASL_ABS     8'h0E
`define BPL         8'h10
`define ORA_IND_Y   8'h11
`define ORA_ZPG_X   8'h15
`define ASL_ZPG_X   8'h16
`define CLC         8'h18
`define ORA_ABS_Y   8'h19
`define ORA_ABS_X   8'h1D
`define ASL_ABS_X   8'h1E
`define JSR         8'h20
`define AND_X_IND   8'h21
`define BIT_ZPG     8'h24
`define AND_ZPG     8'h25
`define ROL_ZPG     8'h26
`define PLP         8'h28
`define AND_IMM     8'h29
`define ROL_A       8'h2A
`define BIT_ABS     8'h2C
`define AND_ABS     8'h2D
`define ROL_ABS     8'h2E
`define BMI         8'h30
`define AND_IND_Y   8'h31
`define AND_ZPG_X   8'h35
`define ROL_ZPG_X   8'h36
`define SEC         8'h38
`define AND_ABS_Y   8'h39
`define AND_ABS_X   8'h3D
`define ROL_ABS_X   8'h3E
`define RTI         8'h40
`define EOR_X_IND   8'h41
`define EOR_ZPG     8'h45
`define LSR_ZPG     8'h46
`define PHA         8'h48
`define EOR_IMM     8'h49
`define LSR_A       8'h4A
`define JMP_ABS     8'h4C
`define EOR_ABS     8'h4D
`define LSR_ABS     8'h4E
`define BVC         8'h50
`define EOR_IND_Y   8'h51
`define EOR_ZPG_X   8'h55
`define LSR_ZPG_X   8'h56
`define CLI         8'h58
`define EOR_ABS_Y   8'h59
`define EOR_ABS_X   8'h5D
`define LSR_ABS_X   8'h5E
`define RTS         8'h60
`define ADC_X_IND   8'h61
`define ADC_ZPG     8'h65
`define ROR_ZPG     8'h66
`define PLA         8'h68
`define ADC_IMM     8'h69
`define ROR_A       8'h6A
`define JMP_IND     8'h6C
`define ADC_ABS     8'h6D
`define ROR_ABS     8'h6E
`define BVS         8'h70
`define ADC_IND_Y   8'h71
`define ADC_ZPG_X   8'h75
`define ROR_ZPG_X   8'h76
`define SEI         8'h78
`define ADC_ABS_Y   8'h79
`define ADC_ABS_X   8'h7D
`define ROR_ABS_X   8'h7E
`define STA_X_IND   8'h81
`define STY_ZPG     8'h84
`define STA_ZPG     8'h85
`define STX_ZPG     8'h86
`define DEY         8'h88
`define TXA         8'h8A
`define STY_ABS     8'h8C
`define STA_ABS     8'h8D
`define STX_ABS     8'h8E
`define BCC         8'h90
`define STA_IND_Y   8'h91
`define STY_ZPG_X   8'h94
`define STA_ZPG_X   8'h95
`define STX_ZPG_Y   8'h96
`define TYA         8'h98
`define STA_ABS_Y   8'h99
`define TXS         8'h9A
`define STA_ABS_X   8'h9D
`define LDY_IMM     8'hA0
`define LDA_X_IND   8'hA1
`define LDX_IMM     8'hA2
`define LDY_ZPG     8'hA4
`define LDA_ZPG     8'hA5
`define LDX_ZPG     8'hA6
`define TAY         8'hA8
`define LDA_IMM     8'hA9
`define TAX         8'hAA
`define LDY_ABS     8'hAC
`define LDA_ABS     8'hAD
`define LDX_ABS     8'hAE
`define BCS         8'hB0
`define LDA_IND_Y   8'hB1
`define LDY_ZPG_X   8'hB4
`define LDA_ZPG_X   8'hB5
`define LDX_ZPG_Y   8'hB6
`define CLV         8'hB8
`define LDA_ABS_Y   8'hB9
`define TSX         8'hBA
`define LDY_ABS_X   8'hBC
`define LDA_ABS_X   8'hBD
`define LDX_ABS_Y   8'hBE
`define CPY_IMM     8'hC0
`define CMP_X_IND   8'hC1
`define CPY_ZPG     8'hC4
`define CMP_ZPG     8'hC5
`define DEC_ZPG     8'hC6
`define INY         8'hC8
`define CMP_IMM     8'hC9
`define DEX         8'hCA
`define CPY_ABS     8'hCC
`define CMP_ABS     8'hCD
`define DEC_ABS     8'hCE
`define BNE         8'hD0
`define CMP_IND_Y   8'hD1
`define CMP_ZPG_X   8'hD5
`define DEC_ZPG_X   8'hD6
`define CLD         8'hD8
`define CMP_ABS_Y   8'hD9
`define CMP_ABS_X   8'hDD
`define DEC_ABS_X   8'hDE
`define CPX_IMM     8'hE0
`define SBC_X_IND   8'hE1
`define CPX_ZPG     8'hE4
`define SBC_ZPG     8'hE5
`define INC_ZPG     8'hE6
`define INX         8'hE8
`define SBC_IMM     8'hE9
`define NOP         8'hEA
`define CPX_ABS     8'hEC
`define SBC_ABS     8'hED
`define INC_ABS     8'hEE
`define BEQ         8'hF0
`define SBC_IND_Y   8'hF1
`define SBC_ZPG_X   8'hF5
`define INC_ZPG_X   8'hF6
`define SED         8'hF8
`define SBC_ABS_Y   8'hF9
`define SBC_ABS_X   8'hFD
`define INC_ABS_X   8'hFE

`endif //__CPU6502OPCODES_VH_