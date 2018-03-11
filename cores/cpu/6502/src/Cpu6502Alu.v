module Cpu6502Alu
(
    input   [7:0]   operand1,
    input   [7:0]   operand2,
    input           carryIn,
    input   [4:0]   operation, //First 3 and last 2 bits of opcode
    output  [7:0]   result,
    output          carryOut
);

wire [7:0] unused;

always @ (operand1, operand2, carryIn, operation)
begin
    case (operation)
        5'b00001:   //ORA
            begin
                result = operand1 | operand2;
                carryOut = carryIn;
            end
        5'b00101:   //AND
            begin
                result = operand1 & operand2;
                carryOut = carryIn;
            end
        5'b01001:   //EOR
            begin
                result = operand1 ^ operand2;
                carryOut = carryIn;
            end
        5'b01101:   //ADC
            {carryOut, result} = operand1 + operand2 + carryIn;
        5'b10001:   //STA
            begin
                result = operand1;
                carryOut = carryIn;
            end
        5'b10101:   //LDA
            begin
                result = operand2;
                carryOut = carryIn;
            end
        5'b11001:   //CMP
            begin
                result = operand1;
                {carryOut, unused} = operand1 + ~operand2 + 1;
            end
        default:
            begin
                carryOut = carryIn;
                result = 8'hXX;
            end
    endcase
end

endmodule //6502_alu