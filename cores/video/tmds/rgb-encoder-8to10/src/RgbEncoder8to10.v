//
// RgbEncoder8to10 - Encode eight pixel color bits into a DVI-D/HDMI transition minimized 10-bit word
//
// This encoding is used transmission of video data to convey the red, green, and blue components
// of a pixel's color.  The encoding algorithm is speccified and designed such that bit transitions
// are minimized and DC balance is maintained.
//
// A pixel clock must be provided for this encoder because it uses a register to keep track of the
// data stream "disparity", i.e. it tracks the excess ones and zeros that have been transmitted.
// The synchronous reset input should be asserted during the video leading guard band to properly
// zero-out the disparity register prior to beginning each video data period.
//
// Copyright 2019 Reclone Labs <reclonelabs.com>
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

module RgbEncoder8to10
(
    input wire clock,
    input wire reset,
    input wire[7:0] d,
    output wire[9:0] q
);

// disparity_cnt holds a signed value.  disparity_cnt[3] is the sign bit.
// disparity_cnt[3]==1 means disparity is negative, i.e. an excess number of zeros were transmitted
// disparity_cnt[3]==0 means disparity is zero/positive, i.e. a balance or excess number of ones were transmitted
reg [3:0] disparity_cnt = 4'd0;
wire [3:0] disparity_cnt_next;

wire [8:0] xored;
assign xored[0] = d[0];
assign xored[1] = xored[0] xor d[1];
assign xored[2] = xored[1] xor d[2];
assign xored[3] = xored[2] xor d[3];
assign xored[4] = xored[3] xor d[4];
assign xored[5] = xored[4] xor d[5];
assign xored[6] = xored[5] xor d[6];
assign xored[7] = xored[6] xor d[7];
assign xored[8] = 1;

wire [8:0] xnored;
assign xnored[0] = d[0];
assign xnored[1] = xnored[0] xnor d[1];
assign xnored[2] = xnored[1] xnor d[2];
assign xnored[3] = xnored[2] xnor d[3];
assign xnored[4] = xnored[3] xnor d[4];
assign xnored[5] = xnored[4] xnor d[5];
assign xnored[6] = xnored[5] xnor d[6];
assign xnored[7] = xnored[6] xnor d[7];
assign xnored[8] = 0;

wire [3:0] ones = d[0] + d[1] + d[2] + d[3] + d[4] + d[5] + d[6] + d[7];

wire use_xnored = (ones > 4'd4) or (ones == 4'd4 and d[0] == 1'b0);
wire [8:0] tmds_word = use_xnored ? xnored : xored;
wire [3:0] tmds_disparity = -4'd4 + tmds_word[0] + tmds_word[1] + tmds_word[2] + tmds_word[3] + 
                                    tmds_word[4] + tmds_word[5] + tmds_word[6] + tmds_word[7];

// This TMDS encoding algorithm was implemented from the Digital Video Interface (DVI) v1.0 specification.
// Based on 8 input data bits and a (ones minus zeros) disparity counter, produce a 
// 10-bit transition-minimized word that provides an approximate running DC balance in the bitstream.
// TMDS bits 7 to 0: running xor or xnor representation of the bit transitions in the input byte
// TMDS bit 8: Indicates whether xor(1) or xnor(0) was used to encode bit transitions in TMDS bits 7 to 0
// TMDS bit 9: Indicates whether TMDS bits 7 to 0 were inverted to improve DC balance of the bitstream
always @ (*) begin
    if (disparity_cnt == 4'd0 or tmds_disparity == 4'd0) begin
        q[9] <= !tmds_word[8];
        q[8] <= tmds_word[8];
        if (tmds_word[8] == 1'b1) begin

            q[7:0] <= tmds_word[7:0];

            // The next disparity count value is the current disparity count,
            // plus the difference: (number of ones minus number of zeros in TMDS bits 0 to 7).
            // From DVI Spec: Cnt(t) = Cnt(t-1) + (N_1{q_m[0:7]} - N_0{q_m[0:7]});
            disparity_cnt_next <= disparity_cnt + tmds_disparity;

        end else begin

            q[7:0] <= ~tmds_word[7:0];

            // The next disparity count value is the current disparity count,
            // plus the difference: (number of ones minus number of zeros in TMDS bits 0 to 7).
            // From DVI Spec: Cnt(t) = Cnt(t-1) + (N_0{q_m[0:7]} - N_1{q_m[0:7]});
            disparity_cnt_next <= disparity_cnt - tmds_disparity;

        end
    end else begin
        if (tmds_disparity[3] == disparity_cnt[3]) begin

            q[9] <= 1'b1;
            q[8] <= tmds_word[8];
            q[7:0] <= ~tmds_word[7:0];

            // The next disparity count value is the current disparity count, plus twice the value of TMDS bit 8,
            // plus the difference: (number of zeros minus number of ones in TMDS bits 0 to 7).
            // From DVI Spec: Cnt(t) = Cnt(t-1) + 2*q_m[8] + (N_0{q_m[0:7]} - N_1{q_m[0:7]});
            disparity_cnt_next <= disparity_cnt + tmds_word[8] + tmds_word[8] - tmds_disparity;

        end else begin

            q[9] <= 1'b0;
            q[8] <= tmds_word[8];
            q[7:0] <= tmds_word[7:0];

            // The next disparity count value is the current disparity count, minus twice the *inverted* value of TMDS bit 8,
            // plus the difference: (number of ones minus number of zeros in TMDS bits 0 to 7).
            // From DVI Spec: Cnt(t) = Cnt(t-1) - 2*(~q_m[8]) + (N_1{q_m[0:7]} - N_0{q_m[0:7]});
            disparity_cnt_next <= disparity_cnt - !tmds_word[8] - !tmds_word[8] + tmds_disparity;

        end
    end
end

// Reset or store the new disparity count on each positive clock edge
always @ (posedge clock) begin
    if (reset) begin
        disparity_cnt <= 4'd0;
    end else begin
        disparity_cnt <= disparity_cnt_next;
    end
end

endmodule