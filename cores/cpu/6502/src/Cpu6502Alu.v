//
// Cpu6502Alu - 6502 Arithmetic Logic Unit
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

module Cpu6502Alu
(
    input   [7:0]   operand1,
    input   [7:0]   operand2,
    input           carryIn,
    input   [2:0]   operation,
    input           decimalMode,
    output  [7:0]   result,
    output          carryOut,
    output          zero,
    output          negative,
    output          overflow
);

wire subtract = (operation == `ALU_OPERATION_SBC);
wire [7:0] addend1 = operand1;
wire [7:0] addend2 = subtract ? ~operand2 : operand2;
wire [4:0] rawSumL = addend1[3:0] + addend2[3:0] + carryIn;
wire halfCarry = rawSumL[4] | (decimalMode & (rawSumL[3:1] >= 3'd5));
wire [4:0] rawSumH = addend1[7:4] + addend2[3:0] + halfCarry;
wire fullCarry = rawSumH[4] | (decimalMode & (rawSumH[3:1] >= 3'd5));
wire finalSum[7:0];

assign zero = ~|result;
assign negative = result[7];
assign overflow = addend1[7] ^ addend2[7] ^ result[7] ^ fullCarry;

always @* begin
    case ({decimalMode, subtract, halfCarry})
        case 3'b110:    finalSum[3:0] = rawSumL[3:0] + 4'd10;
        case 3'b101:    finalSum[3:0] = rawSumL[3:0] + 4'd6;
        default:        finalSum[3:0] = rawSumL[3:0];
    endcase
end

always @* begin
    case ({decimalMode, subtract, fullCarry})
        case 3'b110:    finalSum[7:4] = rawSumL[7:4] + 4'd10;
        case 3'b101:    finalSum[7:4] = rawSumL[7:4] + 4'd6;
        default:        finalSum[7:4] = rawSumL[7:4];
    endcase
end

always @* begin
    case (operation)
        `ALU_OPERATION_COPY:
            result = operand1;
            carryOut = 1'bX;
        `ALU_OPERATION_AND:
            result = operand1 & operand2;
            carryOut = 1'bX;
        `ALU_OPERATION_OR:
            result = operand1 | operand2;
            carryOut = 1'bX;
        `ALU_OPERATION_EOR:
            result = operand1 ^ operand2;
            carryOut = 1'bX;
        `ALU_OPERATION_ADC, `ALU_OPERATION_SBC:
            result = finalSum;
            carryOut = fullCarry;
        `ALU_OPERATION_ROR:
            result = {carryIn, operand1[7:1]};
            carryOut = operand1[0];
        default:
            result = 8'hXX;
            carryOut = 1'bX;
    endcase
end

endmodule //6502_alu