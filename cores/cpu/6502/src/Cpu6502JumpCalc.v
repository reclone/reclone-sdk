//
// Cpu6502JumpCalc - Calculate changes to program counter, like jumps, branches, and increments
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

module Cpu6502JumpCalc
(
    input [15:0] currentPC,
    input [15:0] absoluteAddress,
    input [7:0] relativeOffset,
    input increment,
    input jumpRelative,
    input jumpAbsolute,
    output [15:0] newPC,
    output pageCrossing
);

wire [15:0] incrementedPC;
wire [7:0] decrementedPCH;
wire [7:0] incrementedPCH;
wire [7:0] pageCorrectedPCH;
wire [7:0] offsetPCL;
wire pageUp;

assign incrementedPC = currentPC + 1;
assign decrementedPCH = currentPC[15:8] - 1;
assign incrementedPCH = currentPC[15:8] + 1;
assign {pageCrossing, offsetPCL} = currentPC[7:0] + relativeOffset;
assign pageUp = pageCrossing && ~relativeOffset[7];
assign pageCorrectedPCH = ~pageCrossing ? currentPC[15:8] :
                          pageUp ? incrementedPCH : decrementedPCH;

assign newPC =  jumpAbsolute ? absoluteAddress :
                jumpRelative ? {pageCorrectedPCH, offsetPCL} :
                increment ? incrementedPC : currentPC;

endmodule