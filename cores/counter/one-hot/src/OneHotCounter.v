//
// OneHotCounter - A basic synchronous one-hot counter of parameterized width
//
// One-hot is a group of bits among which the legal combinations of values are only those with a 
// single high (1) bit and all the others low (0).
//
// This one-hot counter rotates a single 1 bit left, i.e. 0001, 0010, 0100, 1000, 0001, ...
// Reset returns the 1 to bit zero, i.e. 0001.
//
// One-hot counters are useful for implementing some state machines in an FPGA, because less
// combinatorial logic is required to decode the state values, making the state machine faster.
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

module OneHotCounter # (parameter SIZE = 8)
(
    input                   clock,
    input                   enable,
    input                   reset,
    output reg [SIZE-1:0]   out = SIZE'd1
};

always @ (posedge clock)
begin
    if (reset)
    begin
        out <= SIZE'd1;
    end
    else
    begin
        out <= {out[SIZE-2:0], out[SIZE-1]};
    end
end

endmodule