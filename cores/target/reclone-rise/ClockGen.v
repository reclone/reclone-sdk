//
// reclone-rise/ClockGen - Generate clocks required by HDMI, composite video out, audio DAC, etc.
//
// From a 10 MHz input clock, generate all sorts of required clocks using the two
// Clock Management Tiles (CMTs) present in the XC6SLX16, using Spartan-6 clock management primitives.
//
// From UG-382 (Spartan-6 Clocking Resources), each CMT has one phase-locked loop (PLL) that is
// closely coupled with two Digital Clock Managers (DCMs) and various clocking primitives.
//
// A PLL takes an input clock, multiplies it to 400-1000 MHz (using a voltage-controlled oscillator [VCO]),
// then divides it, using up to six different denominators, with a specified phase relationship.
// The PLL also acts as a jitter filter, making PLL outputs well suited for HDMI, DDR2 SDRAM, and
// other interfaces that should have low jitter.
// PLL_BASE is the simpler PLL primitive, while PLL_ADV is the more advanced, full-featured primitive.
//
// A DCM provides frequency synthesis, clock deskew, and phase shifting.  It multiplies and divides
// an input clock to produce CLKFX (5-333 MHz), then it can divide again to produce CLKFXDV
// *without* preserving a phase relationship.  A DCM does not act as a jitter filter, so its output 
// should be used as an input to a PLL, or for applications where some jitter can be tolerated.
// DCM_SP is the classic primitive with more deskew and phase shifting capabilities, whereas
// DCM_CLKGEN has more flexibility and lower output jitter for frequency synthesis.
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


module ClockGen
(
    input   clk10m,             // 10       MHz
    output  hdmiPixelClock,     // 74.25    MHz     (720p60, 1080i60, 1080p30 and others)
    output  hdmiDataLoadClock,  // 148.5    MHz
    output  hdmiIoClock,        // 742.5    MHz
    output  hdmiSerDesStrobe,   // Data load strobe signal to use with HDMI SERDES primitives
    output  dpiPixelClock,      // Display Parallel Interface pixel clock for LCD, VGA, SVGA, XVGA, etc.
    output  ntscClock,          // 57.27273 MHz     (NTSC color burst frequency x16)
    output  palClock,           // ‭70.9379 ‬ MHz     (PAL  color burst frequency x16)
    output  audioClock,         // 90       MHz     (48kHz x1875 sigma-delta frequency)
    output  ddrClock            // 
);

// -- First Clock Management Tile --

// Most of the interesting HDMI output formats require a 74.25 MHz pixel clock (720p, 1080i, etc.).
// HDMI generation also requires a x2 clock for data load, and a x10 IO clock for each SERDES.
// So our goal is to convert our 10 MHz oscillator input to a PLL VCO output of 742.5 MHz,
// which we can divide to get our 148.5 and 74.25 MHz clocks, while getting as many other
// useful clock frequencies as we can along the way.

// DCM_CLKGEN:  [10 MHz CLKIN] * [9 CLKFX_MULTIPLY] / [1 CLKFX_DIVIDE] = [90 MHz CLKFX] <-- HDMI PLL input, DPI gen input, 48 kHz * 1875 audio clock

// PLL_BASE:    [90 MHz CLKIN] / [4 DIVCLK_DIVIDE] = [22.5 MHz DIVCLK_OUT]
//              [22.5 MHz DIVCLK_OUT] * [33 CLKFBOUT_MULT] = [742.5 MHz internal VCO OUT]
//              [742.5 MHz DIVCLK OUT] / [ 1 CLKOUT0_DIVIDE] = [742.5  MHz CLKOUT0] <-- hdmiIoClock
//              [742.5 MHz DIVCLK OUT] / [ 2 CLKOUT1_DIVIDE] = [371.25 MHz CLKOUT1 @  0deg phase] <-- hdmiQdrClock0
//              [742.5 MHz DIVCLK OUT] / [ 2 CLKOUT2_DIVIDE] = [371.25 MHz CLKOUT2 @ 90deg phase] <-- hdmiQdrClock90
//              [742.5 MHz DIVCLK OUT] / [ 5 CLKOUT3_DIVIDE] = [148.5  MHz CLKOUT3] <-- hdmiDataLoadClock
//              [742.5 MHz DIVCLK OUT] / [10 CLKOUT4_DIVIDE] = [ 74.25 MHz CLKOUT4] <-- hdmiPixelClock
//              [742.5 MHz DIVCLK OUT] / [33 CLKOUT5_DIVIDE] = [ 22.5  MHz CLKOUT5] <-- jitter filtered CLKIN for NTSC DCM

// DCM_CLKGEN:  [22.5 MHz CLKIN] * [28 CLKFX_MULTIPLY] / [11 CLKFX_DIVIDE] = [57.2727... MHz CLKFX] <- ntscClock


// -- Second Clock Management Tile --

// The Spartan-6 Memory Controller Block (MCB) requires two clocks, sysclk_2x and sysclk_2x_180, which are clocks
// at the *data rate* of the DDR2 channel, offset in phase by 180 degrees.  These two clocks must be output from
// a PLL's CLKOUT0 and CLKOUT1 into a BUFPLL_MCB primitive, which buffers the clocks and generates clock enable strobes,
// pll_ce_0 and pll_ce_90, required by the MCB.
// Another clock required by the MCB is a calibration clock, mcb_drp_clk, phase-synchronized with the sysclk_2x domain
// and at least 50 MHz for good calibration performance, and with a typical achievable frequency of 100 MHz.
// Standard performance range of the MCB limits DDR2 to 625 Mb/s on a -2 speed grade Spartan-6.
// PLL VCO frequency must be between 400 and 1000 MHz.  Therefore, MCB sysclk_2x should generally be between
// 400 and 625 MHz, the higher the better (if the board can support it) for best possible memory bandwidth.
// PAL clock (PAL color burst frequency x16) is 70.9379 MHz, which is very close to 567.5 MHz / 8,
// and 567.5 MHz can be derived from the 10 MHz input clock.  Therefore, 567.5 MHz is a useful frequency to select
// for PLL VCO, because a single PLL can generate both MCB clocks and the PAL clock.
// The calibration clock mcb_drp_clk can be obtained as 567.5 MHz / 6 = 94.5833 MHz.


// DCM_CLKGEN:  [10 MHz CLKIN] * [227 CLKFX_MULTIPLY] / [16 CLKFX_DIVIDE] = [‭141.875 MHz CLKFX]
//              (Note this restriction of DCM_CLKGEN:
//               "For proper DCM_CLKGEN locking with input frequencies below 52 MHz,
//                CLKFX_DIVIDE < F_CLKIN / 0.5MHz")

// PLL_BASE:    [141.875 MHz CLKIN] / [1 DIVCLK_DIVIDE] = [141.875 MHz DIVCLK OUT]
//              [141.875 MHz DIVCLK OUT] * [4 CLKFBOUT_MULT] = [567.5 MHz internal VCO OUT]
//              [567.5 MHz internal VCO OUT] / [1 CLKOUT0_DIVIDE] = [567.5 MHz @   0deg phase] <-- ddr2Clock0
//              [567.5 MHz internal VCO OUT] / [1 CLKOUT1_DIVIDE] = [567.5 MHz @ 180deg phase] <-- ddr2Clock180
//              [567.5 MHz internal VCO OUT] / [6 CLKOUT2_DIVIDE] = [94.5833 MHz] <- ddr2CalibClock
//              [567.5 MHz internal VCO OUT] / [8 CLKOUT3_DIVIDE] = [70.9375 MHz] <- palClock

// A single DCM is set aside for generating pixel clocks for VGA, SVGA, XGA, Display Parallel Interface (DPI), etc.
// A 90 MHz input can synthesize many useful pixel clock frequencies, some of which are listed below.
// Use the DCM_CLKGEN PROG interface to change the pixel clock at runtime.

// DCM_CLKGEN:  [90 MHz CLKIN] * [ 7 CLKFX_MULTIPLY] / [25 CLKFX_DIVIDE] = [25.2 MHz CLKFX] <-  VGA  640x 480@60Hz pixel clock
//              [90 MHz CLKIN] * [ 7 CLKFX_MULTIPLY] / [20 CLKFX_DIVIDE] = [31.5 MHz CLKFX] <- VESA  640x 480@75Hz pixel clock
//              [90 MHz CLKIN] * [16 CLKFX_MULTIPLY] / [45 CLKFX_DIVIDE] = [32 MHz CLKFX]   <-  DPI  800x 480@60Hz pixel clock
//              [90 MHz CLKIN] * [ 2 CLKFX_MULTIPLY] / [ 5 CLKFX_DIVIDE] = [36 MHz CLKFX]   <- VESA  640x 480@85Hz pixel clock
//              [90 MHz CLKIN] * [ 4 CLKFX_MULTIPLY] / [ 9 CLKFX_DIVIDE] = [40 MHz CLKFX]   <- SVGA  800x 600@60Hz pixel clock
//              [90 MHz CLKIN] * [11 CLKFX_MULTIPLY] / [20 CLKFX_DIVIDE] = [49.5 MHz CLKFX] <- VESA  800x 600@75Hz pixel clock
//              [90 MHz CLKIN] * [ 5 CLKFX_MULTIPLY] / [ 9 CLKFX_DIVIDE] = [50 MHz CLKFX]   <- VESA  800x 600@72Hz pixel clock
//              [90 MHz CLKIN] * [ 5 CLKFX_MULTIPLY] / [ 8 CLKFX_DIVIDE] = [56.25 MHz CLKFX]<- VESA  800x 600@85Hz pixel clock
//              [90 MHz CLKIN] * [13 CLKFX_MULTIPLY] / [18 CLKFX_DIVIDE] = [65 MHz CLKFX]   <-  XGA 1024x 768@60Hz pixel clock
//              [90 MHz CLKIN] * [ 5 CLKFX_MULTIPLY] / [ 6 CLKFX_DIVIDE] = [75 MHz CLKFX]   <- VESA 1024x 768@70Hz pixel clock
//              [90 MHz CLKIN] * [ 7 CLKFX_MULTIPLY] / [ 8 CLKFX_DIVIDE] = [78.75 MHz CLKFX]<- VESA 1024x 768@75Hz pixel clock
//              [90 MHz CLKIN] * [21 CLKFX_MULTIPLY] / [20 CLKFX_DIVIDE] = [94.5 MHz CLKFX] <- VESA 1024x 768@85Hz pixel clock (`2)
//              [90 MHz CLKIN] * [ 6 CLKFX_MULTIPLY] / [ 5 CLKFX_DIVIDE] = [108 MHz CLKFX]  <- VESA 1280x1024@60Hz pixel clock (`2)
//              [90 MHz CLKIN] * [ 3 CLKFX_MULTIPLY] / [ 2 CLKFX_DIVIDE] = [135 MHz CLKFX]  <- VESA 1280x1024@75Hz pixel clock (`2)
//              [90 MHz CLKIN] * [ 7 CLKFX_MULTIPLY] / [ 4 CLKFX_DIVIDE] = [157.5 MHz CLKFX]<- VESA 1280x1024@85Hz pixel clock (`2)
//              (`2: High pixel clocks may not actually be feasible for timing closure in a Spartan-6 or work well in hardware.)


endmodule