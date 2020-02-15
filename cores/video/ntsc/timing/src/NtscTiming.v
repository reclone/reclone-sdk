//
// NtscTiming - Generate timing signals required for an NTSC composite video output
//
//
// NTSC color burst frequency: 3.579545454... MHz
// Cycle period: 1000000 us/s  /  3579545.454 cyc/s  =  279.4 ns
//
// Four pixels per color burst cycle; one pixel is one quarter of the subcarrier cycle period
// 279.4 ns/cyc  /  4 pix/cyc  =  69.85 ns/pix
//
// Line period: 63.55556 us = 227.5 color burst cycles = 910 pixels (#1)
// Line-blanking interval: 10.9+-0.2 us = 39 color burst cycles = 156 pixels
// Front porch: 1.27 to 2.22 us => 1.68 us = 6 color burst cycles = 24 pixels
// Synchronizing pulse: 4.7+-0.1 us = 17 color burst cycles = 68 pixels
// Breezeway: 0.55 us = 2 color burst cycles = 8 pixels
// Sub-carrier burst: 2.23 to 3.11 us => 9 color burst cycles = 36 pixels
// Back porch: 39 - 6 - 17 - 2 - 9 = 5 color burst cycles = 20 pixels
// Active video: 52.65556 us = 188.5 color burst cycles = 754 pixels
// Equalizing pulse: 2.35 us = 34 pixels (occurs twice per line)
// Field-synchronizing pulse: 27.1 us = 388 pixels (occurs twice per line)
//
// Interlaced scanning:
// Frame period: 525 horizontal lines
// Field period: 262.5 lines
// Preequalization pulses: 3 lines
// Vertical synch pulses: 3 lines
// Postequalization pulses: 3 lines
// Vertical retrace settling time: 11 lines
// Active video: 242.5 lines
//
// "Fake progressive" scanning:
// Frame period: 262 horizontal lines
// Preequalization pulses: 3 lines
// Vertical synch pulses: 3 lines
// Postequalization pulses: 3 lines
// Vertical retrace settling time: 11 lines
// Active video: 242 lines
//
// (#1) If "progressive" is set, the 0th scan line is reduced by
// 0.5 color burst period (2 pixels) so that the subcarrier phase alternates
// on each frame, helping to visually cancel out chroma-luma interference
// patterns, but causing the image to "dot crawl" at half the frame rate.
//
// http://www.kolumbus.fi/pami1/video/pal_ntsc.html
// https://sagargv.blogspot.com/2014/07/ntsc-demystified-color-demo-with.html
// https://sagargv.blogspot.com/2011/04/ntsc-demystified-nuances-and-numbers.html
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

module NtscTiming # (parameter PHASE_BITS = 4)
(
    input wire reset,
    input wire phaseClock,
    input wire progressive,
    
    output reg [PHASE_BITS-1:0] phase = {2'h1, {(PHASE_BITS-2){1'b0}}},
    output reg blank = 1'b1,
    output reg hSync = 1'b0,
    output reg vSync = 1'b0,
    output reg sync = 1'b0,
    output reg burst = 1'b0,
    output reg [9:0] hPos = 10'd0,
    output reg [9:0] vPos = 10'd0
);


reg [9:0] hCount = 0;
reg [9:0] vCount = 0;

wire [9:0] hTotal = (progressive == 1'b1 && vCount == (vPreEqualization + vSyncPulse + vPostEqualization)) ? 10'd908 : 10'd910;
wire [9:0] vTotalProgressive = 10'd262;
wire [9:0] vTotalInterlaced = 10'd525;
wire [9:0] vTotal = progressive ? vTotalProgressive : vTotalInterlaced;

wire hLastPixel = hCount + 1'd1 >= hTotal;
wire vLastLine = (vCount + 10'd1) >= vTotal;

wire [9:0] hCountNext = hLastPixel ? 10'd0 : hCount + 10'd1;
wire [9:0] vCountNext = hLastPixel ? (vLastLine ? 10'd0 : vCount + 10'd1) : vCount;

wire [9:0] hFrontPorch = 10'd24;
wire [9:0] hSyncPulse = 10'd68;
wire [9:0] hBreezeway = 10'd8;
wire [9:0] hBurst = 10'd36;
wire [9:0] hBackPorch = 10'd20;
wire hSyncNext = (hCountNext >= hFrontPorch) && (hCountNext < hFrontPorch + hSyncPulse);

wire hBlankNext = (hCountNext < hFrontPorch + hSyncPulse + hBreezeway + hBurst + hBackPorch);

wire [9:0] vPreEqualization = 10'd3;
wire [9:0] vSyncPulse = 10'd3;
wire [9:0] vPostEqualization = 10'd3;
wire [9:0] vRetrace = 10'd11;
wire vSyncNext = ((vCountNext >= vPreEqualization) && (vCountNext < vPreEqualization + vSyncPulse)) ||
                 ((((vCountNext == vTotalProgressive + vPreEqualization) && (hCountNext >= {1'b0, hTotal[9:1]})) || (vCountNext > vTotalProgressive + vPreEqualization)) &&
                  (((vCountNext == vTotalProgressive + vPreEqualization + vSyncPulse) && (hCountNext < {1'b0, hTotal[9:1]})) || (vCountNext < vTotalProgressive + vPreEqualization + vSyncPulse)));

wire vBlankNext = (vCountNext < vPreEqualization + vSyncPulse + vPostEqualization + vRetrace) ||
                  ((((vCountNext == vTotalProgressive) && (hCountNext >= {1'b0, hTotal[9:1]})) || (vCountNext > vTotalProgressive)) &&
                   (((vCountNext == vTotalProgressive + vPreEqualization + vSyncPulse + vPostEqualization + vRetrace) && (hCountNext < {1'b0, hTotal[9:1]})) || 
                    (vCountNext < vTotalProgressive + vPreEqualization + vSyncPulse + vPostEqualization + vRetrace)));

wire burstNext = !vBlankNext && (hCountNext >= hFrontPorch + hSyncPulse + hBreezeway) && (hCountNext < hFrontPorch + hSyncPulse + hBreezeway + hBurst);

wire vEqualizingPulsesNext = !vSyncNext &&
                             ((vCountNext < vPreEqualization + vSyncPulse + vPostEqualization) ||
                              ((((vCountNext == vTotalProgressive) && (hCountNext >= {1'b0, hTotal[9:1]})) || (vCountNext > vTotalProgressive)) &&
                               (((vCountNext == vTotalProgressive + vPreEqualization + vSyncPulse + vPostEqualization) && (hCountNext < {1'b0, hTotal[9:1]})) || 
                                (vCountNext < vTotalProgressive + vPreEqualization + vSyncPulse + vPostEqualization))));

wire [9:0] equalizingPulseWidth = 10'd34;
wire equalizingSyncPulseNext = ((hCountNext >= hFrontPorch) && (hCountNext < equalizingPulseWidth + hFrontPorch)) || ((hCountNext >= {1'b0, hTotal[9:1]} + hFrontPorch) && (hCountNext < {1'b0, hTotal[9:1]} + equalizingPulseWidth + hFrontPorch));

wire [9:0] fieldSynchronizingPulseWidth = 10'd388;
wire verticalSyncPulseNext = ((hCountNext >= hFrontPorch) && (hCountNext < fieldSynchronizingPulseWidth + hFrontPorch)) || ((hCountNext >= {1'b0, hTotal[9:1]} + hFrontPorch) && (hCountNext < {1'b0, hTotal[9:1]} + fieldSynchronizingPulseWidth + hFrontPorch));

wire syncNext = (!vEqualizingPulsesNext && !vSyncNext && hSyncNext) || 
                (vEqualizingPulsesNext && equalizingSyncPulseNext) ||
                (vSyncNext && verticalSyncPulseNext);

wire [9:0] hPosNext = hBlankNext ? 10'd0 : (hCountNext - hFrontPorch - hSyncPulse - hBreezeway - hBurst - hBackPorch);

/* verilator lint_off UNUSED */
wire [10:0] vPosFirstFieldNext  = vBlankNext ? 11'd1 : {vCountNext - vPreEqualization - vSyncPulse - vPostEqualization - vRetrace, 1'b1};
wire [10:0] vPosSecondFieldNext = vBlankNext ? 11'd0 : {vCountNext - vTotalProgressive - vPreEqualization - vSyncPulse - vPostEqualization - vRetrace, 1'b0};
/* verilator lint_on UNUSED */

wire [9:0] vPosInterlacedNext = (vCountNext < vTotalProgressive || (vCountNext == vTotalProgressive && hCountNext < {1'b0, hTotal[9:1]}))
                            ? vPosFirstFieldNext[9:0] : vPosSecondFieldNext[9:0];
wire [9:0] vPosProgressiveNext = vBlankNext ? 10'd0 : (vCountNext - vPreEqualization - vSyncPulse - vPostEqualization - vRetrace);

wire [9:0] vPosNext = progressive ? vPosProgressiveNext : vPosInterlacedNext;

always @ (posedge phaseClock) begin
    if (reset == 1'b1) begin
        phase <= {2'h1, {(PHASE_BITS-2){1'b0}}};
        hCount <= 10'd0;
        vCount <= 10'd0;
        hPos <= 10'd0;
        vPos <= 10'd0;
        blank <= 1'b1;
        hSync <= 1'b0;
        vSync <= 1'b0;
        sync <= 1'b0;
        burst <= 1'b0;
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
            hPos <= hPosNext;
            vPos <= vPosNext;
        end

        // Increment phase counter
        phase <= phase + {{(PHASE_BITS-1){1'b0}}, 1'b1};
    end
end


endmodule
