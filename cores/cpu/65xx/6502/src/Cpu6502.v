//
// Cpu6502 - A hopefully cycle-accurate implementation of the MOS 6502
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

module Cpu6502
(
    input clock,
    input enable,
    input reset,

    input wire [7:0] dataIn,
    output wire [7:0] dataOut,
    output wire nWrite,
    output wire [15:0] address,

    input wire nNMI,
    input wire nIRQ,
    input wire nRESET
);

wire [9:0]  uCodeAddress;
wire [1:0]  uCodeAddrBusMux;
wire        uCodeDataWriteEnable;
wire [1:0]  uCodeDataBusMux;
wire [3:0]  uCodeAluOperation;
wire [3:0]  uCodeAluOperandAMux;
wire [2:0]  uCodeAluOperandBMuxOrOpExtension;
wire [3:0]  uCodeAluResultStorage;
wire        uCodeIncrementAddr;
wire        uSeqBranchCondition;
wire [9:0]  uSeqBranchAddr;

Cpu65xxMicroArchitecture uArch
(
    .clock(clock),
    .enable(enable),
    .reset(reset),
    .dataIn(dataIn),
    .dataOut(dataOut),
    .nWrite(nWrite),
    .address(address),
    .nNMI(nNMI),
    .nIRQ(nIRQ),
    .nRESET(nRESET),
    .uCodeAddress(uCodeAddress),
    .uCodeAddrBusMux(uCodeAddrBusMux),
    .uCodeDataWriteEnable(uCodeDataWriteEnable),
    .uCodeDataBusMux(uCodeDataBusMux),
    .uCodeAluOperation(uCodeAluOperation),
    .uCodeAluOperandAMux(uCodeAluOperandAMux),
    .uCodeAluOperandBMuxOrOpExtension(uCodeAluOperandBMuxOrOpExtension),
    .uCodeAluResultStorage(uCodeAluResultStorage),
    .uCodeIncrementAddr(uCodeIncrementAddr),
    .uSeqBranchCondition(uSeqBranchCondition),
    .uSeqBranchAddr(uSeqBranchAddr)
);

Cpu6502MicrocodeRom uCode
(
    .clock(clock),
    .enable(enable),
    .address(uCodeAddress),
    .addrBusMux(uCodeAddrBusMux),
    .dataBusWriteEnable(uCodeDataWriteEnable),
    .dataBusMux(uCodeDataBusMux),
    .aluOperation(uCodeAluOperation),
    .aluOperandA(uCodeAluOperandAMux),
    .aluOperandB(uCodeAluOperandBMuxOrOpExtension),
    .aluResultStorage(uCodeAluResultStorage),
    .incrementAddr(uCodeIncrementAddr),
    .uSeqBranchCondition(uSeqBranchCondition),
    .uSeqBranchAddr(uSeqBranchAddr)
);

endmodule
