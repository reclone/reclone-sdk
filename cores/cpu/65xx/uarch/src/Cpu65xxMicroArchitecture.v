//
// Cpu65xxMicroArchitecture - Microarchitecture shared by 6502, 6507, 6510, etc. CPU cores
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

`include "Cpu65xxMicrocodeConstants.vh"

module Cpu65xxMicroArchitecture
(
    input clock,
    input enable,
    input reset,

    input wire [7:0] dataIn,
    output wire [7:0] dataOut,
    output wire nWrite,
    output wire [15:0] address,

    input wire nNMI,
    input wire nIRQ,
    input wire nRESET,

    // Microcode ROM interface
    output wire [9:0] uCodeAddress,
    input wire [1:0]  uCodeAddrBusMux,
    input wire        uCodeDataWriteEnable,
    input wire [1:0]  uCodeDataBusMux,
    input wire [3:0]  uCodeAluOperation,
    input wire [3:0]  uCodeAluOperandAMux,
    input wire [2:0]  uCodeAluOperandBMuxOrOpExtension,
    input wire [3:0]  uCodeAluResultStorage,
    input wire        uCodeIncrementAddr,
    input wire        uSeqBranchCondition,
    input wire [9:0]  uSeqBranchAddr
);

// Initial values of PC and S selected to match perfect6502
reg [15:0]  regPC = 16'h00FF;
reg [15:0]  regIND = 16'hFFFF;
reg [7:0]   regZPG = 8'hFF;
reg [7:0]   regIMM = 8'hFF;
reg [7:0]   regS = 8'hC0;
reg [7:0]   regP = 8'h00;
reg [7:0]   regA = 8'h00;
reg [7:0]   regX = 8'h00;
reg [7:0]   regY = 8'h00;
reg lastNMI = 1'b1;
reg latchedNMI = 1'b1;
reg latchedIRQ = 1'b1;
reg latchedRESET = 1'b0;
reg [9:0] uCodeAddressLast = 10'd0;
reg [7:0] unstableConst = 8'h00;

wire [7:0] aluOperandA;
wire [7:0] aluOperandB;
wire [7:0] aluResult;
wire aluCarryOut;
wire aluOverflowOut;
wire aluZero;
wire aluNegative;
wire aluBranchCondition;
wire aluCarryIn = regP[C_BIT_IN_P];
wire aluOverflowIn = regP[V_BIT_IN_P];
wire aluDecimalMode = regP[D_BIT_IN_P];
wire aluStoreFlags = uCodeAluOperandBMuxOrOpExtension[0];

// ALU Operand A multiplexer
always @ (*) begin
    case (uCodeAluOperandAMux)
        ALU_A_PCL:      aluOperandA = regPC[7:0];
        ALU_A_INDL:     aluOperandA = regIND[7:0];
        ALU_A_S:        aluOperandA = regS;
        ALU_A_IMM:      aluOperandA = regIMM;
        ALU_A_PCH:      aluOperandA = regPC[15:8];
        ALU_A_INDH:     aluOperandA = regIND[15:8];
        ALU_A_DI:       aluOperandA = dataIn;
        ALU_A_P:        aluOperandA = regP | (8'd1 << R_BIT_IN_P); // reserved bit always 1
        ALU_A_A:        aluOperandA = regA;
        ALU_A_X:        aluOperandA = regX;
        ALU_A_Y:        aluOperandA = regY;
        ALU_A_ZPG:      aluOperandA = regZPG;
        ALU_A_ZERO:     aluOperandA = 8'h00;
        ALU_A_FB:       aluOperandA = 8'hFB;
        ALU_A_FD:       aluOperandA = 8'hFD;
        ALU_A_FF:       aluOperandA = 8'hFF;
        default:        aluOperandA = 8'h00;
    endcase
end

// ALU Operand B multiplexer
always @ (*) begin
    case (uCodeAluOperandBMuxOrOpExtension)
        ALU_B_ZERO, ALU_B_ZERO_FLG: aluOperandB = 8'h00;
        ALU_B_DI, ALU_B_DI_FLG:     aluOperandB = dataIn;
        ALU_B_IMM, ALU_B_IMM_FLG:   aluOperandB = regIMM;
        ALU_B_A_UNSTABLE:           aluOperandB = regA | unstableConst;
        ALU_B_FF_FLG:               aluOperandB = 8'hFF;
        default:                    aluOperandB = 8'h00;
    endcase
end

Cpu65xxAlu alu
(
    .operandA(aluOperandA),
    .operandB(aluOperandB),
    .carryIn(aluCarryIn),
    .overflowIn(aluOverflowIn),
    .operation(uCodeAluOperation),
    .opExtension(uCodeAluOperandBMuxOrOpExtension),
    .decimalMode(aluDecimalMode),
    .result(aluResult),
    .carryOut(aluCarryOut),
    .zero(aluZero),
    .negative(aluNegative),
    .overflowOut(aluOverflowOut),
    .branchCondition(aluBranchCondition)
);


// Address bus multiplexer
always @ (*) begin
    if (uCodeAluResultStorage == ALU_O_ADDR) begin
        address = {aluOperandB, aluResult};
    end else begin
        case (uCodeAddrBusMux)
            ADDR_PC:    address = regPC;
            ADDR_SP:    address = {8'h01, regS};
            ADDR_IND:   address = regIND;
            ADDR_ZPG:   address = {8'h0, regZPG};
            default:    address = 16'hFFFF;
        endcase
    end
end

// Data write multiplexer
always @ (*) begin
    if (uCodeAluResultStorage == ALU_O_DO) begin
        dataOut = aluResult;
    end else begin
        case (uCodeDataBusMux)
            DATA_NULL:  dataOut = 8'h00;
            DATA_IMM:   dataOut = regIMM;
            DATA_PCL:   dataOut = regPC[7:0];
            DATA_PCH:   dataOut = regPC[15:8];
            default:    dataOut = 8'hFF;
        endcase
    end
end
assign nWrite = uCodeDataWriteEnable;

// Microcode address
always @ (*) begin
    if (!nRESET || !latchedRESET) begin
        // Proceed immediately to reset vector
        uCodeAddress = USEQ_ADDR_RESET;
    end else if (uSeqBranchAddr[9] == UPAGE_OP && uSeqBranchAddr[0] == 1'b0) begin
        if (!latchedNMI || (lastNMI && !nNMI)) begin
            // Proceed to NMI vector
            uCodeAddress = USEQ_ADDR_NMI;
        end else if (!latchedIRQ || (!nIRQ && !regP[I_BIT_IN_P])) begin
            // Proceed to IRQ vector
            uCodeAddress = USEQ_ADDR_IRQ;
        end else begin
            // Use the new opcode on dataIn to form the new address
            uCodeAddress = {UPAGE_OP, dataIn, 1'b0};
        end
    end else begin
        if (uSeqBranchCondition == aluBranchCondition) begin
            // Branch conditions match, so set uCodeAddress to the branch address
            uCodeAddress = uSeqBranchAddr;
        end else begin
            // Branch conditions do not match, so increment uCodeAddress
            uCodeAddress = uCodeAddressLast + 10'd1;
        end
    end
end

// Address/Data bus accesses occur on positive edges, but CPU microinstructions
// execute on negative edges, so that a microinstruction can set up the address
// and also use the data within the same cycle.
always @ (negedge clock or posedge reset) begin
    if (reset) begin
        regPC <= 16'h00FF;
        regIND <= 16'hFFFF;
        regZPG <= 8'hFF;
        regS <= 8'hC0;
        regP <= 8'h00;
        regA <= 8'h00;
        regIMM <= 8'h00;
        regX <= 8'h00;
        regY <= 8'h00;
        lastNMI <= 1'b1;
        latchedNMI <= 1'b1;
        latchedIRQ <= 1'b1;
        latchedRESET <= 1'b0;
        uCodeAddressLast <= USEQ_ADDR_RESET;
        unstableConst <= 8'h00;
    end else if (enable) begin

        // Update PC
        if (uCodeIncrementAddr && uCodeAddrBusMux == ADDR_PC)
            regPC <= regPC + 16'd1;
        else begin
            // Update PCL
            if (nWrite && uCodeDataBusMux == DATA_PCL)
                regPC[7:0] <= dataIn;
            else if (uCodeAluResultStorage == ALU_O_PCL)
                regPC[7:0] <= aluResult;
            
            // Update PCH
            if (nWrite && uCodeDataBusMux == DATA_PCH)
                regPC[15:8] <= dataIn;
            else if (uCodeAluResultStorage == ALU_O_PCH)
                regPC[15:8] <= aluResult;
        end
        
        // Update accumulator register A
        if (uCodeAluResultStorage == ALU_O_A || uCodeAluResultStorage == ALU_O_A_X)
            regA <= aluResult;
        
        // Update index register X
        if (uCodeAluResultStorage == ALU_O_X || uCodeAluResultStorage == ALU_O_A_X)
            regX <= aluResult;
        
        // Update index register Y
        if (uCodeAluResultStorage == ALU_O_Y)
            regY <= aluResult;
        
        // Update status register P
        if (uCodeAluResultStorage == ALU_O_P)
            regP <= aluResult;
        else if (aluStoreFlags && uCodeAluOperation != ALU_OP_SETBIT && uCodeAluOperation != ALU_OP_CLRBIT) begin
            regP[C_BIT_IN_P] <= aluCarryOut;
            regP[V_BIT_IN_P] <= aluOverflowOut;
            regP[Z_BIT_IN_P] <= aluZero;
            regP[N_BIT_IN_P] <= aluNegative;
        end
        
        // Update stack pointer register S
        if (uCodeIncrementAddr && uCodeAddrBusMux == ADDR_SP && nWrite)
            // Pop from stack increments the stack pointer
            regS <= regS + 8'd1;
        else if (uCodeIncrementAddr && uCodeAddrBusMux == ADDR_SP && !nWrite)
            // Push onto stack decrements the stack pointer
            regS <= regS - 8'd1;
        if (uCodeAluResultStorage == ALU_O_S)
            regS <= aluResult;
        
        // Update indirect register IND
        if (uCodeIncrementAddr && uCodeAddrBusMux == ADDR_IND)
            regIND <= regIND + 16'd1;
        else begin
            if (uCodeAluResultStorage == ALU_O_INDL)
                regIND[7:0] <= aluResult;
            if (uCodeAluResultStorage == ALU_O_INDH)
                regIND[15:8] <= aluResult;
        end
        
        // Update zero page register ZPG
        if (uCodeIncrementAddr && uCodeAddrBusMux == ADDR_ZPG)
            regZPG <= regZPG + 8'd1;
        else begin
            if (uCodeAluResultStorage == ALU_O_ZPG)
                regZPG <= aluResult;
        end
        
        // Update immediate/index register IMM
        if (uCodeAluResultStorage == ALU_O_IMM)
            regIMM <= aluResult;
        else if (nWrite && uCodeDataBusMux == DATA_IMM)
            regIMM <= dataIn;
        
        // Update unstable constant value when there is a new opcode
        // This constant is OR'd with A in specific undocumented opcodes
        // Values were chosen in an attempt to maximize compatibility with known games that use these opcodes
        if (uSeqBranchAddr[9] == UPAGE_OP && uSeqBranchAddr[0] == 1'b0) begin
            if (dataIn == ANE_IMM) begin
                unstableConst <= 8'hEF;
            end else if (dataIn == LAX_IMM) begin
                unstableConst <= 8'hEE;
            end else begin
                unstableConst <= 8'h00;
            end
        end
        
        // Handle latched flags
        if (!nRESET || !latchedRESET) begin
            // Proceed immediately to reset vector
            latchedRESET <= 1'b1;
        end else if (uSeqBranchAddr[9] == UPAGE_OP && uSeqBranchAddr[0] == 1'b0) begin

            if (!latchedNMI || (lastNMI && !nNMI)) begin
                // Proceed to NMI vector
                latchedNMI <= 1'b1;
            end else if (!latchedIRQ || (!nIRQ && !regP[I_BIT_IN_P])) begin
                // Proceed to IRQ vector
                latchedIRQ <= 1'b1;
            end

        end else begin

            // Detect falling edge on nNMI
            if (lastNMI && !nNMI) begin
                latchedNMI <= 1'b0;
            end

            // Latch low level on nIRQ, if interrupt disable I bit is clear (0)
            if (!nIRQ && !regP[I_BIT_IN_P]) begin
                latchedIRQ <= 1'b0;
            end

        end
        lastNMI <= nNMI;
        uCodeAddressLast <= uCodeAddress;
    end
end

endmodule
