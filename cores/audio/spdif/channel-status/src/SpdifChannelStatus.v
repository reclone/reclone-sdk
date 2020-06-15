//
// SpdifChannelStatus - Lay out Channel Status word per IEC 60958-1 & IEC 60958-3 (used by S/PDIF)
//
// The Channel Status word provides information about the audio channel on which it is conveyed.
//
// Each IEC 60958-1 audio subframe includes a channel status bit, which conveys one bit of the
// 192-bit Channel Status word.  In S/PDIF, the first bit of the Channel Status word is indicated
// by a "B" preamble, whereas in HDMI, the first bit is indicated by a "B" bit in the audio sample
// packet header.  Channel Status is identical in both channels' sub-frames on an interface,
// except for the Channel Number field, if it is not set to zero.
//
// For simplicity, this module is hard-coded to "mode 0 channel status format for consumer use".
//
// The Channel Status word has the following configurable fields:
//      categoryCode        Kind of equipment generating the digital audio signal, e.g.:
//                              8'b00000000     General
//                              8'b10011001     DVD
//                              8'b01100000     Analog-to-digital converter without copyright info
//                              8'b00010000     Recorder and player using solid state memory
//                              8'b00000010     Experimental product
//      samplingFreq        Sampling frequency; 4'd2="48 kHz"
//      wordLength          Sample word length, e.g.:
//                              4'd0    Word length not indicated
//                              4'd2    16 bits
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

module SpdifChannelStatus
(
    input wire [3:0] channelNum,
    input wire [7:0] categoryCode,
    input wire [3:0] samplingFreq,
    input wire [3:0] wordLength,
    output wire [191:0] channelStatus
);

assign channelStatus[2:0] = 3'b100;     //c,b,a
assign channelStatus[5:3] = 3'd0;       //d = 2 audio channels without pre-emphasis
assign channelStatus[7:6] = 2'b00;      //mode
assign channelStatus[15:8] = categoryCode;
assign channelStatus[19:16] = 4'd0;     //sourceNum: do not take into account
assign channelStatus[23:20] = channelNum;
assign channelStatus[27:24] = samplingFreq;
assign channelStatus[29:28] = 2'b00;    //clock accuracy = Level II
assign channelStatus[31:30] = 2'b00;    //reserved
assign channelStatus[35:32] = wordLength;
assign channelStatus[39:36] = 4'd0;     //original sampling freq not indicated
assign channelStatus[191:40] = 152'd0;  //reserved

endmodule
