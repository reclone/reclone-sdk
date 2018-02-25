//
// RegisterFile2In1Out - A generic register file with two read ports and one write port
//
// The RegisterFile2In1Out module presents a number of registers, of parameterized width,
// accessible by a parameterized number of read and write ports.  This is a common
// design element when designing CPUs - all registers are accessed via this module.
//
// Implements 'internal forwarding' - when the write address equals one of the read addresses,
// the write data is forwarded directly to the read data output, preventing the possibility of
// returning garbage data at the read ports when a read is attempted simultaneously with a write.
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

module RegisterFile2Read1Write # (parameter REG_WIDTH = 8, ADDR_WIDTH = 3)
(
    input                       clock,
    input                       reset,

    input                       write,
    input   [ADDR_WIDTH-1:0]    writeAddr,
    input   [REG_WIDTH-1:0]     writeData,

    input   [ADDR_WIDTH-1:0]    readAddrA,
    output  [REG_WIDTH-1:0]     readDataA,
    
    input   [ADDR_WIDTH-1:0]    readAddrB,
    output  [REG_WIDTH-1:0]     readDataB
);

// Instantiate the required number of registers.
// All registers receive the same clock, reset, and writeData inputs.
// Each register connects to its own writeEnable input and regValue output.
Register #(.SIZE(REG_WIDTH)) regs[2**ADDR_WIDTH-1:0]
(
    .q(regValues),
    .d(writeData),
    .clock(clock),
    .write(writeEnables),
    .reset(reset)
);

// Active-high write enable lines connected to the registers
wire                 writeEnables[2**ADDR_WIDTH-1:0];
// Register values array connected to the registers
wire [REG_WIDTH-1:0] regValues[2**ADDR_WIDTH-1:0];

// Asynchronous process - set the appropriate write enable bit based on write and writeAddr
always @ (write, writeAddr)
begin
    reg [ADDR_WIDTH-1:0] regIdx;
    for (regIdx = 0; regIdx < 2**ADDR_WIDTH-1; regIdx = regIdx + 1)
        writeEnables[regIdx] = (write && (writeAddr == regIdx));
end

// Asynchronous process - if the read A address matches the write address, forward the write data,
//                        otherwise output the value of the specified register.
always @ (write, writeAddr, readAddrA)
begin
    if (write && (writeAddr == readAddrA))
        readDataA = writeData;
    else
        readDataA = regValues[readAddrA];
end

// Asynchronous process - if the read B address matches the write address, forward the write data,
//                        otherwise output the value of the specified register.
always @ (write, writeAddr, readAddrB)
begin
    if (write && (writeAddr == readAddrB))
        readDataB = writeData;
    else
        readDataB = regValues[readAddrB];
end

endmodule