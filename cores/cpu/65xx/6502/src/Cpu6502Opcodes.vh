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

/* verilator lint_off UNUSED */

localparam BRK          = 8'h00;
localparam ORA_X_IND    = 8'h01;
localparam JAM_02       = 8'h02;
localparam SLO_X_IND    = 8'h03;
localparam NOP_ZPG_04   = 8'h04;
localparam ORA_ZPG      = 8'h05;
localparam ASL_ZPG      = 8'h06;
localparam SLO_ZPG      = 8'h07;
localparam PHP          = 8'h08;
localparam ORA_IMM      = 8'h09;
localparam ASL_A        = 8'h0A;
localparam ANC_IMM_0B   = 8'h0B;
localparam NOP_ABS_0C   = 8'h0C;
localparam ORA_ABS      = 8'h0D;
localparam ASL_ABS      = 8'h0E;
localparam SLO_ABS      = 8'h0F;
localparam BPL          = 8'h10;
localparam ORA_IND_Y    = 8'h11;
localparam JAM_12       = 8'h12;
localparam SLO_IND_Y    = 8'h13;
localparam NOP_ZPG_X_14 = 8'h14;
localparam ORA_ZPG_X    = 8'h15;
localparam ASL_ZPG_X    = 8'h16;
localparam SLO_ZPG_X    = 8'h17;
localparam CLC          = 8'h18;
localparam ORA_ABS_Y    = 8'h19;
localparam NOP_IPL_1A   = 8'h1A;
localparam SLO_ABS_Y    = 8'h1B;
localparam NOP_ABS_X_1C = 8'h1C;
localparam ORA_ABS_X    = 8'h1D;
localparam ASL_ABS_X    = 8'h1E;
localparam SLO_ABS_X    = 8'h1F;
localparam JSR          = 8'h20;
localparam AND_X_IND    = 8'h21;
localparam JAM_22       = 8'h22;
localparam RLA_X_IND    = 8'h23;
localparam BIT_ZPG      = 8'h24;
localparam AND_ZPG      = 8'h25;
localparam ROL_ZPG      = 8'h26;
localparam RLA_ZPG      = 8'h27;
localparam PLP          = 8'h28;
localparam AND_IMM      = 8'h29;
localparam ROL_A        = 8'h2A;
localparam ANC_IMM_2B   = 8'h2B;
localparam BIT_ABS      = 8'h2C;
localparam AND_ABS      = 8'h2D;
localparam ROL_ABS      = 8'h2E;
localparam RLA_ABS      = 8'h2F;
localparam BMI          = 8'h30;
localparam AND_IND_Y    = 8'h31;
localparam JAM_32       = 8'h32;
localparam RLA_IND_Y    = 8'h33;
localparam NOP_ZPG_X_34 = 8'h34;
localparam AND_ZPG_X    = 8'h35;
localparam ROL_ZPG_X    = 8'h36;
localparam RLA_ZPG_X    = 8'h37;
localparam SEC          = 8'h38;
localparam AND_ABS_Y    = 8'h39;
localparam NOP_IPL_3A   = 8'h3A;
localparam RLA_ABS_Y    = 8'h3B;
localparam NOP_ABS_X_3C = 8'h3C;
localparam AND_ABS_X    = 8'h3D;
localparam ROL_ABS_X    = 8'h3E;
localparam RLA_ABS_X    = 8'h3F;
localparam RTI          = 8'h40;
localparam EOR_X_IND    = 8'h41;
localparam JAM_42       = 8'h42;
localparam SRE_X_IND    = 8'h43;
localparam NOP_ZPG_44   = 8'h44;
localparam EOR_ZPG      = 8'h45;
localparam LSR_ZPG      = 8'h46;
localparam SRE_ZPG      = 8'h47;
localparam PHA          = 8'h48;
localparam EOR_IMM      = 8'h49;
localparam LSR_A        = 8'h4A;
localparam ALR_IMM      = 8'h4B;
localparam JMP_ABS      = 8'h4C;
localparam EOR_ABS      = 8'h4D;
localparam LSR_ABS      = 8'h4E;
localparam SRE_ABS      = 8'h4F;
localparam BVC          = 8'h50;
localparam EOR_IND_Y    = 8'h51;
localparam JAM_52       = 8'h52;
localparam SRE_IND_Y    = 8'h53;
localparam NOP_ZPG_X_54 = 8'h54;
localparam EOR_ZPG_X    = 8'h55;
localparam LSR_ZPG_X    = 8'h56;
localparam SRE_ZPG_X    = 8'h57;
localparam CLI          = 8'h58;
localparam EOR_ABS_Y    = 8'h59;
localparam NOP_IPL_5A   = 8'h5A;
localparam SRE_ABS_Y    = 8'h5B;
localparam NOP_ABS_X_5C = 8'h5C;
localparam EOR_ABS_X    = 8'h5D;
localparam LSR_ABS_X    = 8'h5E;
localparam SRE_ABS_X    = 8'h5F;
localparam RTS          = 8'h60;
localparam ADC_X_IND    = 8'h61;
localparam JAM_62       = 8'h62;
localparam RRA_X_IND    = 8'h63;
localparam NOP_ZPG_64   = 8'h64;
localparam ADC_ZPG      = 8'h65;
localparam ROR_ZPG      = 8'h66;
localparam RRA_ZPG      = 8'h67;
localparam PLA          = 8'h68;
localparam ADC_IMM      = 8'h69;
localparam ROR_A        = 8'h6A;
localparam ARR_IMM      = 8'h6B;
localparam JMP_IND      = 8'h6C;
localparam ADC_ABS      = 8'h6D;
localparam ROR_ABS      = 8'h6E;
localparam RRA_ABS      = 8'h6F;
localparam BVS          = 8'h70;
localparam ADC_IND_Y    = 8'h71;
localparam JAM_72       = 8'h72;
localparam RRA_IND_Y    = 8'h73;
localparam NOP_ZPG_X_74 = 8'h74;
localparam ADC_ZPG_X    = 8'h75;
localparam ROR_ZPG_X    = 8'h76;
localparam RRA_ZPG_X    = 8'h77;
localparam SEI          = 8'h78;
localparam ADC_ABS_Y    = 8'h79;
localparam NOP_IPL_7A   = 8'h7A;
localparam RRA_ABS_Y    = 8'h7B;
localparam NOP_ABS_X_7C = 8'h7C;
localparam ADC_ABS_X    = 8'h7D;
localparam ROR_ABS_X    = 8'h7E;
localparam RRA_ABS_X    = 8'h7F;
localparam NOP_IMM_80   = 8'h80;
localparam STA_X_IND    = 8'h81;
localparam NOP_IMM_82   = 8'h82;
localparam SAX_X_IND    = 8'h83;
localparam STY_ZPG      = 8'h84;
localparam STA_ZPG      = 8'h85;
localparam STX_ZPG      = 8'h86;
localparam SAX_ZPG      = 8'h87;
localparam DEY          = 8'h88;
localparam NOP_IMM_89   = 8'h89;
localparam TXA          = 8'h8A;
localparam ANE_IMM      = 8'h8B;
localparam STY_ABS      = 8'h8C;
localparam STA_ABS      = 8'h8D;
localparam STX_ABS      = 8'h8E;
localparam SAX_ABS      = 8'h8F;
localparam BCC          = 8'h90;
localparam STA_IND_Y    = 8'h91;
localparam JAM_92       = 8'h92;
localparam SHA_IND_Y    = 8'h93;
localparam STY_ZPG_X    = 8'h94;
localparam STA_ZPG_X    = 8'h95;
localparam STX_ZPG_Y    = 8'h96;
localparam SAX_ZPG_Y    = 8'h97;
localparam TYA          = 8'h98;
localparam STA_ABS_Y    = 8'h99;
localparam TXS          = 8'h9A;
localparam TAS_ABS_Y    = 8'h9B;
localparam SHY_ABS_X    = 8'h9C;
localparam STA_ABS_X    = 8'h9D;
localparam SHX_ABS_Y    = 8'h9E;
localparam SHA_ABS_Y    = 8'h9F;
localparam LDY_IMM      = 8'hA0;
localparam LDA_X_IND    = 8'hA1;
localparam LDX_IMM      = 8'hA2;
localparam LAX_X_IND    = 8'hA3;
localparam LDY_ZPG      = 8'hA4;
localparam LDA_ZPG      = 8'hA5;
localparam LDX_ZPG      = 8'hA6;
localparam LAX_ZPG      = 8'hA7;
localparam TAY          = 8'hA8;
localparam LDA_IMM      = 8'hA9;
localparam TAX          = 8'hAA;
localparam LAX_IMM      = 8'hAB;
localparam LDY_ABS      = 8'hAC;
localparam LDA_ABS      = 8'hAD;
localparam LDX_ABS      = 8'hAE;
localparam LAX_ABS      = 8'hAF;
localparam BCS          = 8'hB0;
localparam LDA_IND_Y    = 8'hB1;
localparam JAM_B2       = 8'hB2;
localparam LAX_IND_Y    = 8'hB3;
localparam LDY_ZPG_X    = 8'hB4;
localparam LDA_ZPG_X    = 8'hB5;
localparam LDX_ZPG_Y    = 8'hB6;
localparam LAX_ZPG_Y    = 8'hB7;
localparam CLV          = 8'hB8;
localparam LDA_ABS_Y    = 8'hB9;
localparam TSX          = 8'hBA;
localparam LAS_ABS_Y    = 8'hBB;
localparam LDY_ABS_X    = 8'hBC;
localparam LDA_ABS_X    = 8'hBD;
localparam LDX_ABS_Y    = 8'hBE;
localparam LAX_ABS_Y    = 8'hBF;
localparam CPY_IMM      = 8'hC0;
localparam CMP_X_IND    = 8'hC1;
localparam NOP_IMM_C2   = 8'hC2;
localparam DCP_X_IND    = 8'hC3;
localparam CPY_ZPG      = 8'hC4;
localparam CMP_ZPG      = 8'hC5;
localparam DEC_ZPG      = 8'hC6;
localparam DCP_ZPG      = 8'hC7;
localparam INY          = 8'hC8;
localparam CMP_IMM      = 8'hC9;
localparam DEX          = 8'hCA;
localparam SBX_IMM      = 8'hCB;
localparam CPY_ABS      = 8'hCC;
localparam CMP_ABS      = 8'hCD;
localparam DEC_ABS      = 8'hCE;
localparam DCP_ABS      = 8'hCF;
localparam BNE          = 8'hD0;
localparam CMP_IND_Y    = 8'hD1;
localparam JAM_D2       = 8'hD2;
localparam DCP_IND_Y    = 8'hD3;
localparam NOP_ZPG_X_D4 = 8'hD4;
localparam CMP_ZPG_X    = 8'hD5;
localparam DEC_ZPG_X    = 8'hD6;
localparam DCP_ZPG_X    = 8'hD7;
localparam CLD          = 8'hD8;
localparam CMP_ABS_Y    = 8'hD9;
localparam NOP_IPL_DA   = 8'hDA;
localparam DCP_ABS_Y    = 8'hDB;
localparam NOP_ABS_X_DC = 8'hDC;
localparam CMP_ABS_X    = 8'hDD;
localparam DEC_ABS_X    = 8'hDE;
localparam DCP_ABS_X    = 8'hDF;
localparam CPX_IMM      = 8'hE0;
localparam SBC_X_IND    = 8'hE1;
localparam NOP_IMM_E2   = 8'hE2;
localparam ISC_X_IND    = 8'hE3;
localparam CPX_ZPG      = 8'hE4;
localparam SBC_ZPG      = 8'hE5;
localparam INC_ZPG      = 8'hE6;
localparam ISC_ZPG      = 8'hE7;
localparam INX          = 8'hE8;
localparam SBC_IMM      = 8'hE9;
localparam NOP          = 8'hEA;
localparam SBC_IMM_EB   = 8'hEB;
localparam CPX_ABS      = 8'hEC;
localparam SBC_ABS      = 8'hED;
localparam INC_ABS      = 8'hEE;
localparam ISC_ABS      = 8'hEF;
localparam BEQ          = 8'hF0;
localparam SBC_IND_Y    = 8'hF1;
localparam JAM_F2       = 8'hF2;
localparam ISC_IND_Y    = 8'hF3;
localparam NOP_ZPG_X_F4 = 8'hF4;
localparam SBC_ZPG_X    = 8'hF5;
localparam INC_ZPG_X    = 8'hF6;
localparam ISC_ZPG_X    = 8'hF7;
localparam SED          = 8'hF8;
localparam SBC_ABS_Y    = 8'hF9;
localparam NOP_IPL_FA   = 8'hFA;
localparam ISC_ABS_Y    = 8'hFB;
localparam NOP_ABS_X_FC = 8'hFC;
localparam SBC_ABS_X    = 8'hFD;
localparam INC_ABS_X    = 8'hFE;
localparam ISC_ABS_X    = 8'hFF;

/* verilator lint_on UNUSED */

`endif //__CPU6502OPCODES_VH_
