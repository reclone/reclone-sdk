//
// DataIslandPacketSerializer - Clock out an HDMI data island packet to three TERC4 channels
//
//
//
// Copyright 2020 Reclone Labs <reclonelabs.com>
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

module DataIslandPacketSerializer
(
    input wire clock,
    input wire isFirstPacketClock,

    input wire hsync,
    input wire vsync,
    
    input wire [23:0] header,
    input wire [55:0] subpacket0,
    input wire [55:0] subpacket1,
    input wire [55:0] subpacket2,
    input wire [55:0] subpacket3,
    
    output wire [3:0] terc4channel0,
    output wire [3:0] terc4channel1,
    output wire [3:0] terc4channel2
);

reg [23:0] headerReg = 24'd0;
reg [55:0] subpacket0Reg = 56'd0;
reg [55:0] subpacket1Reg = 56'd0;
reg [55:0] subpacket2Reg = 56'd0;
reg [55:0] subpacket3Reg = 56'd0;
reg [5:0] count = 6'd0;

always @ (posedge clock) begin
    if (isFirstPacketClock) begin
        headerReg <= header;
        subpacket0Reg <= subpacket0;
        subpacket1Reg <= subpacket1;
        subpacket2Reg <= subpacket2;
        subpacket3Reg <= subpacket3;
        count <= 6'd1;
    end else begin
        count <= count + 6'd1;
    end
end

wire headerUseEcc = (count >= 6'd24);
wire subpacketUseEcc = (count >= 6'd28);

assign terc4channel0[0] = hsync;
assign terc4channel0[1] = vsync;
assign terc4channel0[3] = ~isFirstPacketClock;

wire headerEcc;
BchEccSingleBitEncoder headerEccEncoder
(
    .clock(clock),
    .data(headerUseEcc ? 1'b0 : (isFirstPacketClock ? header[5'd0] : headerReg[count[4:0]])),
    .isFirstDataClock(isFirstPacketClock),
    .ecc(headerEcc)
);
assign terc4channel0[2] = isFirstPacketClock ? header[5'd0] : (headerUseEcc ? headerEcc : header[count[4:0]]);

wire [1:0] subpacket0Ecc;
BchEccDualBitEncoder subpacket0EccEncoder
(
    .clock(clock),
    .data(subpacketUseEcc ? 2'b00 : (isFirstPacketClock ? subpacket0[1:0] : {subpacket0Reg[{count[4:0], 1'b1}], subpacket0Reg[{count[4:0], 1'b0}]})),
    .isFirstDataClock(isFirstPacketClock),
    .ecc(subpacket0Ecc)
);
assign terc4channel1[0] = isFirstPacketClock ? subpacket0[0] : (subpacketUseEcc ? subpacket0Ecc[0] : subpacket0Reg[{count[4:0], 1'b0}]);
assign terc4channel2[0] = isFirstPacketClock ? subpacket0[1] : (subpacketUseEcc ? subpacket0Ecc[1] : subpacket0Reg[{count[4:0], 1'b1}]);

wire [1:0] subpacket1Ecc;
BchEccDualBitEncoder subpacket1EccEncoder
(
    .clock(clock),
    .data(subpacketUseEcc ? 2'b00 : (isFirstPacketClock ? subpacket1[1:0] : {subpacket1Reg[{count[4:0], 1'b1}], subpacket1Reg[{count[4:0], 1'b0}]})),
    .isFirstDataClock(isFirstPacketClock),
    .ecc(subpacket1Ecc)
);
assign terc4channel1[1] = isFirstPacketClock ? subpacket1[0] : (subpacketUseEcc ? subpacket1Ecc[0] : subpacket1Reg[{count[4:0], 1'b0}]);
assign terc4channel2[1] = isFirstPacketClock ? subpacket1[1] : (subpacketUseEcc ? subpacket1Ecc[1] : subpacket1Reg[{count[4:0], 1'b1}]);

wire [1:0] subpacket2Ecc;
BchEccDualBitEncoder subpacket2EccEncoder
(
    .clock(clock),
    .data(subpacketUseEcc ? 2'b00 : (isFirstPacketClock ? subpacket2[1:0] : {subpacket2Reg[{count[4:0], 1'b1}], subpacket2Reg[{count[4:0], 1'b0}]})),
    .isFirstDataClock(isFirstPacketClock),
    .ecc(subpacket2Ecc)
);
assign terc4channel1[2] = isFirstPacketClock ? subpacket2[0] : (subpacketUseEcc ? subpacket2Ecc[0] : subpacket2Reg[{count[4:0], 1'b0}]);
assign terc4channel2[2] = isFirstPacketClock ? subpacket2[1] : (subpacketUseEcc ? subpacket2Ecc[1] : subpacket2Reg[{count[4:0], 1'b1}]);

wire [1:0] subpacket3Ecc;
BchEccDualBitEncoder subpacket3EccEncoder
(
    .clock(clock),
    .data(subpacketUseEcc ? 2'b00 : (isFirstPacketClock ? subpacket3[1:0] : {subpacket3Reg[{count[4:0], 1'b1}], subpacket3Reg[{count[4:0], 1'b0}]})),
    .isFirstDataClock(isFirstPacketClock),
    .ecc(subpacket3Ecc)
);
assign terc4channel1[3] = isFirstPacketClock ? subpacket3[0] : (subpacketUseEcc ? subpacket3Ecc[0] : subpacket3Reg[{count[4:0], 1'b0}]);
assign terc4channel2[3] = isFirstPacketClock ? subpacket3[1] : (subpacketUseEcc ? subpacket3Ecc[1] : subpacket3Reg[{count[4:0], 1'b1}]);



endmodule
