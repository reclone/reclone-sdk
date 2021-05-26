//
// Cpu65xxAlu - 6502 Family Arithmetic and Logic Unit (ALU)
//
//
// Copyright 2018 - 2021 Reclone Labs <reclonelabs.com>
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

`include "Cpu65xxMicrocodeConstants.vh"

module Cpu65xxAlu
(
    input   [7:0]   operandA,
    input   [7:0]   operandB,
    input           carryIn,
    input           overflowIn,
    input   [3:0]   operation,
    input   [2:0]   opExtension,
    input           decimalMode,
    output  [7:0]   result,
    output          carryOut,
    output          zero,
    output          negative,
    output          overflowOut,
    output          branchCondition
);

wire subtract = (operation == ALU_OP_SBC || operation == ALU_OP_SUB || operation == ALU_OP_DEC || 
                 (operation == ALU_OP_FIXUP && operandB[7] == 1'b1));
wire withCarry = (operation == ALU_OP_SBC || operation == ALU_OP_ADC);
wire incDec = (operation == ALU_OP_DEC || operation == ALU_OP_INC || operation == ALU_OP_FIXUP);
wire [7:0] adderOperandB = incDec ? 8'd1 : operandB;
wire [7:0] addend1 = operandA;
wire [7:0] addend2 = subtract ? ~adderOperandB : adderOperandB;
wire [4:0] rawSumL = addend1[3:0] + addend2[3:0] + (withCarry ? {4'd0, carryIn} : 5'd0);
wire halfCarry = rawSumL[4] | (decimalMode & (rawSumL[3:1] >= 3'd5));
wire [4:0] rawSumH = addend1[7:4] + addend2[7:4] + {3'd0, halfCarry};
wire fullCarry = rawSumH[4] | (decimalMode & (rawSumH[3:1] >= 3'd5));
wire [3:0] finalSumL;
wire [3:0] finalSumH;
wire [7:0] finalSum = {finalSumH, finalSumL};

assign zero = ~|result;
wire adderOverflow = addend1[7] ^ addend2[7] ^ finalSum[7] ^ fullCarry;

always @ (*) begin
    case ({decimalMode && withCarry, subtract, halfCarry})
        3'b110:    finalSumL = rawSumL[3:0] + 4'd10;
        3'b101:    finalSumL = rawSumL[3:0] + 4'd6;
        default:   finalSumL = rawSumL[3:0];
    endcase
end

always @ (*) begin
    case ({decimalMode && withCarry, subtract, fullCarry})
        3'b110:    finalSumH = rawSumH[3:0] + 4'd10;
        3'b101:    finalSumH = rawSumH[3:0] + 4'd6;
        default:   finalSumH = rawSumH[3:0];
    endcase
end

always @ (*) begin
    case (operation)
        ALU_OP_AND: begin
            result = operandA & operandB;
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_OR: begin
            result = operandA | operandB;
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_EOR: begin
            result = operandA ^ operandB;
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_ADC, ALU_OP_SBC: begin
            result = finalSum;
            carryOut = fullCarry;
            overflowOut = adderOverflow;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_ADD, ALU_OP_SUB: begin
            result = finalSum;
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = fullCarry;
            negative = result[7];
        end
        
        ALU_OP_BIT: begin
            result = operandA & operandB;
            carryOut = carryIn;
            overflowOut = operandB[6];
            branchCondition = 1'b0;
            negative = operandB[7];
        end
        
        ALU_OP_CMP: begin
            result = finalSum;
            carryOut = fullCarry;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = operandB[7];
        end
        
        ALU_OP_SETBIT: begin // Set a single bit to 1
            result = operandA | (8'd1 << opExtension);
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_CLRBIT: begin // Clear a single bit to 0
            result = operandA & ~(8'd1 << opExtension);
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_COPY: begin // Just copy operand A to result
            result = operandA;
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_INC, ALU_OP_DEC, ALU_OP_FIXUP: begin
            result = finalSum;
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
        
        ALU_OP_SGL: begin // Single operand - opExtension is the operation
            case (opExtension)
                ALU_SOP_ASL: begin
                    result = {operandA[6:0], 1'b0};
                    carryOut = operandA[7];
                    overflowOut = overflowIn;
                    branchCondition = 1'b0;
                    negative = result[7];
                end
                
                ALU_SOP_LSR: begin
                    result = {1'b0, operandA[7:1]};
                    carryOut = operandA[0];
                    overflowOut = overflowIn;
                    branchCondition = 1'b0;
                    negative = result[7];
                end
                
                ALU_SOP_ROL: begin
                    result = {operandA[6:0], carryIn};
                    carryOut = operandA[7];
                    overflowOut = overflowIn;
                    branchCondition = 1'b0;
                    negative = result[7];
                end
                
                ALU_SOP_ROR: begin
                    result = {carryIn, operandA[7:1]};
                    carryOut = operandA[0];
                    overflowOut = overflowIn;
                    branchCondition = 1'b0;
                    negative = result[7];
                end
                
                ALU_SOP_TEST_N: begin
                    result = operandA;
                    carryOut = carryIn;
                    overflowOut = overflowIn;
                    branchCondition = operandA[N_BIT_IN_P];
                    negative = result[7];
                end
                
                ALU_SOP_TEST_C: begin
                    result = operandA;
                    carryOut = carryIn;
                    overflowOut = overflowIn;
                    branchCondition = operandA[C_BIT_IN_P];
                    negative = result[7];
                end
                
                ALU_SOP_TEST_V: begin
                    result = operandA;
                    carryOut = carryIn;
                    overflowOut = overflowIn;
                    branchCondition = operandA[V_BIT_IN_P];
                    negative = result[7];
                end
                
                ALU_SOP_TEST_Z: begin
                    result = operandA;
                    carryOut = carryIn;
                    overflowOut = overflowIn;
                    branchCondition = operandA[Z_BIT_IN_P];
                    negative = result[7];
                end
                
                default: begin
                    result = 8'hXX;
                    carryOut = carryIn;
                    overflowOut = overflowIn;
                    branchCondition = 1'b0;
                    negative = result[7];
                end
            endcase
        end

        default: begin
            result = 8'hXX;
            carryOut = carryIn;
            overflowOut = overflowIn;
            branchCondition = 1'b0;
            negative = result[7];
        end
    endcase
end

endmodule //Cpu6502Alu