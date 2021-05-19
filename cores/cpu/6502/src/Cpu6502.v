//
// Cpu6502 - Top-level module for a 6502 work-alike CPU
//
// This top-level module is responsible for performing memory and register accesses,
// handling interrupts and reset, and integrating the lower-level ALU, addressing, and
// opcode decoding modules.  This CPU attempts to be cycle-accurate to the MOS 6502, and does NOT
// require a higher-speed clock (e.g. to execute microcode or perform in-time memory accesses).
// All stable undocumented opcodes are implemented accurately, with possible unavoidable 
// inaccuracies in the 'unstable' or 'kill' opcodes.
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

`include "Cpu6502MicrocodeConstants.vh"
`include "Cpu6502Opcodes.vh"

/* verilator lint_off UNUSED */

module Cpu6502
(
    input clock,
    input enable,
    input reset,

    input wire [7:0] dataIn,
    output wire [7:0] dataOut,
    output wire dataWriteEnable,
    output wire [15:0] address,

    input wire nNMI,
    input wire nIRQ
);

wire [1:0]  addrBusMux;
wire [3:0]  dataBusMux;
wire [2:0]  aluOperation;
wire [3:0]  aluOperandAMux;
wire [2:0]  aluOperandBMuxOrOpExtension;
wire [2:0]  aluResultStorage;
wire        incrementPC;
wire        uSeqBranchCondition;
wire [9:0]  uSeqBranchAddr;

reg [9:0]   uCodeAddress = USEQ_ADDR_RESET;

reg [15:0]  regPC = 16'hFFFF;
reg [15:0]  regIND = 16'hFFFF;
reg [7:0]   regIDX = 8'hFF;
reg [7:0]   regS = 8'hFF;
reg [7:0]   regOP = NOP;
reg [7:0]   regP = 8'h00;
reg [7:0]   regA = 8'h00;
reg [7:0]   regX = 8'h00;
reg [7:0]   regY = 8'h00;

Cpu6502MicrocodeRom microcode
(
    .clock(clock),
    .enable(enable),
    .address(uCodeAddress),
    .addrBusMux(addrBusMux),
    .dataBusWriteEnable(dataWriteEnable),
    .dataBusMux(dataBusMux),
    .aluOperation(aluOperation),
    .aluOperandA(aluOperandAMux),
    .aluOperandB(aluOperandBMuxOrOpExtension),
    .aluResultStorage(aluResultStorage),
    .incrementPC(incrementPC),
    .uSeqBranchCondition(uSeqBranchCondition),
    .uSeqBranchAddr(uSeqBranchAddr)
);


wire [7:0] aluOperandA;
wire [7:0] aluOperandB;
wire [7:0] aluResult;
wire aluCarryOut;
wire aluOverflowOut;
wire aluZero;
wire aluNegative;
wire aluBranchCondition;
wire isAddressCalculation = 1'b0; //TODO expression for address calculations
wire aluCarryIn = isAddressCalculation ? 1'b0 : regP[C_BIT_IN_P];
wire aluOverflowIn = regP[V_BIT_IN_P];
wire aluDecimalMode = isAddressCalculation ? 1'b0 : regP[D_BIT_IN_P];
wire aluStoreFlags = aluOperandBMuxOrOpExtension[0];

// ALU Operand A multiplexer
// Do not allow P in if operation is ADC or SBC, as it can form a logic loop with overflow/carry
always @ (*) begin
    case (aluOperandAMux)
        ALU_A_PCL:      aluOperandA = regPC[7:0];
        ALU_A_INDL:     aluOperandA = regIND[7:0];
        ALU_A_S:        aluOperandA = regS;
        ALU_A_IDX:      aluOperandA = regIDX;
        ALU_A_PCH:      aluOperandA = regPC[15:8];
        ALU_A_INDH:     aluOperandA = regIND[15:8];
        ALU_A_DI:       aluOperandA = dataIn;
        ALU_A_P:        aluOperandA = regP;
        ALU_A_A:        aluOperandA = regA;
        ALU_A_X:        aluOperandA = regX;
        ALU_A_Y:        aluOperandA = regY;
        ALU_A_ZERO:     aluOperandA = 8'h00;
        ALU_A_FE:       aluOperandA = 8'hFE;
        ALU_A_FF:       aluOperandA = 8'hFF;
        default:        aluOperandA = 8'h00;
    endcase
end

// ALU Operand B multiplexer
always @ (*) begin
    case (aluOperandBMuxOrOpExtension)
        ALU_B_ZERO:     aluOperandB = 8'h00;
        ALU_B_ONE:      aluOperandB = 8'h01;
        default:        aluOperandB = 8'h00;
    endcase
end

Cpu6502Alu alu
(
    .operandA(aluOperandA),
    .operandB(aluOperandB),
    .carryIn(aluCarryIn),
    .overflowIn(aluOverflowIn),
    .operation(aluOperation),
    .opExtension(aluOperandBMuxOrOpExtension),
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
    case (addrBusMux)
        ADDR_PC:    address = regPC;
        ADDR_SP:    address = {8'h01, regS};
        ADDR_IND:   address = regIND;
        ADDR_VEC:   address = {8'hFF, aluResult};
        default:    address = 16'hFFFF;
    endcase
end

// Data write multiplexer
always @ (*) begin
    case (dataBusMux)
        DATA_NULL:  dataOut = 8'h00;
        DATA_OP:    dataOut = regOP;
        DATA_PCL:   dataOut = regPC[7:0];
        DATA_PCH:   dataOut = regPC[15:8];
        DATA_P:     dataOut = regP;
        DATA_A:     dataOut = regA;
        DATA_INDL:  dataOut = regIND[7:0];
        DATA_INDH:  dataOut = regIND[15:8];
        default:    dataOut = 8'hFF;
    endcase
end

// Address/Data bus accesses occur on positive edges, but CPU microinstructions
// execute on negative edges, so that a microinstruction can set up the address
// and also use the data within the same cycle.
always @ (negedge clock or posedge reset) begin
    if (reset) begin
        uCodeAddress <= USEQ_ADDR_RESET;
        regPC <= 16'hFFFF;
        regIND <= 16'hFFFF;
        regS <= 8'hFF;
        regOP <= NOP;
        regP <= 8'h00;
        regA <= 8'h00;
        regIDX <= 8'h00;
        regX <= 8'h00;
        regY <= 8'h00;
    end else if (enable) begin

        // Update PC
        if (incrementPC)
            regPC <= regPC + 16'd1;
        else begin
            // Update PCL
            if (dataBusMux == DATA_PCL)
                regPC[7:0] <= dataIn;
            else if (aluResultStorage == ALU_O_PCL)
                regPC[7:0] <= aluResult;
            
            // Update PCH
            if (dataBusMux == DATA_PCH)
                regPC[15:8] <= dataIn;
            else if (aluResultStorage == ALU_O_PCH)
                regPC[15:8] <= aluResult;
        end
        
        // Update opcode register
        if (!dataWriteEnable && dataBusMux == DATA_OP)
            regOP <= dataIn;
        
        // Update accumulator register A
        if (!dataWriteEnable && dataBusMux == DATA_A)
            regA <= dataIn;
        else if (aluResultStorage == ALU_O_A)
            regA <= aluResult;
        
        // Update index register X
        if (!dataWriteEnable && dataBusMux == DATA_X)
            regX <= dataIn;
        else if (aluResultStorage == ALU_O_X)
            regX <= aluResult;
        
        // Update index register Y
        if (!dataWriteEnable && dataBusMux == DATA_Y)
            regY <= dataIn;
        else if (aluResultStorage == ALU_O_Y)
            regY <= aluResult;
        
        // Update status register P
        if (!dataWriteEnable && dataBusMux == DATA_P)
            regP <= dataIn;
        else if (aluResultStorage == ALU_O_P)
            regP <= aluResult;
        else if (aluStoreFlags && aluOperation != ALU_OP_SETBIT && aluOperation != ALU_OP_CLRBIT) begin
            regP[C_BIT_IN_P] <= aluCarryOut;
            regP[V_BIT_IN_P] <= aluOverflowOut;
            regP[Z_BIT_IN_P] <= aluZero;
            regP[N_BIT_IN_P] <= aluNegative;
        end
        
        // Update stack pointer register S
        if (aluResultStorage == ALU_O_S)
            regS <= aluResult;
        
        // Update indirect register IND
        if (!dataWriteEnable && dataBusMux == DATA_INDL)
            regIND[7:0] <= dataIn;
        if (!dataWriteEnable && dataBusMux == DATA_INDH)
            regIND[15:8] <= dataIn;
        
        // Determine the next microcode address
        if (uSeqBranchCondition == aluBranchCondition) begin
            // Branch conditions match, so set uCodeAddress to the branch address
            uCodeAddress <= uSeqBranchAddr;
        end else begin
            // Branch conditions do not match, so increment uCodeAddress
            uCodeAddress <= uCodeAddress + 10'd1;
        end
    end
end

endmodule

/* verilator lint_on UNUSED */
