//
// Cpu6502Alu - 6502 Arithmetic and Logic Unit
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

`include "Cpu6502MicrocodeConstants.vh"

module Cpu6502Alu
(
    input   [7:0]   operandA,
    input   [7:0]   operandB,
    input           carryIn,
    input   [2:0]   operation,
    input   [2:0]   opExtension,
    input           decimalMode,
    output  [7:0]   result,
    output          carryOut,
    output          zero,
    output          negative,
    output          overflow,
    output          branchCondition
);

wire subtract = (operation == ALU_OP_SBC);
wire [7:0] addend1 = operandA;
wire [7:0] addend2 = subtract ? ~operandB : operandB;
wire [4:0] rawSumL = addend1[3:0] + addend2[3:0] + {3'd0, carryIn};
wire halfCarry = rawSumL[4] | (decimalMode & (rawSumL[3:1] >= 3'd5));
wire [4:0] rawSumH = addend1[7:4] + addend2[7:4] + {3'd0, halfCarry};
wire fullCarry = rawSumH[4] | (decimalMode & (rawSumH[3:1] >= 3'd5));
wire [3:0] finalSumL;
wire [3:0] finalSumH;
wire [7:0] finalSum = {finalSumH, finalSumL};

assign zero = ~|result;
assign negative = result[7];
assign overflow = addend1[7] ^ addend2[7] ^ result[7] ^ fullCarry;

always @ (*) begin
    case ({decimalMode, subtract, halfCarry})
        3'b110:    finalSumL = rawSumL[3:0] + 4'd10;
        3'b101:    finalSumL = rawSumL[3:0] + 4'd6;
        default:   finalSumL = rawSumL[3:0];
    endcase
end

always @ (*) begin
    case ({decimalMode, subtract, fullCarry})
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
            branchCondition = 1'b0;
        end
        
        ALU_OP_OR: begin
            result = operandA | operandB;
            carryOut = carryIn;
            branchCondition = 1'b0;
        end
        
        ALU_OP_EOR: begin
            result = operandA ^ operandB;
            carryOut = carryIn;
            branchCondition = 1'b0;
        end
        
        ALU_OP_ADC, ALU_OP_SBC: begin
            result = finalSum;
            carryOut = fullCarry;
            branchCondition = fullCarry;
        end
        
        ALU_OP_SGL: begin // Single operand - opExtension is the operation
            case (opExtension)
                ALU_SOP_ASL: begin
                    result = {operandA[6:0], 1'b0};
                    carryOut = operandA[7];
                    branchCondition = 1'b0;
                end
                
                ALU_SOP_LSR: begin
                    result = {1'b0, operandA[7:1]};
                    carryOut = operandA[0];
                    branchCondition = 1'b0;
                end
                
                ALU_SOP_ROL: begin
                    result = {operandA[6:0], carryIn};
                    carryOut = operandA[7];
                    branchCondition = 1'b0;
                end
                
                ALU_SOP_ROR: begin
                    result = {carryIn, operandA[7:1]};
                    carryOut = operandA[0];
                    branchCondition = 1'b0;
                end
                
                ALU_SOP_TEST_N: begin
                    result = operandA;
                    carryOut = carryIn;
                    branchCondition = operandA[N_BIT_IN_P];
                end
                
                ALU_SOP_TEST_C: begin
                    result = operandA;
                    carryOut = carryIn;
                    branchCondition = operandA[C_BIT_IN_P];
                end
                
                ALU_SOP_TEST_V: begin
                    result = operandA;
                    carryOut = carryIn;
                    branchCondition = operandA[V_BIT_IN_P];
                end
                
                ALU_SOP_TEST_Z: begin
                    result = operandA;
                    carryOut = carryIn;
                    branchCondition = operandA[Z_BIT_IN_P];
                end
                
                default: begin
                    result = 8'hXX;
                    carryOut = carryIn;
                    branchCondition = 1'b0;
                end
            endcase
        end

        default: begin
            result = 8'hXX;
            carryOut = carryIn;
            branchCondition = 1'b0;
        end
    endcase
end

endmodule //Cpu6502Alu