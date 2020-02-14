//
// NtscGenerator - Generate DAC samples for NTSC composite video, given timing and color signals
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

module NtscGenerator
(
    input wire reset,
    input wire phaseClock,
    input wire [PHASE_BITS-1:0] subcarrierPhase,
    input wire blank,
    input wire sync,
    input wire burst,
    input wire[7:0] y,
    input wire signed[8:0] i,
    input wire signed[8:0] q,

    output reg [DAC_BITS-1:0] dacSample = BLANK_LEVEL[DAC_BITS-1:0]
);

localparam PHASE_BITS = 4;
localparam DAC_BITS = 5;
localparam BLANK_LEVEL = 8;
localparam BURST_AMPLITUDE_SHIFT = 2;
localparam BLACK_LEVEL = 10;
localparam WHITE_LEVEL = 28;
localparam LOWER_SWING_LEVEL = 4;
localparam UPPER_SWING_LEVEL = 31;
localparam SWING_RANGE = UPPER_SWING_LEVEL - LOWER_SWING_LEVEL;
localparam SYNC_LEVEL = 0;
localparam COSINE_PRECISION_BITS = 7;

reg signed [COSINE_PRECISION_BITS:0] cosine [0:15];
initial begin
    cosine[ 0] = 8'd127;
    cosine[ 1] = 8'd117;
    cosine[ 2] = 8'd90;
    cosine[ 3] = 8'd49;
    cosine[ 4] = 8'd0;
    cosine[ 5] = -8'd49;
    cosine[ 6] = -8'd90;
    cosine[ 7] = -8'd117;
    cosine[ 8] = -8'd127;
    cosine[ 9] = -8'd117;
    cosine[10] = -8'd90;
    cosine[11] = -8'd49;
    cosine[12] = 8'd0;
    cosine[13] = 8'd49;
    cosine[14] = 8'd90;
    cosine[15] = 8'd117;
end

wire signed [COSINE_PRECISION_BITS:0] sine [0:15];
assign sine[ 0] = cosine[12];
assign sine[ 1] = cosine[13];
assign sine[ 2] = cosine[14];
assign sine[ 3] = cosine[15];
assign sine[ 4] = cosine[ 0];
assign sine[ 5] = cosine[ 1];
assign sine[ 6] = cosine[ 2];
assign sine[ 7] = cosine[ 3];
assign sine[ 8] = cosine[ 4];
assign sine[ 9] = cosine[ 5];
assign sine[10] = cosine[ 6];
assign sine[11] = cosine[ 7];
assign sine[12] = cosine[ 8];
assign sine[13] = cosine[ 9];
assign sine[14] = cosine[10];
assign sine[15] = cosine[11];

// COLOR BURST - Scale cosine values into the required amplitude range.
// Amplitude of color burst is assumed to be a power of two, to keep the math simple
// (i.e. multiply is just a shift).
// Since the divide is also just a shift (with truncation), add 0.5 to the multiplied
// value so that the divide is effectively rounded to the nearest integer.

// Pseudocode
//  burst level = blank level + round(cos(burst phase) * burst amplitude)
// becomes
//  burstLevel = BLANK_LEVEL + ((cosine[burstPhase] << BURST_AMPLITUDE_SHIFT) + (1 << COSINE_PRECISION_BITS-1)) >> COSINE_PRECISION_BITS

// Color burst is always 180 degrees out of phase with the subcarrier
wire [3:0] burstPhase = subcarrierPhase + 4'd8;

// burstCosineMultiplied = cosine[burstPhase] << BURST_AMPLITUDE_SHIFT (with proper padding, widths, sign extension)
wire signed [COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT:0] burstCosineMultiplied = {cosine[burstPhase], {BURST_AMPLITUDE_SHIFT{1'b0}}};

// burstCosineRounded = burstCosineMultiplied + (1 << COSINE_PRECISION_BITS-1)
/* verilator lint_off UNUSED */
wire signed [COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT+1:0] burstCosineRounded =
    {burstCosineMultiplied[COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT],burstCosineMultiplied} + (11'd1 << (COSINE_PRECISION_BITS-1));
/* verilator lint_on UNUSED */

// burstScaled = burstCosineRounded >> COSINE_PRECISION_BITS (with proper widths)
wire signed [BURST_AMPLITUDE_SHIFT+1:0] burstScaled = burstCosineRounded[COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT+1:COSINE_PRECISION_BITS];

// burstLevel = BLANK_LEVEL + burstScaled (with proper padding, widths, sign extension)
wire [DAC_BITS-1:0] burstLevel = BLANK_LEVEL[DAC_BITS-1:0] + {{(DAC_BITS-BURST_AMPLITUDE_SHIFT-2){burstScaled[BURST_AMPLITUDE_SHIFT+1]}},burstScaled};

// y is in the range of 0 to 255
// yScaled is the Y component in the range of 0 to 32640
wire [14:0] yScaled = {y, {COSINE_PRECISION_BITS{1'b0}}};

// i is in the range of -152 to 152
// iScaled is the I component in the range of -19304 to 19304
wire signed [16:0] iScaled = i * cosine[subcarrierPhase];

// q is in the range of -133 to 133
// qScaled is the Q component in the range of -16891 to 16891
wire signed [16:0] qScaled = q * sine[subcarrierPhase];

// Full-saturation yellow can swing up to 1.333*2^15=43680
// Full-saturation blue can swing down to -0.333*2^15=-10912
/* verilator lint_off UNUSED */
wire signed [16:0] yiqSumRounded = {2'd0, yScaled} + iScaled + qScaled + 17'h200;
/* verilator lint_on UNUSED */

// Scale this into a level of LOWER_SWING_LEVEL to UPPER_SWING_LEVEL
// Scale by 27/54592=0.00049458 which is roughly 32/65536=0.000488 or simply >> 11
/* verilator lint_off UNUSED */
wire [DAC_BITS:0] yiqLevelExtended = BLACK_LEVEL[DAC_BITS:0] + yiqSumRounded[16:11];
/* verilator lint_on UNUSED */

// yiqLevelExtended should be in the proper range of LOWER_SWING_LEVEL to UPPER_SWING_LEVEL, so truncate
wire [DAC_BITS-1:0] yiqLevel = yiqLevelExtended[DAC_BITS-1:0];

always @ (posedge phaseClock) begin
    if (reset) begin
        dacSample <= BLANK_LEVEL[DAC_BITS-1:0];
    end else begin
        if (sync)
            dacSample <= SYNC_LEVEL[DAC_BITS-1:0];
        else if (burst)
            dacSample <= burstLevel;
        else if (blank)
            dacSample <= BLANK_LEVEL[DAC_BITS-1:0];
        else
            dacSample <= yiqLevel;
    end
end

endmodule
