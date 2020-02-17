//
// NtscColorBars - A standard test pattern for NTSC standard-definition video
//
// The SMPTE color bars test pattern "gives video engineers an indication of how an NTSC
// video signal has been altered by recording or transmission and what adjustments must be made
// to bring it back to specification. It is also used for setting a television monitor or
// receiver to reproduce NTSC chrominance and luminance information correctly."
//
// This test pattern is based on the description in the SMPTE color bars article in Wikipedia:
// https://en.wikipedia.org/wiki/SMPTE_color_bars
//
// The module takes as input the subcarrier phase clock, the horizontal and vertical pixel
// position on the scanline, and the blank, sync, and burst signals.  The module outputs
// registered Y, I, and Q values for the pixel at the current position, and delayed blank,
// sync, and burst, to keep those signals aligned with the registered YIQ outputs.
//
// Note: The luma (Y) output from this module is 9-bit signed, so that it can output a level of
// super-black or "blacker than black" which is 4% below normal black level, which is used in the
// test pattern for adjusting the bottom of the luminance range.
//
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

module NtscColorBars
(
    input wire ntscClock,
    input wire [9:0] hPos,
    input wire [9:0] vPos,
    input wire blank,
    input wire sync,
    input wire burst,
    
    output reg signed [8:0] y = 9'd0,
    output reg signed [8:0] i = 9'd0,
    output reg signed [8:0] q = 9'd0,
    output reg blankDelayed = 1'b1,
    output reg syncDelayed = 1'b0,
    output reg burstDelayed = 1'b0
);

always @ (posedge ntscClock) begin
    blankDelayed <= blank;
    syncDelayed <= sync;
    burstDelayed <= burst;

    if (vPos < 10'd324) begin
        // Main set of seven color bars
        // 720/7=103 pixels per bar
        // 17 overscan pixels on left and right sides
        if (hPos < 10'd120) begin
            // 75% white
            y <= 9'd235;
            i <= 9'h00;
            q <= 9'h00;
        end else if (hPos < 10'd223) begin
            // 75% yellow
            y <= 9'd169;
            i <= 9'd61;
            q <= -9'd59;
        end else if (hPos < 10'd326) begin
            // 75% cyan
            y <= 9'd134;
            i <= -9'd114;
            q <= -9'd40;
        end else if (hPos < 10'd429) begin
            // 75% green
            y <= 9'd112;
            i <= -9'd53;
            q <= -9'd100;
        end else if (hPos < 10'd532) begin
            // 75% magenta
            y <= 9'd79;
            i <= 9'd53;
            q <= 9'd100;
        end else if (hPos < 10'd635) begin
            // 75% red
            y <= 9'd57;
            i <= 9'd114;
            q <= 9'd40;
        end else begin
            // 75% blue
            y <= 9'd22;
            i <= -9'd61;
            q <= 9'd59;
        end
    end else if (vPos < 10'd363) begin
        // Strip of blue, magenta, cyan, and white castellations
        if (hPos < 10'd120) begin
            // 75% blue
            y <= 9'd22;
            i <= -9'd61;
            q <= 9'd59;
        end else if (hPos < 10'd223) begin
            // black
            y <= 9'd0;
            i <= 9'd0;
            q <= 9'd0;
        end else if (hPos < 10'd326) begin
            // 75% magenta
            y <= 9'd79;
            i <= 9'd53;
            q <= 9'd100;
        end else if (hPos < 10'd429) begin
            // black
            y <= 9'd0;
            i <= 9'd0;
            q <= 9'd0;
        end else if (hPos < 10'd532) begin
            // 75% cyan
            y <= 9'd134;
            i <= -9'd114;
            q <= -9'd40;
        end else if (hPos < 10'd635) begin
            // black
            y <= 9'd0;
            i <= 9'd0;
            q <= 9'd0;
        end else begin
            // 75% white
            y <= 9'd235;
            i <= 9'h00;
            q <= 9'h00;
        end
    end else begin
        // Calibration ranges and pluge pulse
        // Starts with four wider bars 5*103/4=129 pixels per wide bar
        // 17 overscan pixels on left and right sides
        if (hPos < 10'd146) begin
            // -I at the same magnitude as color burst
            y <= 9'd0;
            i <= -9'd64;
            q <= 9'd0;
        end else if (hPos < 10'd275) begin
            // 100% white
            y <= 9'd255;
            i <= 9'd0;
            q <= 9'd0;
        end else if (hPos < 10'd404) begin
            // +Q at the same magnitude as color burst
            y <= 9'd0;
            i <= 9'd0;
            q <= 9'd64;
        end else if (hPos < 10'd532) begin
            // black
            y <= 9'd0;
            i <= 9'd0;
            q <= 9'd0;
        end else if (hPos < 10'd566) begin
            // 4% below black
            y <= -9'd10;
            i <= 9'd0;
            q <= 9'd0;
        end else if (hPos < 10'd601) begin
            // black
            y <= 9'd0;
            i <= 9'd0;
            q <= 9'd0;
        end else if (hPos < 10'd635) begin
            // 4% above black
            y <= 9'd10;
            i <= 9'd0;
            q <= 9'd0;
        end else begin
            // black
            y <= 9'd0;
            i <= 9'd0;
            q <= 9'd0;
        end
    end
end

endmodule