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

module NtscGenerator #
(
    parameter   PHASE_BITS = 4,
                DAC_BITS = 5,
                BLANK_LEVEL = 8,
                BURST_AMPLITUDE_SHIFT = 2,
                BLACK_LEVEL = 10,
                WHITE_LEVEL = 28,
                LOWER_SWING_LEVEL = 4,
                UPPER_SWING_LEVEL = 31
)
(
    input wire reset,
    input wire phaseClock,
    input wire [PHASE_BITS-1:0] subcarrierPhase,
    input wire blank,
    input wire sync,
    input wire burst,
    //input wire[7:0] y,
    //input wire signed[8:0] i,
    //input wire signed[8:0] q,

    output reg [DAC_BITS-1:0] dacSample = BLANK_LEVEL[DAC_BITS-1:0]
);

localparam SYNC_LEVEL = 0;
localparam GRAYSCALE_RANGE = WHITE_LEVEL - BLACK_LEVEL;
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

wire [3:0] burstPhase = subcarrierPhase + 4'd8;
wire signed [COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT:0] burstCosineMultiplied = {cosine[burstPhase], {BURST_AMPLITUDE_SHIFT{1'b0}}};
/* verilator lint_off UNUSED */
wire signed [COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT+1:0] burstCosineRounded =
    {burstCosineMultiplied[COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT],burstCosineMultiplied} + 11'h40;
/* verilator lint_on UNUSED */
wire signed [BURST_AMPLITUDE_SHIFT+1:0] burstScaled = burstCosineRounded[COSINE_PRECISION_BITS+BURST_AMPLITUDE_SHIFT+1:COSINE_PRECISION_BITS];
wire [DAC_BITS-1:0] burstLevel = BLANK_LEVEL[DAC_BITS-1:0] + {{(DAC_BITS-BURST_AMPLITUDE_SHIFT-2){burstScaled[BURST_AMPLITUDE_SHIFT+1]}},burstScaled};


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
            /*TODO*/ dacSample <= BLACK_LEVEL[DAC_BITS-1:0];
    end
end

endmodule
