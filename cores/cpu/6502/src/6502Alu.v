module 6502_alu
(
    input   [7:0]   operand1,
    input   [7:0]   operand2,
    input           carryIn,
    input   [4:0]   operation, //First 3 and last 2 bits of opcode
    output  [7:0]   result,
    output          carryOut
);

always @ (operand1, operand2, carryIn, operation)
begin
    case (operation)
        5'b01101:   //ADC
            {carryOut, result} = operand1 + operand2 + carryIn;
        default:
            begin
                carryOut <= X;
                result <= 8'hXX;
            end
    endcase
end

endmodule //6502_alu