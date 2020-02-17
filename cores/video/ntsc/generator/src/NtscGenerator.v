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
localparam DAC_LEVEL_SHIFT = 11;

reg [7:0] yLatched = 8'd0;
reg signed [8:0] iLatched = 9'd0;
reg signed [8:0] qLatched = 9'd0;


//reg [PHASE_BITS-1:0] subcarrierPhaseLatched;


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
//wire [3:0] burstPhase = subcarrierPhase + 4'd8;
//reg [3:0] burstPhase = 4'd8;

// burstCosineMultiplied = cosine[burstPhase] << BURST_AMPLITUDE_SHIFT (with proper padding, widths, sign extension)
//wire signed [COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT:0] burstCosineMultiplied = {cosine[burstPhase], {BURST_AMPLITUDE_SHIFT{1'b0}}};

// burstCosineRounded = burstCosineMultiplied + (1 << COSINE_PRECISION_BITS-1)
/* verilator lint_off UNUSED */
//wire signed [COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT+1:0] burstCosineRounded =
//    {burstCosineMultiplied[COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT],burstCosineMultiplied} + (11'd1 << (COSINE_PRECISION_BITS-1));
//reg signed [COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT+1:0] burstCosineRoundedLatched;
/* verilator lint_on UNUSED */

// burstScaled = burstCosineRoundedLatched >> COSINE_PRECISION_BITS (with proper widths)
//wire signed [BURST_AMPLITUDE_SHIFT+1:0] burstScaled = burstCosineRoundedLatched[COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT+1:COSINE_PRECISION_BITS];

// burstLevel = BLANK_LEVEL + burstScaled (with proper padding, widths, sign extension)
//wire [DAC_BITS-1:0] burstLevel = BLANK_LEVEL[DAC_BITS-1:0] + {{(DAC_BITS-BURST_AMPLITUDE_SHIFT-2){burstScaled[BURST_AMPLITUDE_SHIFT+1]}},burstScaled};

// y is in the range of 0 to 255
// yScaled is the Y component in the range of 0 to 32640
//reg [14:0] yScaled;

// i is in the range of -152 to 152
// iScaled is the I component in the range of -19304 to 19304
//reg signed [16:0] iScaled;

// q is in the range of -133 to 133
// qScaled is the Q component in the range of -16891 to 16891
//reg signed [16:0] qScaled;

// Full-saturation yellow can swing up to 1.333*2^15=43680
// Full-saturation blue can swing down to -0.333*2^15=-10912
/* verilator lint_off UNUSED */
//wire signed [16:0] yiqSumRounded = {2'd0, yScaled} + iScaled + qScaled + 17'h200;
/* verilator lint_on UNUSED */

// Scale this into a level of LOWER_SWING_LEVEL to UPPER_SWING_LEVEL
// Scale by 27/54592=0.00049458 which is roughly 32/65536=0.000488 or simply >> 11
/* verilator lint_off UNUSED */
//wire [DAC_BITS:0] yiqLevelExtended = BLACK_LEVEL[DAC_BITS:0] + yiqSumRounded[16:11];
/* verilator lint_on UNUSED */

// yiqLevelExtended should be in the proper range of LOWER_SWING_LEVEL to UPPER_SWING_LEVEL, so truncate
//wire [DAC_BITS-1:0] yiqLevel = yiqLevelExtended[DAC_BITS-1:0];


reg [DAC_BITS-1:0] zeroOffset = BLANK_LEVEL[DAC_BITS-1:0];
reg signed [COSINE_PRECISION_BITS:0] phaseSine = 8'd0;
reg signed [COSINE_PRECISION_BITS:0] phaseCosine = 8'd0;

reg [7+COSINE_PRECISION_BITS:0] yComponent = 15'd0;
reg signed [8+COSINE_PRECISION_BITS+1:0] iComponent = 17'd0;
reg signed [8+COSINE_PRECISION_BITS+1:0] qComponent = 17'd0;

reg [DAC_BITS+DAC_LEVEL_SHIFT-1:0] zeroOffsetScaled = 16'd0;
/* verilator lint_off UNUSED */
reg signed [8+COSINE_PRECISION_BITS+1:0] compositeSum = 17'd0;
/* verilator lint_on UNUSED */

always @ (posedge phaseClock) begin
    if (reset) begin
        dacSample <= BLANK_LEVEL[DAC_BITS-1:0];
        zeroOffset <= BLANK_LEVEL[DAC_BITS-1:0];
        yLatched <= 8'h0;
        iLatched <= 9'h0;
        qLatched <= 9'h0;
    end else begin
        // Pipeline the calculation of dacSample so that burst and video data stay in phase
        
        // First stage: determine yLatched, iLatched, qLatched, zeroOffset, phaseCosine, phaseSine
        phaseCosine <= cosine[subcarrierPhase];
        phaseSine <= sine[subcarrierPhase];
        if (sync) begin
            zeroOffset <= SYNC_LEVEL[DAC_BITS-1:0];
            yLatched <= 8'h0;
            iLatched <= 9'h0;
            qLatched <= 9'h0;
        end else if (burst) begin
            zeroOffset <= BLANK_LEVEL[DAC_BITS-1:0];
            yLatched <= 8'h0;
            iLatched <= 9'd35;  //== 64*cos(-57deg)
            qLatched <= -9'd54; //== 64*sin(-57deg)
        end else if (blank) begin
            zeroOffset <= BLANK_LEVEL[DAC_BITS-1:0];
            yLatched <= 8'h0;
            iLatched <= 9'h0;
            qLatched <= 9'h0;
        end else begin
            zeroOffset <= BLACK_LEVEL[DAC_BITS-1:0];
            yLatched <= y;
            iLatched <= i;
            qLatched <= q;
        end
        
        // Second stage: multiply y, i, q and scale zeroOffset
        yComponent <= {yLatched, {(COSINE_PRECISION_BITS){1'b0}}};
        iComponent <= iLatched * phaseCosine;
        qComponent <= qLatched * phaseSine;
        // zeroOffsetScaled includes the "+0.5" factor so that truncation is rounding in the next stage
        zeroOffsetScaled <= {zeroOffset, 1'b1, {(DAC_LEVEL_SHIFT-1){1'b0}}};
        
        // Third stage: sum the components and offset
        compositeSum <= {2'b00,yComponent} + iComponent + qComponent + zeroOffsetScaled;
        
        // Final stage: truncate and shift into DAC range
        dacSample <= compositeSum[DAC_LEVEL_SHIFT+DAC_BITS-1:DAC_LEVEL_SHIFT];
    end
end

endmodule

