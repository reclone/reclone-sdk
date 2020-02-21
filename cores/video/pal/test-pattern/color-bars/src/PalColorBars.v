//
// PalColorBars - SMPTE color bars pattern for PAL video
//
// TODO Description
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

module PalColorBars
(
    input wire palClock,
    input wire [9:0] hPos,
    input wire [9:0] vPos,
    input wire blank,
    input wire sync,
    input wire burst,
    
    output reg signed [8:0] y = 9'd0,
    output reg signed [8:0] u = 9'd0,
    output reg signed [8:0] v = 9'd0,
    output reg blankDelayed = 1'b1,
    output reg syncDelayed = 1'b0,
    output reg burstDelayed = 1'b0
);

always @ (posedge palClock) begin
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
            u <= 9'h00;
            v <= 9'h00;
        end else if (hPos < 10'd223) begin
            // 75% yellow
            y <= 9'd169;
            u <= 9'd61;
            v <= -9'd59;
        end else if (hPos < 10'd326) begin
            // 75% cyan
            y <= 9'd134;
            u <= -9'd114;
            v <= -9'd40;
        end else if (hPos < 10'd429) begin
            // 75% green
            y <= 9'd112;
            u <= -9'd53;
            v <= -9'd100;
        end else if (hPos < 10'd532) begin
            // 75% magenta
            y <= 9'd79;
            u <= 9'd53;
            v <= 9'd100;
        end else if (hPos < 10'd635) begin
            // 75% red
            y <= 9'd57;
            u <= 9'd114;
            v <= 9'd40;
        end else begin
            // 75% blue
            y <= 9'd22;
            u <= -9'd61;
            v <= 9'd59;
        end
    end else if (vPos < 10'd363) begin
        // Strip of blue, magenta, cyan, and white castellations
        if (hPos < 10'd120) begin
            // 75% blue
            y <= 9'd22;
            u <= -9'd61;
            v <= 9'd59;
        end else if (hPos < 10'd223) begin
            // black
            y <= 9'd0;
            u <= 9'd0;
            v <= 9'd0;
        end else if (hPos < 10'd326) begin
            // 75% magenta
            y <= 9'd79;
            u <= 9'd53;
            v <= 9'd100;
        end else if (hPos < 10'd429) begin
            // black
            y <= 9'd0;
            u <= 9'd0;
            v <= 9'd0;
        end else if (hPos < 10'd532) begin
            // 75% cyan
            y <= 9'd134;
            u <= -9'd114;
            v <= -9'd40;
        end else if (hPos < 10'd635) begin
            // black
            y <= 9'd0;
            u <= 9'd0;
            v <= 9'd0;
        end else begin
            // 75% white
            y <= 9'd235;
            u <= 9'h00;
            v <= 9'h00;
        end
    end else begin
        // Calibration ranges and pluge pulse
        // Starts with four wider bars 5*103/4=129 pixels per wide bar
        // 17 overscan pixels on left and right sides
        if (hPos < 10'd146) begin
            // -I at the same magnitude as color burst
            y <= 9'd0;
            u <= -9'd64;
            v <= 9'd0;
        end else if (hPos < 10'd275) begin
            // 100% white
            y <= 9'd255;
            u <= 9'd0;
            v <= 9'd0;
        end else if (hPos < 10'd404) begin
            // +Q at the same magnitude as color burst
            y <= 9'd0;
            u <= 9'd0;
            v <= 9'd64;
        end else if (hPos < 10'd532) begin
            // black
            y <= 9'd0;
            u <= 9'd0;
            v <= 9'd0;
        end else if (hPos < 10'd566) begin
            // 4% below black
            y <= -9'd10;
            u <= 9'd0;
            v <= 9'd0;
        end else if (hPos < 10'd601) begin
            // black
            y <= 9'd0;
            u <= 9'd0;
            v <= 9'd0;
        end else if (hPos < 10'd635) begin
            // 4% above black
            y <= 9'd10;
            u <= 9'd0;
            v <= 9'd0;
        end else begin
            // black
            y <= 9'd0;
            u <= 9'd0;
            v <= 9'd0;
        end
    end
end

endmodule