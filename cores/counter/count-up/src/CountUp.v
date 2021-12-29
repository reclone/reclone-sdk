//
// CountUp - A basic synchronous count-up counter/register of parameterized width
//
// Assert 'increment' to add 1 (unsigned addition) to the value on 'out'.  An overflow will
// return 'out' to zero.
//
// This counter will init with 'out' set to zero.  Asserting 'reset' will also return the counter
// to zero.  Asserting 'load' will set 'out' to the value on 'data'.
//
// Copyright 2019 Reclone Labs <reclonelabs.com>
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

module CountUp # (parameter SIZE = 8)
(
    input wire              clock,
    input wire              reset,
    input wire              increment,
    input wire              load,
    input wire [SIZE-1:0]   data,
    output reg [SIZE-1:0]   out = 0
);

always @ (posedge clock)
begin
    if (reset)
    begin
        out <= 0;
    end
    else if (load)
    begin
        out <= data;
    end
    else if (increment)
    begin
        out <= out + 1'd1;
    end
end

endmodule
