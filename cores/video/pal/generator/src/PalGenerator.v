//
// PalGenerator - Generate DAC samples for PAL composite video, given timing and color signals
//
// This is a pretty simple way of doing decent-quality PAL composite video generation.
// To use fewer FPGA resources, the module is not very generic, and makes several assumptions:
//  - The provided PAL phase clock frequency must be f_subcarrier*16, roughly ‭70.9379‬ MHz.
//  - Y, U, and V are 9-bit signed values, with expected ranges corresponding to rgb-yuv conversion.
//  - The dacSample output is 5 bits, expecting roughly 5 IRE/bit (35.7 mV/bit) for an output
//    voltage range of 0 to 1.1 V when terminated with a 75 ohm load.  On a 3.3 V IO bank,
//    this can be implemented with a 5-bit R-2R resistor ladder DAC, where R=147.
//
// Granted the assumptions above, the module attempts to be FPGA-agnostic in that it does not
// manually instantiate any DSP primitives, but they may be inferred, if DSP slices are available
// and if the synthesis tool is smart enough.  On a Spartan-6/XST, two DSP48A1 slices are inferred
// to handle the U*cos() and V*sin() multiplications (and maybe the summations as well; not sure).
//
// The calculation of dacSample is pipelined so that burst and video data stay in phase,
// to potentially better utilize any inferred DSP slices, and so that slower FPGAs can handle the 
// math at ‭70.9379 MHz.
//
// See Rec. ITU-R BT.470-6 Figure 4 to see how the phase of the color burst relates to the
// chrominance axes.  U is "blue projection", while V is "red projection", and the color burst
// alternates +-135 degrees out of phase with the +U axis with each line ("Phase Alternating Line").
// To make the math simpler, and to make the structure of the module as compatible as possible with
// NTSC generation, this module considers +U to be truly in-phase with the subcarrier, while the
// color burst is the thing that is actually phase shifted.
//
// Negative Y (luminance) values are not used in normal video, but are allowed as input
// because certain test patterns (like SMPTE color bars) include a strip of "blacker than black"
// which can be used to calibrate the luminance on a TV or video equipment.
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

module PalGenerator
(
    input wire reset,
    input wire phaseClock, // frequency must be subcarrier*16 ~= ‭70.9379‬ MHz
    input wire [PHASE_BITS-1:0] subcarrierPhase, // 0 to 15
    input wire blank,
    input wire sync,
    input wire burst,
    input wire linePhase, // For color burst: 1=+135deg, 0=-135deg; For active video: 1=+V, 0=-V
    input wire signed [YUV_PRECISION_BITS:0] y, // 0 to 255, but can be slightly negative for a test pattern
    input wire signed [YUV_PRECISION_BITS:0] u, // -111 to 111
    input wire signed [YUV_PRECISION_BITS:0] v, // -157 to 157

    output reg [DAC_BITS-1:0] dacSample = BLANK_LEVEL[DAC_BITS-1:0]
);

localparam PHASE_BITS = 4;
localparam DAC_BITS = 5;
localparam SYNC_LEVEL = 0;
localparam BLANK_LEVEL = 8;
localparam BLACK_LEVEL = BLANK_LEVEL;

// In an active video region, considering just (yComponent + iComponent + qComponent):
//  - Full-saturation yellow can swing up to 1.322*2^15=43319
//  - Full-saturation blue can swing down to -0.322*2^15=-10551
//  - Therefore the peak-to-peak swing is 53870
// We want to scale this to a final DAC swing of 27 counts.
// 27/53870=0.00050121 which is roughly 32/65536=0.000488 or simply >> 11
localparam DAC_LEVEL_SHIFT = 11;

// Number of fraction bits in the fixed-point representation of cosine and sine values
localparam COSINE_PRECISION_BITS = 7;

// Number of fraction bits in the fixed-point representation of Y, U, V
localparam YUV_PRECISION_BITS = 8;

// Lookup table of cosine for each of the 16 phases
// Each phase angle increments by 22.5 degrees (pi/8 radians)
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

// Lookup table of sine for each of the 16 phases
// sin(x) = cos(x - 90deg)
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


// Registers to store Y, U, and V components in first pipeline stage for use in second stage
reg signed [YUV_PRECISION_BITS:0] yLatched = 9'd0;
reg signed [YUV_PRECISION_BITS:0] uLatched = 9'd0;
reg signed [YUV_PRECISION_BITS:0] vLatched = 9'd0;

// In the first stage, based on the state of sync/burst/blank, this register stores the
// "zero level" offset that will be added to the luma/chroma signal
reg [DAC_BITS-1:0] zeroOffset = BLANK_LEVEL[DAC_BITS-1:0];

// Registers to store the looked-up values of sine and cosine in first pipeline stage
reg signed [COSINE_PRECISION_BITS:0] phaseSine = 8'd0;
reg signed [COSINE_PRECISION_BITS:0] phaseCosine = 8'd0;

// Registers to store the multiplied/scaled component values in the second pipeline stage
reg signed [YUV_PRECISION_BITS+COSINE_PRECISION_BITS+1:0] yComponent = 17'd0;
reg signed [YUV_PRECISION_BITS+COSINE_PRECISION_BITS+1:0] uComponent = 17'd0;
reg signed [YUV_PRECISION_BITS+COSINE_PRECISION_BITS+1:0] vComponent = 17'd0;
reg [DAC_BITS+DAC_LEVEL_SHIFT-1:0] zeroOffsetScaled = 16'd0;

// Register to store the sum of the components in the third pipeline stage
/* verilator lint_off UNUSED */
reg signed [YUV_PRECISION_BITS+COSINE_PRECISION_BITS+1:0] compositeSum = 17'd0;
/* verilator lint_on UNUSED */


always @ (posedge phaseClock) begin
    if (reset) begin
        dacSample <= BLANK_LEVEL[DAC_BITS-1:0];
        zeroOffset <= BLANK_LEVEL[DAC_BITS-1:0];
        yLatched <= 9'h0;
        uLatched <= 9'h0;
        vLatched <= 9'h0;
    end else begin
        // Four stage pipeline to calculate the composite video signal from components
    
        // First stage: determine yLatched, iLatched, qLatched, zeroOffset, phaseCosine, phaseSine
        phaseCosine <= cosine[subcarrierPhase];
        phaseSine <= sine[subcarrierPhase];
        if (sync) begin
            zeroOffset <= SYNC_LEVEL[DAC_BITS-1:0];
            yLatched <= 9'h0;
            uLatched <= 9'h0;
            vLatched <= 9'h0;
        end else if (burst) begin
            zeroOffset <= BLANK_LEVEL[DAC_BITS-1:0];
            yLatched <= 9'h0;
            uLatched <= -9'd45;                      // 64*cos(+-135deg)
            vLatched <= linePhase ? 9'd45 : -9'd45;  // 64*sin(+-135deg)
        end else if (blank) begin
            zeroOffset <= BLANK_LEVEL[DAC_BITS-1:0];
            yLatched <= 9'h0;
            uLatched <= 9'h0;
            vLatched <= 9'h0;
        end else begin
            zeroOffset <= BLACK_LEVEL[DAC_BITS-1:0];
            yLatched <= y;
            uLatched <= u;
            vLatched <= linePhase ? v : -v;
        end
        
        // Second stage: multiply y, i, q and scale zeroOffset
        yComponent <= {yLatched[YUV_PRECISION_BITS], yLatched, {(COSINE_PRECISION_BITS){1'b0}}}; // 0 to 32640
        uComponent <= uLatched * phaseCosine;                                   // -14208 to 14208
        vComponent <= vLatched * phaseSine;                                     // -20096 to 20096
        // zeroOffsetScaled includes a "+0.5" offset so that truncation is rounding in the final stage
        zeroOffsetScaled <= {zeroOffset, 1'b1, {(DAC_LEVEL_SHIFT-1){1'b0}}};
        
        // Third stage: sum the components and offset
        // In an active video region, considering just (yComponent + iComponent + qComponent):
        //  - Full-saturation yellow can swing up to 1.322*2^15=43319
        //  - Full-saturation blue can swing down to -0.322*2^15=-10551
        // Adding zeroOffsetScaled = ((BLACK_LEVEL+0.5)<<DAC_LEVEL_SHIFT) = 17408,
        // compositeSum ranges from 6857 to 60727.  No overflow!  Not too shabby!
        compositeSum <= yComponent + uComponent + vComponent + zeroOffsetScaled;
        
        // Final stage: truncate and shift into DAC range (0 to 31)
        dacSample <= compositeSum[DAC_LEVEL_SHIFT+DAC_BITS-1:DAC_LEVEL_SHIFT];
    end
end

endmodule

