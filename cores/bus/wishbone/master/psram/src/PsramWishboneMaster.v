//
// PsramWishboneMaster - Asynchronous PSRAM device interface to Wishbone master interface adapter
//
// This module converts a Pseudostatic RAM (PSRAM) device interface into a pipelined Wishbone
// master interface, including stall support.  A microcontroller designed to interface with
// external PSRAM chips can be configured to access FPGA memories and fabric peripherals as if
// the FPGA were a PSRAM chip.  This makes it convenient for the microcontroller to access FPGA
// resources, because the FPGA can be mapped into the microcontroller's own address space.
//
// The simulated PSRAM device has a 16-bit data bus that is multiplexed with the low 16 bits
// of the 24-bit address bus.
//
// To keep this module simple and to keep the design in a single clock domain, the PSRAM only does
// asynchronous accesses, meaning that no form of synchronous burst access is supported.
//
// PSRAM interface description:
//  A[23:16]    24-bit address bus input, to address up to 16,777,216 16-bit words (32 MB)
//  AD[15:0]    16-bit bidirectional data bus, multiplexed with the lowest 16 bits of the address
//              AD[] should be connected directly to FPGA I/O pins so they can be tri-stated during writes
//  NE          Active-low chip select input
//  NOE         Active-low output enable input
//  NWE         Active-low write enable input
//  NADV        Active-low address valid/latch input (aka. NL)
//  NWAIT       Active-low wait/stall output
//  NUB         Active-low upper byte enable input (aka. NBL[1])
//  NLB         Active-low lower byte enable input (aka. NBL[0])
//
// Wishbone B4 pipelined master interface description:
//  CLK_I       Wishbone bus clock input; signals registered at rising edge
//  CYC_O       Cycle output; indicates that a valid bus cycle is in progress
//  STB_O       Strobe output; indicates a valid data transfer cycle
//  STALL_I     Pipeline stall input; indicates current slave cannot accept transfer
//  ACK_I       Acknowledge input; indicates the normal termination of a bus cycle
//  ERR_I       Error input; indicates an abnormal cycle termination
//  ADR_O[24:1] Address output (for 16-bit data port with 8-bit granularity)
//  DAT_I[15:0] Data input port  (16-bit)
//  DAT_O[15:0] Data output port (16-bit)
//  WE_O        Write enable output
//  SEL_O[1:0]  Select output port; indicates which bytes are valid on DAT_I and DAT_O
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

module PsramWishboneMaster
(
    // PSRAM interface
    input wire [23:16]  psramA,
    inout wire [15:0]   psramAD,
    input wire          psramNE,
    input wire          psramNOE,
    input wire          psramNWE,
    input wire          psramNADV,
    output wire         psramNWAIT,
    input wire          psramNUB,
    input wire          psramNLB,
    
    // Wishbone bus master interface
    input wire          RST_I,
    input wire          CLK_I,
    output reg          CYC_O = 1'b0,
    output reg          STB_O = 1'b0,
    input wire          STALL_I,
    input wire          ACK_I,
    input wire          ERR_I,
    output reg [24:1]   ADR_O = 24'd0,
    input wire [15:0]   DAT_I,
    output reg [15:0]   DAT_O = 16'd0,
    output reg          WE_O = 1'b0,
    output reg [1:0]    SEL_O = 2'b00
);

localparam ERR_DATA_VALUE = 16'hDEAD;

assign psramAD = (!psramNE && !psramNOE) ? dataOut : 16'bZ;
assign psramNWAIT = !(CYC_O && STB_O && STALL_I);

reg addressIsLatched = 1'b0;
reg writeDataReady = 1'b0;
reg [15:0] dataOut = 16'd0;

always @ (posedge CLK_I) begin
    if (RST_I) begin
        CYC_O <= 1'b0;
        STB_O <= 1'b0;
        ADR_O <= 24'd0;
        DAT_O <= 16'd0;
        WE_O <= 1'b0;
        SEL_O <= 2'b00;
        addressIsLatched <= 1'b0;
        writeDataReady <= 1'b0;
        dataOut <= 16'd0;
    end else begin
        if (!psramNE) begin
            // Chip is selected
            
            if (!psramNADV) begin
                ADR_O <= {psramA, psramAD};
                addressIsLatched <= 1'b1;
                writeDataReady <= 1'b0;
            end else if (addressIsLatched && !psramNOE) begin
                // Read cycle
                
                if (!CYC_O && !STB_O) begin
                    // Assert cycle and strobe outputs to begin the read
                    CYC_O <= 1'b1;
                    STB_O <= 1'b1;
                    WE_O <= 1'b0;
                    // Latch the byte lane selections
                    SEL_O <= {~psramNUB, ~psramNLB};
                end else if (CYC_O) begin
                    // Wishbone cycle in progress
                    
                    if (STB_O && !STALL_I) begin
                        // Wishbone slave accepted the strobe, so de-assert strobe
                        STB_O <= 1'b0;
                    end
                    
                    if (ACK_I) begin
                        // Read was successful
                        dataOut <= DAT_I;
                        CYC_O <= 1'b0;
                        addressIsLatched <= 1'b0;
                    end else if (ERR_I) begin
                        // Read failed
                        dataOut <= ERR_DATA_VALUE;
                        CYC_O <= 1'b0;
                        addressIsLatched <= 1'b0;
                    end
                end
                
            end else if (addressIsLatched && !psramNWE) begin
                // Write cycle
                
                if (!writeDataReady) begin
                    // Address hold - Delay one clock before sampling the write data
                    writeDataReady <= 1'b1;
                end else if (!CYC_O && !STB_O) begin
                    // Assert cycle and strobe outputs to begin the read
                    CYC_O <= 1'b1;
                    STB_O <= 1'b1;
                    WE_O <= 1'b1;
                    // Latch the write data and byte lane selections
                    DAT_O <= psramAD;
                    SEL_O <= {~psramNUB, ~psramNLB};
                end else if (CYC_O) begin
                    // Wishbone cycle in progress
                    
                    if (STB_O && !STALL_I) begin
                        // Wishbone slave accepted the strobe, so de-assert strobe
                        STB_O <= 1'b0;
                        WE_O <= 1'b0;
                    end
                    
                    if (ACK_I || ERR_I) begin
                        // Write is finished, either successful or failed
                        CYC_O <= 1'b0;
                        addressIsLatched <= 1'b0;
                        writeDataReady <= 1'b0;
                    end
                end
            end
            
        end else begin
            // PSRAM interface not chip-selected
            addressIsLatched <= 1'b0;
            writeDataReady <= 1'b0;
            CYC_O <= 1'b0;
            STB_O <= 1'b0;
            WE_O <= 1'b0;
            SEL_O <= 2'b00;
        end
    end
end

endmodule
