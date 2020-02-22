//
// PalTiming - Generate timing signals required for a PAL composite video output
//
//
// PAL color burst frequency: 4.43361875 MHz
// Cycle period: 1000000 us/s  /  4433618.75 cyc/s  =  225.55 ns
//
// Four pixels per color burst cycle; one pixel is one quarter of the subcarrier cycle period
// 225.55 ns/cyc  /  4 pix/cyc  =  56.387 ns/pix
//
// Line period: 64 us = 283.75 color burst cycles = 1135 pixels
// Line-blanking interval: 11.7 to 12 us = 53 color burst cycles = 212 pixels
// Front porch: 1.5 to 1.8 us => 1.579 us = 7 color burst cycles = 28 pixels
// Synchronizing pulse: 4.5 to 4.9 us = 21 color burst cycles = 84 pixels
// Breezeway: 0.9 us = 4 color burst cycles = 16 pixels
// Sub-carrier burst: 2.25+-0.23 us => 10 color burst cycles = 40 pixels
// Back porch: 53 - 7 - 21 - 4 - 10 = 11 color burst cycles = 44 pixels
// Active video: 52.04552 us = 230.75 color burst cycles = 923 pixels
// Equalizing pulse: 2.35+-0.1 us = 42 pixels (occurs twice per line)
// Field-synchronizing pulse: 27.3 us = 484 pixels (occurs twice per line)
//
// Interlaced scanning:
// Frame period: 625 horizontal lines
// Field period: 312.5 lines
// Preequalization pulses: 2.5 lines
// Vertical synch pulses: 2.5 lines
// Postequalization pulses: 2.5 lines
// Vertical retrace settling time: 17.5 lines
// Active video: 287.5 lines per field
//
// "Fake progressive" scanning:
// Frame period: 312 horizontal lines (includes two half-lines)
// Preequalization pulses: 2.5 lines
// Vertical synch pulses: 2.5 lines
// Postequalization pulses: 2.5 lines
// Vertical retrace settling time: 17.5 lines
// Active video: 287 lines
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

module PalTiming # (parameter PHASE_BITS = 4)
(
    input wire reset,
    input wire phaseClock,
    input wire progressive,
    
    output reg [PHASE_BITS-1:0] phase = {(PHASE_BITS){1'b0}},
    output reg blank = 1'b1,
    output reg hSync = 1'b0,
    output reg vSync = 1'b0,
    output reg sync = 1'b0,
    output reg burst = 1'b0,
    output reg burstPhase = 1'b0,
    output reg [9:0] hPos = 10'd355,
    output reg [9:0] vPos = 10'd0
);

reg [10:0] hCount = 11'd567;
reg [9:0] vCount = 10'd0;
reg [1:0] fieldCount = 2'd3;

wire [10:0] hTotal = 11'd1135;
wire [9:0] vTotalProgressive = 10'd312;
wire [9:0] vTotalInterlaced = 10'd625;
wire [9:0] vTotal = progressive ? vTotalProgressive : vTotalInterlaced;

wire hLastPixel = (hCount + 11'd1) >= hTotal;
wire vLastLine = (vCount == vTotal);

wire [10:0] hCountNext = hLastPixel ? 11'd0 : hCount + 11'd1;
wire [9:0] vCountNext = hLastPixel ? (vCount + 10'd1) : 
                            ((vLastLine && (hCountNext >= {1'b0, hTotal[10:1]})) ? 10'd0 : vCount);

wire [10:0] hFrontPorch = 11'd28;
wire [10:0] hSyncPulse = 11'd84;
wire [10:0] hBreezeway = 11'd16;
wire [10:0] hBurst = 11'd40;
wire [10:0] hBackPorch = 11'd44;
wire hSyncNext = (hCountNext >= hFrontPorch) && (hCountNext < hFrontPorch + hSyncPulse);

wire hBlankNext = (hCountNext < hFrontPorch + hSyncPulse + hBreezeway + hBurst + hBackPorch);

wire [10:0] vPreEqualizationHalfLines = 11'd5;
wire [10:0] vSyncPulseHalfLines = 11'd5;
wire [10:0] vPostEqualizationHalfLines = 11'd5;
wire [10:0] vRetraceHalfLines = 11'd35;
wire [10:0] vTotalProgressiveHalfLines = {vTotalProgressive, 1'b0};
wire [10:0] vFieldInterlacedHalfLines = {vTotalProgressive, 1'b1};

wire [10:0] vCountNextHalfLines = {vCountNext, (hCountNext >= {1'b0, hTotal[10:1]}) ? 1'b1 : 1'b0};

wire vSyncNext = ((vCountNextHalfLines > vPreEqualizationHalfLines) && (vCountNextHalfLines <= vPreEqualizationHalfLines + vSyncPulseHalfLines)) ||
                 ((vCountNextHalfLines > vPreEqualizationHalfLines + vFieldInterlacedHalfLines) && (vCountNextHalfLines <= vPreEqualizationHalfLines + vSyncPulseHalfLines + vFieldInterlacedHalfLines));

wire vBlankNext = (vCountNextHalfLines <= vPreEqualizationHalfLines + vSyncPulseHalfLines + vPostEqualizationHalfLines + vRetraceHalfLines) ||
                  ((vCountNextHalfLines > vFieldInterlacedHalfLines) && (vCountNextHalfLines <= vFieldInterlacedHalfLines + vPreEqualizationHalfLines + vSyncPulseHalfLines + vPostEqualizationHalfLines + vRetraceHalfLines));

wire burstBlankingNext = (vCountNextHalfLines < vPreEqualizationHalfLines + vSyncPulseHalfLines + vPostEqualizationHalfLines + {9'd0, (2'd2 - fieldCount)}) ||
                         (vCountNextHalfLines >= vFieldInterlacedHalfLines - {9'd0, (fieldCount + 2'd2)} && vCountNextHalfLines < vFieldInterlacedHalfLines + vPreEqualizationHalfLines + vSyncPulseHalfLines + vPostEqualizationHalfLines + {9'd0, (2'd2 - fieldCount)}) ||
                         (vCountNextHalfLines >= vFieldInterlacedHalfLines + vFieldInterlacedHalfLines - {9'd0, (fieldCount + 2'd2)});

wire burstNext = !burstBlankingNext && (hCountNext >= hFrontPorch + hSyncPulse + hBreezeway) && (hCountNext < hFrontPorch + hSyncPulse + hBreezeway + hBurst);

wire burstPhaseNext = (fieldCount[1] == !vCount[0]);

wire vEqualizingPulsesNext = !vSyncNext &&
                             ((vCountNextHalfLines <= vPreEqualizationHalfLines + vSyncPulseHalfLines + vPostEqualizationHalfLines) ||
                              ((vCountNextHalfLines > vFieldInterlacedHalfLines) && 
                               (vCountNextHalfLines <= vFieldInterlacedHalfLines + vPreEqualizationHalfLines + vSyncPulseHalfLines + vPostEqualizationHalfLines)));

wire [10:0] equalizingPulseWidth = 11'd42;
wire equalizingSyncPulseNext = ((hCountNext >= hFrontPorch) && (hCountNext < equalizingPulseWidth + hFrontPorch)) || ((hCountNext >= {1'b0, hTotal[10:1]} + hFrontPorch) && (hCountNext < {1'b0, hTotal[10:1]} + equalizingPulseWidth + hFrontPorch));

wire [10:0] fieldSynchronizingPulseWidth = 11'd484;
wire verticalSyncPulseNext = ((hCountNext >= hFrontPorch) && (hCountNext < fieldSynchronizingPulseWidth + hFrontPorch)) || ((hCountNext >= {1'b0, hTotal[10:1]} + hFrontPorch) && (hCountNext < {1'b0, hTotal[10:1]} + fieldSynchronizingPulseWidth + hFrontPorch));

wire syncNext = (!vEqualizingPulsesNext && !vSyncNext && hSyncNext) || 
                (vEqualizingPulsesNext && equalizingSyncPulseNext) ||
                (vSyncNext && verticalSyncPulseNext);

/* verilator lint_off UNUSED */
wire [10:0] hPosNext = hBlankNext ? 11'd0 : (hCountNext - hFrontPorch - hSyncPulse - hBreezeway - hBurst - hBackPorch);

wire [10:0] vPosFirstFieldNextHalfLines = vBlankNext ? 11'd0 : vCountNextHalfLines - vPreEqualizationHalfLines - vSyncPulseHalfLines - vPostEqualizationHalfLines - vRetraceHalfLines;
wire [10:0] vPosSecondFieldNextHalfLines = vBlankNext ? 11'd0 : vCountNextHalfLines - vTotalProgressiveHalfLines - vPreEqualizationHalfLines - vSyncPulseHalfLines - vPostEqualizationHalfLines - vRetraceHalfLines - 11'd2;
/* verilator lint_on UNUSED */

wire [9:0] vPosInterlacedNext = (vCountNextHalfLines <= vFieldInterlacedHalfLines)
                            ? {vPosFirstFieldNextHalfLines[9:1], 1'b0} : {vPosSecondFieldNextHalfLines[9:1], 1'b1};

/* verilator lint_off UNUSED */
wire [10:0] vPosProgressiveNextHalfLines = vBlankNext ? 11'd0 : (vCountNextHalfLines - vPreEqualizationHalfLines - vSyncPulseHalfLines - vPostEqualizationHalfLines - vRetraceHalfLines);
/* verilator lint_on UNUSED */

wire [9:0] vPosNext = progressive ? vPosProgressiveNextHalfLines[10:1] : vPosInterlacedNext;


always @ (posedge phaseClock) begin
    if (reset == 1'b1) begin
        phase <= {(PHASE_BITS){1'b0}};
        hCount <= 11'd568;
        vCount <= 10'd0;
        hPos <= 10'd380;
        vPos <= 10'd0;
        blank <= 1'b1;
        hSync <= 1'b0;
        vSync <= 1'b0;
        sync <= 1'b0;
        burst <= 1'b0;
        burstPhase <= 1'b0;
        fieldCount <= 2'd3;
    end else begin
        // If the low bits of phase are 1, it's time to increment the pixel position
        if (phase[PHASE_BITS-3:0] == {(PHASE_BITS-2){1'b1}}) begin
            hCount <= hCountNext;
            vCount <= vCountNext;
            hSync <= hSyncNext;
            vSync <= vSyncNext;
            blank <= hBlankNext || vBlankNext;
            sync <= syncNext;
            burst <= burstNext;
            burstPhase <= burstPhaseNext;
            hPos <= hPosNext[9:0];
            vPos <= vPosNext;
            
            if (vSyncNext == 1'b1 && vSync == 1'b0) begin
                // Active edge of vertical sync, so increment field counter
                fieldCount <= fieldCount + 2'd1;
            end
        end

        // Increment phase counter
        phase <= phase + {{(PHASE_BITS-1){1'b0}}, 1'b1};
    end
end

endmodule
