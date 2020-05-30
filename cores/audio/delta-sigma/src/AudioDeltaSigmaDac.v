//
// AudioDeltaSigmaDac - Line-output audio samples to a bitstream using delta-sigma modulation
//
// An FPGA can output audio from a digital pin using delta-sigma modulation.  "A delta-sigma DAC
// encodes a high-resolution digital input signal into a lower-resolution but higher
// sample-frequency signal that is mapped to voltages, and then smoothed with an analog filter."
//
// A second-order digital delta-sigma modulator is implemented in this module.  Here it is:
//
//  Sample In   Delta 1   Sigma 1   Delta 2   Sigma 2   Comparator     Bitstream Out
//  |            +                   +
//  ------------->O-------->Ʃ-------->O-------->Ʃ--------->MSBit---O------->
//                ^-                  ^-                           |
//                |-------------------|----------------1-bit DDC<---
//
// The input sample is a signed integer, and the output is a bitstream with an average
// value matching the voltage represented by the sample.
//
// The principles of delta-sigma modulation are better explained here:
// https://www.beis.de/Elektronik/DeltaSigma/DeltaSigma.html
// https://en.wikipedia.org/wiki/Delta-sigma_modulation
//
// A very simple FPGA audio line-output consists of a single 3.3V-standard LVTTL push-pull output
// pin, connected to a passive RC low-pass filter, connected through a large DC-blocking capacitor
// to an audio connector (like an RCA jack).  This circuit is a simple and rough audio DAC.
//
// Consumer line-level audio voltages are 0.894 Vpp (volts peak-to-peak) meaning that they range
// from -0.447 to +0.447V.  Considering the 3.3V passive circuit mentioned above can range from
// -1.65V to +1.65V, a dividing factor of 3.69 (safely, 4, or >>2) is used to constrain the output
// to the line-level voltage range.  This is implemented by considering the full 3.3Vpp range
// to be SAMPLE_BITS+2 bits, so that the SAMPLE_BITS-bit samples can only produce 0.825Vpp
// on the output.
//
// For more information on "line level":
// https://en.wikipedia.org/wiki/Line_level
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

module AudioDeltaSigmaDac #(parameter SAMPLE_BITS = 16, ATTENUATION_BITS = 2)
(
    input wire oversampleClock,
    input wire sampleEnable,
    input wire signed [SAMPLE_BITS-1:0] sampleLevel,
    input wire reset,
    
    output reg bitstream = 1'd0
);

reg signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] attenuatedSampleReg = {(SAMPLE_BITS+ATTENUATION_BITS+2){1'b0}};
reg signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] sigma1 = {(SAMPLE_BITS+ATTENUATION_BITS+2){1'b0}};
reg signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] sigma2 = {(SAMPLE_BITS+ATTENUATION_BITS+2){1'b0}};

wire signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] bitstreamDdc = {~bitstream, ~bitstream, ~bitstream, {(SAMPLE_BITS+ATTENUATION_BITS-1){bitstream}}};

wire signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] delta1 = attenuatedSampleReg - bitstreamDdc;

wire signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] sigma1Next = sigma1 + delta1;

wire signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] delta2 = sigma1Next - bitstreamDdc;

wire signed [SAMPLE_BITS+ATTENUATION_BITS+1:0] sigma2Next = sigma2 + delta2;

wire bitstreamNext = sigma2Next[SAMPLE_BITS+ATTENUATION_BITS+1];

always @ (posedge oversampleClock) begin
    if (reset) begin
    
        sigma1 <= {(SAMPLE_BITS+ATTENUATION_BITS+2){1'b0}};
        sigma2 <= {(SAMPLE_BITS+ATTENUATION_BITS+2){1'b0}};
        bitstream <= 1'b0;
        attenuatedSampleReg <= {(SAMPLE_BITS+ATTENUATION_BITS+2){1'b0}};
        
    end else begin
    
        sigma1 <= sigma1Next;
        sigma2 <= sigma2Next;
        bitstream <= bitstreamNext;
        
        if (sampleEnable) begin
            attenuatedSampleReg <= {{(ATTENUATION_BITS+2){sampleLevel[SAMPLE_BITS-1]}}, sampleLevel};
        end
        
    end
end

endmodule
