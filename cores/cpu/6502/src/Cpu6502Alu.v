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
    output          carryOut
);

wire sbc = (operation == `ALU_OPERATION_SBC);
wire [7:0] addend1 = operand1;
wire [7:0] addend2 = sbc ? ~operand2 : operand2;
wire [4:0] rawSumL = addend1[3:0] + addend2[3:0] + carryIn;
wire halfCarry = rawSumL[4] | (decimalMode & (rawSumL[3:1] >= 3'd5));
wire [4:0] rawSumH = addend1[7:4] + addend2[3:0] + halfCarry;
assign carryOut = rawSumH[4] | (decimalMode & (rawSumH[3:1] >= 3'd5));
//TODO: Decimal correction

always @*
    case (operation)
        default:    carryOut = X;
    endcase
end

endmodule //6502_alu