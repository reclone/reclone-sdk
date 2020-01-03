//
// VideoFormatTiming - Generate VGA-style timing signals, given the necessary timing parameters
//
// This timing generator maintains counters for the horizontal and vertical position in the
// video frame, whether in the blanking (off-screen, invisible) or active (on-screen, visible)
// region.  Based on the counters and timing parameters, Horizontal Sync (hsync), 
// Vertical Sync (vsync), and  Data Enable (de) are generated, along with the current pixel's
// coordinates, so that downstream modules can generate a video frame at the desired resolution.
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

module VideoFormatTiming
(
    input wire clock,
    input wire reset,
    input wire [6:0] hFrontPorch,
    input wire [7:0] hSyncPulse,
    input wire [7:0] hBackPorch,
    input wire [10:0] hActive,
    input wire [5:0] vFrontPorch,
    input wire [3:0] vSyncPulse,
    input wire [5:0] vBackPorch,
    input wire [10:0] vActive,
    input wire syncIsActiveLow,
    input wire isInterlaced,
    
    output reg dataEnable,
    output reg hSync,
    output reg vSync,
    output reg [11:0] hPos,
    output reg [10:0] vPos
);

reg [11:0] hCount = 0;
reg [10:0] vCount = 0;

wire [8:0] hBlank = {2'd0, hFrontPorch} + {1'd0, hSyncPulse} + {1'd0, hBackPorch};
wire [11:0] hTotal = {3'd0, hBlank} + hActive;

wire [6:0] vBlank = {1'd0, vFrontPorch} + {3'd0, vSyncPulse} + {1'd0, vBackPorch} + {5'd0, isInterlaced & vCount[0], 1'd0};
wire [10:0] vTotal = {4'd0, vBlank} + vActive;

wire [11:0] hCountNext;
wire [10:0] vCountNext;
wire hBlankNext = (hCountNext < {3'd0, hBlank});
wire vBlankNext = (vCountNext < {4'd0, vBlank});

always @ (*) begin
    if (hCount + 1'd1 < hTotal) begin
        hCountNext = hCount + 1'd1;
        vCountNext = vCount;
    end else begin
        hCountNext = 12'd0;
        if (vCount + 11'd1 + {10'd0, isInterlaced} < vTotal) begin
            vCountNext = vCount + 11'd1 + {10'd0, isInterlaced};
        end else begin
            vCountNext = 11'd0 + {10'd0, isInterlaced & ~vCount[0]};
        end
    end
end

always @ (posedge clock) begin
    if (reset == 1'b1) begin
        hCount <= 12'd0;
        vCount <= 11'd0;
        hSync <= syncIsActiveLow;
        vSync <= syncIsActiveLow;
        dataEnable <= 1'b0;
        hPos <= 12'd0;
        vPos <= 11'd0;
    end else begin
        hCount <= hCountNext;
        vCount <= vCountNext;
        hSync <= ((hCountNext >= {5'd0, hFrontPorch}) && (hCountNext < {5'd0, hFrontPorch} + {4'd0, hSyncPulse})) 
                    ^ syncIsActiveLow;
        vSync <= ((vCountNext > {5'd0, vFrontPorch} + {10'd0, (isInterlaced & vCountNext[0])} || 
                  (vCountNext == {5'd0, vFrontPorch} + {10'd0, (isInterlaced & vCountNext[0])} && 
                   hCountNext >= ({5'd0, hFrontPorch} + ((isInterlaced & vCountNext[0]) ? {1'd0, hTotal[11:1]} : 12'd0)))) 
              && ((vCountNext < {5'd0, vFrontPorch} + {7'd0, vSyncPulse} + {10'd0, (isInterlaced & vCountNext[0])}) || 
                  (vCountNext == {5'd0, vFrontPorch} + {7'd0, vSyncPulse} + {10'd0, (isInterlaced & vCountNext[0])} && 
                   hCountNext < ({5'd0, hFrontPorch} + ((isInterlaced & vCountNext[0]) ? {1'd0, hTotal[11:1]} : 12'd0))) ))
              ^ syncIsActiveLow;
        dataEnable <= !hBlankNext && !vBlankNext;
        hPos <= hBlankNext ? 12'd0 : (hCountNext - {3'd0, hBlank});
        vPos <= vBlankNext ? 11'd0 : (vCountNext - {4'd0, vBlank});
    end
end

endmodule

