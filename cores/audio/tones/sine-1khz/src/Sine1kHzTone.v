//
// Sine1kHzTone - Produce 16-bit samples for a 1 kHz sine wave, assuming a 48 kHz sample rate
//
// This module produces signed 16-bit sample values for a 1 kHz sine wave.  The wave is at
// quarter-amplitude (to help spare your ear drums) meaning that the output sample ranges from
// -8192 to +8192.  48 sine samples are pre-calculated and stored in a ROM array, which is
// initialized from the file "sine1khz.mem".
//
// The "sampleEnable" signal advances the angle of the sine wave, so that the next sample is 
// loaded in the output register.  Since we are assuming a 48 kHz sample rate, there should be
// 48000 rising edges of audioClock with sampleEnable==1 per second.
//
// The 1 kHz tone is useful as a test pattern tone to accompany SMPTE color bars.
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

module Sine1kHzTone
(
    input wire audioClock,
    input wire sampleEnable,
    input wire reset,

    output reg signed [15:0] sample
);

reg [5:0] index = 6'd1;

reg signed [15:0] sine [0:47];
initial begin
    $readmemh("sine1khz.mem", sine);
end

always @ (posedge audioClock) begin
    if (reset) begin
        sample <= 16'd0;
        index <= 6'd1;
    end else if (sampleEnable) begin
        sample <= sine[index];
        if (index == 6'd47) begin
            index <= 6'd0;
        end else begin
            index <= index + 6'd1;
        end
    end
end

endmodule
