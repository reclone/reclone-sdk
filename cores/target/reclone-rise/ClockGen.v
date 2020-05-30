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

`default_nettype none

module ClockGen
(
    input wire  clk10m,             // 10       MHz
    output wire hdmiPixelClock,     // 74.25    MHz     (720p60, 1080i60, 1080p30 and others)
    output wire hdmiDataLoadClock,  // 148.5    MHz
    output wire hdmiQdrClock0,      // 371.25   MHz @ 0deg phase
    output wire hdmiQdrClock90,     // 371.25   MHz @ 90deg phase
    output wire hdmiIoClock,        // 742.5    MHz
    output wire hdmiSerDesStrobe,   // Data load strobe signal to use with HDMI SERDES primitives
    output wire dpiPixelClock,      // Display Parallel Interface pixel clock for LCD, VGA, SVGA, XVGA, etc.
    output wire ntscClock,          // 57.27273 MHz     (NTSC color burst frequency x16)
    output wire palClock,           // 70.9379  MHz     (PAL  color burst frequency x16)
    output wire audioClock,         // 90       MHz     (48kHz x1875 delta-sigma frequency)
    output wire mcbCalibClock,      // 94.5833  MHz     (Clock for MCB calibration soft logic)
    output wire mcbSysClk2x0,
    output wire mcbSerDesStrobe0,
    output wire mcbSysClk2x180,
    output wire mcbSerDesStrobe90
//    output  ddrClock            // 
);

// -- First Clock Management Tile --

// Most of the interesting HDMI output formats require a 74.25 MHz pixel clock (720p, 1080i, etc.).
// HDMI generation also requires a x2 clock for data load, and a x10 IO clock for each SERDES.
// So our goal is to convert our 10 MHz oscillator input to a PLL VCO output of 742.5 MHz,
// which we can divide to get our 148.5 and 74.25 MHz clocks, while getting as many other
// useful clock frequencies as we can along the way.

// DCM_CLKGEN:  [10 MHz CLKIN] * [9 CLKFX_MULTIPLY] / [1 CLKFX_DIVIDE] = [90 MHz CLKFX] <-- 48 kHz * 1875 audio clock
wire clk90m_unbuffered;
DCM_CLKGEN 
#(
    .CLKFX_MULTIPLY(9),
    .CLKFX_DIVIDE(1),
    .CLKFXDV_DIVIDE(2),
    .CLKIN_PERIOD(100.000),
    .STARTUP_WAIT("FALSE"),
    .SPREAD_SPECTRUM("NONE"),
    .CLKFX_MD_MAX(0.000)
) dcm90m
(
    .CLKIN(clk10m),
    .RST(1'b0),
    .FREEZEDCM(1'b0),
    .CLKFX(clk90m_unbuffered),
    .CLKFX180(),
    .LOCKED(),
    .STATUS(),
    .CLKFXDV(),
    .PROGDONE(),
    .PROGDATA(1'b0),
    .PROGEN(1'b0),
    .PROGCLK(1'b0)
);
BUFG dcm90_bufg
(
    .I(clk90m_unbuffered),
    .O(audioClock)
);

// PLL_BASE:    [90 MHz CLKIN] / [4 DIVCLK_DIVIDE] = [22.5 MHz DIVCLK_OUT]
//              [22.5 MHz DIVCLK_OUT] * [33 CLKFBOUT_MULT] = [742.5 MHz internal VCO OUT]
//              [742.5 MHz DIVCLK OUT] / [ 1 CLKOUT0_DIVIDE] = [742.5  MHz CLKOUT0] <-- hdmiIoClock
//              [742.5 MHz DIVCLK OUT] / [ 2 CLKOUT1_DIVIDE] = [371.25 MHz CLKOUT1 @  0deg phase] <-- hdmiQdrClock0
//              [742.5 MHz DIVCLK OUT] / [ 2 CLKOUT2_DIVIDE] = [371.25 MHz CLKOUT2 @ 90deg phase] <-- hdmiQdrClock90
//              [742.5 MHz DIVCLK OUT] / [ 5 CLKOUT3_DIVIDE] = [148.5  MHz CLKOUT3] <-- hdmiDataLoadClock
//              [742.5 MHz DIVCLK OUT] / [10 CLKOUT4_DIVIDE] = [ 74.25 MHz CLKOUT4] <-- hdmiPixelClock
//              [742.5 MHz DIVCLK OUT] / [33 CLKOUT5_DIVIDE] = [ 22.5  MHz CLKOUT5] <-- jitter filtered CLKIN for NTSC DCM
wire pll_hdmi_clkfb;
wire pll_hdmi_locked;
wire pll_hdmi_clkout0_unbuffered_742p5;
wire pll_hdmi_clkout1_unbuffered_371p25_0;
wire pll_hdmi_clkout2_unbuffered_371p25_90;
wire pll_hdmi_clkout3_unbuffered_148p5;
wire pll_hdmi_clkout4_unbuffered_74p25;
wire pll_hdmi_clkout5_unbuffered_22p5;
wire ntsc_clkin;

PLL_BASE
#(
    .BANDWIDTH("OPTIMIZED"), // "HIGH", "LOW" or "OPTIMIZED"
    .COMPENSATION("INTERNAL"),
    .CLK_FEEDBACK("CLKFBOUT"),
    .CLKFBOUT_MULT(33), // Multiplication factor for all output clocks
    .CLKFBOUT_PHASE(0.0), // Phase shift (degrees) of all output clocks
    .CLKIN_PERIOD("11.11111"), // Clock period (ns) of input clock on CLKIN
    .CLKOUT0_DIVIDE(1), // Division factor for CLKOUT0 (1 to 128)
    .CLKOUT0_PHASE(0.0), // Phase shift (degrees) for CLKOUT0 (0.0 to 360.0)
    .CLKOUT1_DIVIDE(2), // Division factor for CLKOUT1 (1 to 128)
    .CLKOUT1_PHASE(0.0), // Phase shift (degrees) for CLKOUT1 (0.0 to 360.0)
    .CLKOUT2_DIVIDE(2), // Division factor for CLKOUT2 (1 to 128)
    .CLKOUT2_PHASE(90.0), // Phase shift (degrees) for CLKOUT2 (0.0 to 360.0)
    .CLKOUT3_DIVIDE(5), // Division factor for CLKOUT3 (1 to 128)
    .CLKOUT3_PHASE(0.0), // Phase shift (degrees) for CLKOUT3 (0.0 to 360.0)
    .CLKOUT4_DIVIDE(10), // Division factor for CLKOUT4 (1 to 128)
    .CLKOUT4_PHASE(0.0), // Phase shift (degrees) for CLKOUT4 (0.0 to 360.0)
    .CLKOUT5_DIVIDE(33), // Division factor for CLKOUT5 (1 to 128)
    .CLKOUT5_PHASE(0.0), // Phase shift (degrees) for CLKOUT5 (0.0 to 360.0)
    .DIVCLK_DIVIDE(4), // Division factor for all clocks (1 to 52)
    .REF_JITTER(0.100) // Input reference jitter (0.000 to 0.999 UI%)
)
pll_hdmi
(
    .CLKFBOUT(pll_hdmi_clkfb), // General output feedback signal
    .CLKOUT0(pll_hdmi_clkout0_unbuffered_742p5),    // [742.5 MHz DIVCLK OUT] / [ 1 CLKOUT0_DIVIDE] = [742.5  MHz CLKOUT0] <-- hdmiIoClock
    .CLKOUT1(pll_hdmi_clkout1_unbuffered_371p25_0), // [742.5 MHz DIVCLK OUT] / [ 2 CLKOUT1_DIVIDE] = [371.25 MHz CLKOUT1 @  0deg phase] <-- hdmiQdrClock0
    .CLKOUT2(pll_hdmi_clkout2_unbuffered_371p25_90),// [742.5 MHz DIVCLK OUT] / [ 2 CLKOUT2_DIVIDE] = [371.25 MHz CLKOUT2 @ 90deg phase] <-- hdmiQdrClock90
    .CLKOUT3(pll_hdmi_clkout3_unbuffered_148p5),    // [742.5 MHz DIVCLK OUT] / [ 5 CLKOUT3_DIVIDE] = [148.5  MHz CLKOUT3] <-- hdmiDataLoadClock
    .CLKOUT4(pll_hdmi_clkout4_unbuffered_74p25),    // [742.5 MHz DIVCLK OUT] / [10 CLKOUT4_DIVIDE] = [ 74.25 MHz CLKOUT4] <-- hdmiPixelClock
    .CLKOUT5(pll_hdmi_clkout5_unbuffered_22p5),     // [742.5 MHz DIVCLK OUT] / [33 CLKOUT5_DIVIDE] = [ 22.5  MHz CLKOUT5] <-- jitter filtered CLKIN for NTSC and DPI DCMs
    .LOCKED(pll_hdmi_locked), // Active high PLL lock signal
    .CLKFBIN(pll_hdmi_clkfb), // Clock feedback input
    .CLKIN(clk90m_unbuffered), // Clock input
    .RST(1'b0) // Asynchronous PLL reset
);

BUFG hdmiQdrClock0_bufg
(
    .I(pll_hdmi_clkout1_unbuffered_371p25_0),
    .O(hdmiQdrClock0)
);

BUFG hdmiQdrClock90_bufg
(
    .I(pll_hdmi_clkout2_unbuffered_371p25_90),
    .O(hdmiQdrClock90)
);

BUFG hdmiDataLoadClock_bufg
(
    .I(pll_hdmi_clkout3_unbuffered_148p5),
    .O(hdmiDataLoadClock)
);

BUFG hdmiPixelClock_bufg
(
    .I(pll_hdmi_clkout4_unbuffered_74p25),
    .O(hdmiPixelClock)
);

BUFG ntscClockIn_bufg
(
    .I(pll_hdmi_clkout5_unbuffered_22p5),
    .O(ntsc_clkin)
);

BUFPLL
#(
    .DIVIDE(5),
    .ENABLE_SYNC("TRUE")
)
hdmiSerDesStrobe_bufpll
(
    .IOCLK(hdmiIoClock),
    .LOCK(),
    .SERDESSTROBE(hdmiSerDesStrobe),
    .GCLK(hdmiDataLoadClock),
    .LOCKED(pll_hdmi_locked),
    .PLLIN(pll_hdmi_clkout0_unbuffered_742p5)
);

// A single DCM is set aside for generating pixel clocks for VGA, SVGA, XGA, Display Parallel Interface (DPI), etc.
// A 22.5 MHz input can synthesize many useful pixel clock frequencies, some of which are listed below.
// Use the DCM_CLKGEN PROG interface to change the pixel clock at runtime.

// DCM_CLKGEN:  [22.5 MHz CLKIN] * [28 CLKFX_MULTIPLY] / [25 CLKFX_DIVIDE] = [25.2 MHz CLKFX] <-  VGA  640x 480@60Hz pixel clock
//              [22.5 MHz CLKIN] * [ 7 CLKFX_MULTIPLY] / [ 5 CLKFX_DIVIDE] = [31.5 MHz CLKFX] <- VESA  640x 480@75Hz pixel clock
//              [22.5 MHz CLKIN] * [64 CLKFX_MULTIPLY] / [45 CLKFX_DIVIDE] = [32 MHz CLKFX]   <-  DPI  800x 480@60Hz pixel clock (`1)
//              [22.5 MHz CLKIN] * [ 8 CLKFX_MULTIPLY] / [ 5 CLKFX_DIVIDE] = [36 MHz CLKFX]   <- VESA  640x 480@85Hz pixel clock
//              [22.5 MHz CLKIN] * [16 CLKFX_MULTIPLY] / [ 9 CLKFX_DIVIDE] = [40 MHz CLKFX]   <- SVGA  800x 600@60Hz pixel clock
//              [22.5 MHz CLKIN] * [11 CLKFX_MULTIPLY] / [ 5 CLKFX_DIVIDE] = [49.5 MHz CLKFX] <- VESA  800x 600@75Hz pixel clock
//              [22.5 MHz CLKIN] * [20 CLKFX_MULTIPLY] / [ 9 CLKFX_DIVIDE] = [50 MHz CLKFX]   <- VESA  800x 600@72Hz pixel clock
//              [22.5 MHz CLKIN] * [ 5 CLKFX_MULTIPLY] / [ 2 CLKFX_DIVIDE] = [56.25 MHz CLKFX]<- VESA  800x 600@85Hz pixel clock
//              [22.5 MHz CLKIN] * [26 CLKFX_MULTIPLY] / [ 9 CLKFX_DIVIDE] = [65 MHz CLKFX]   <-  XGA 1024x 768@60Hz pixel clock
//              [22.5 MHz CLKIN] * [10 CLKFX_MULTIPLY] / [ 3 CLKFX_DIVIDE] = [75 MHz CLKFX]   <- VESA 1024x 768@70Hz pixel clock
//              [22.5 MHz CLKIN] * [ 7 CLKFX_MULTIPLY] / [ 2 CLKFX_DIVIDE] = [78.75 MHz CLKFX]<- VESA 1024x 768@75Hz pixel clock
//              [22.5 MHz CLKIN] * [21 CLKFX_MULTIPLY] / [ 5 CLKFX_DIVIDE] = [94.5 MHz CLKFX] <- VESA 1024x 768@85Hz pixel clock (`2)
//              [22.5 MHz CLKIN] * [24 CLKFX_MULTIPLY] / [ 5 CLKFX_DIVIDE] = [108 MHz CLKFX]  <- VESA 1280x1024@60Hz pixel clock (`2)
//              [22.5 MHz CLKIN] * [ 6 CLKFX_MULTIPLY] / [ 1 CLKFX_DIVIDE] = [135 MHz CLKFX]  <- VESA 1280x1024@75Hz pixel clock (`2)
//              [22.5 MHz CLKIN] * [ 7 CLKFX_MULTIPLY] / [ 1 CLKFX_DIVIDE] = [157.5 MHz CLKFX]<- VESA 1280x1024@85Hz pixel clock (`2)
//              (`1: This timing is marginal and may not lock.  Note this restriction of DCM_CLKGEN:
//                   "For proper DCM_CLKGEN locking with input frequencies below 52 MHz,
//                    CLKFX_DIVIDE < F_CLKIN / 0.5MHz")
//              (`2: High pixel clocks may not actually be feasible for timing closure in a Spartan-6 or work well in hardware.)
wire dpi_clk_unbuffered;
DCM_CLKGEN 
#(
    .CLKFX_MULTIPLY(28),
    .CLKFX_DIVIDE(25),
    .CLKFXDV_DIVIDE(2),
    .CLKIN_PERIOD(44.444),
    .STARTUP_WAIT("FALSE"),
    .SPREAD_SPECTRUM("NONE"),
    .CLKFX_MD_MAX(7.000)
)
dcm_dpi
(
    .CLKIN(pll_hdmi_clkout5_unbuffered_22p5),
    .RST(1'b0),
    .FREEZEDCM(1'b0),
    .CLKFX(dpi_clk_unbuffered),
    .CLKFX180(),
    .LOCKED(),
    .STATUS(),
    .CLKFXDV(),
    .PROGDONE(),
    .PROGDATA(1'b0),
    .PROGEN(1'b0),
    .PROGCLK(1'b0)
);
BUFG dcm_dpi_bufg
(
    .I(dpi_clk_unbuffered),
    .O(dpiPixelClock)
);


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


// DCM_CLKGEN:  [10 MHz CLKIN] * [227 CLKFX_MULTIPLY] / [16 CLKFX_DIVIDE] = [141.875 MHz CLKFX]
//              (Note this restriction of DCM_CLKGEN:
//               "For proper DCM_CLKGEN locking with input frequencies below 52 MHz,
//                CLKFX_DIVIDE < F_CLKIN / 0.5MHz")

wire clk141p875m_unbuffered;
DCM_CLKGEN 
#(
    .CLKFX_MULTIPLY(227),
    .CLKFX_DIVIDE(16),
    .CLKFXDV_DIVIDE(2),
    .CLKIN_PERIOD(100.000),
    .STARTUP_WAIT("FALSE"),
    .SPREAD_SPECTRUM("NONE"),
    .CLKFX_MD_MAX(0.000)
)
dcm141p875m
(
    .CLKIN(clk10m),
    .RST(1'b0),
    .FREEZEDCM(1'b0),
    .CLKFX(clk141p875m_unbuffered),
    .CLKFX180(),
    .LOCKED(),
    .STATUS(),
    .CLKFXDV(),
    .PROGDONE(),
    .PROGDATA(1'b0),
    .PROGEN(1'b0),
    .PROGCLK(1'b0)
);

// PLL_BASE:    [141.875 MHz CLKIN] / [1 DIVCLK_DIVIDE] = [141.875 MHz DIVCLK OUT]
//              [141.875 MHz DIVCLK OUT] * [4 CLKFBOUT_MULT] = [567.5 MHz internal VCO OUT]
//              [567.5 MHz internal VCO OUT] / [1 CLKOUT0_DIVIDE] = [567.5 MHz @   0deg phase] <-- ddr2Clock0
//              [567.5 MHz internal VCO OUT] / [1 CLKOUT1_DIVIDE] = [567.5 MHz @ 180deg phase] <-- ddr2Clock180
//              [567.5 MHz internal VCO OUT] / [6 CLKOUT2_DIVIDE] = [94.5833 MHz] <- ddr2CalibClock
//              [567.5 MHz internal VCO OUT] / [8 CLKOUT3_DIVIDE] = [70.9375 MHz] <- palClock

wire pll_mcb_pal_clkfb;
wire pll_mcb_pal_locked;
wire pll_mcb_clkout0_unbuffered_567p5_0;
wire pll_mcb_clkout1_unbuffered_567p5_180;
wire pll_mcb_clkout2_unbuffered_94p5833;
wire pll_pal_clkout3_unbuffered_70p9375;

PLL_BASE
#(
    .BANDWIDTH("OPTIMIZED"), // "HIGH", "LOW" or "OPTIMIZED"
    .COMPENSATION("INTERNAL"),
    .CLK_FEEDBACK("CLKFBOUT"),
    .CLKFBOUT_MULT(4), // Multiplication factor for all output clocks
    .CLKFBOUT_PHASE(0.0), // Phase shift (degrees) of all output clocks
    .CLKIN_PERIOD("7.048458"), // Clock period (ns) of input clock on CLKIN
    .CLKOUT0_DIVIDE(1), // Division factor for CLKOUT0 (1 to 128)
    .CLKOUT0_PHASE(0.0), // Phase shift (degrees) for CLKOUT0 (0.0 to 360.0)
    .CLKOUT1_DIVIDE(1), // Division factor for CLKOUT1 (1 to 128)
    .CLKOUT1_PHASE(180.0), // Phase shift (degrees) for CLKOUT1 (0.0 to 360.0)
    .CLKOUT2_DIVIDE(6), // Division factor for CLKOUT2 (1 to 128)
    .CLKOUT2_PHASE(0.0), // Phase shift (degrees) for CLKOUT2 (0.0 to 360.0)
    .CLKOUT3_DIVIDE(8), // Division factor for CLKOUT3 (1 to 128)
    .CLKOUT3_PHASE(0.0), // Phase shift (degrees) for CLKOUT3 (0.0 to 360.0)
    .DIVCLK_DIVIDE(1), // Division factor for all clocks (1 to 52)
    .REF_JITTER(0.100) // Input reference jitter (0.000 to 0.999 UI%)
)
pll_mcb_pal
(
    .CLKFBOUT(pll_mcb_pal_clkfb), // General output feedback signal
    .CLKOUT0(pll_mcb_clkout0_unbuffered_567p5_0),  // [567.5 MHz internal VCO OUT] / [1 CLKOUT0_DIVIDE] = [567.5 MHz @   0deg phase] <-- ddr2Clock0
    .CLKOUT1(pll_mcb_clkout1_unbuffered_567p5_180),// [567.5 MHz internal VCO OUT] / [1 CLKOUT1_DIVIDE] = [567.5 MHz @ 180deg phase] <-- ddr2Clock180
    .CLKOUT2(pll_mcb_clkout2_unbuffered_94p5833),  // [567.5 MHz internal VCO OUT] / [6 CLKOUT2_DIVIDE] = [94.5833 MHz] <- mcbCalibClock
    .CLKOUT3(pll_pal_clkout3_unbuffered_70p9375),  // [567.5 MHz internal VCO OUT] / [8 CLKOUT3_DIVIDE] = [70.9375 MHz] <- palClock
    .CLKOUT4(),                                    // Unused
    .CLKOUT5(),                                    // Unused
    .LOCKED(pll_mcb_pal_locked), // Active high PLL lock signal
    .CLKFBIN(pll_mcb_pal_clkfb), // Clock feedback input
    .CLKIN(clk141p875m_unbuffered), // Clock input
    .RST(1'b0) // Asynchronous PLL reset
);

BUFGCE mcbDrpClk_bufgce
(
    .I(pll_mcb_clkout2_unbuffered_94p5833),
    .O(mcbCalibClock),
    .CE(pll_mcb_pal_locked)
);

BUFPLL_MCB
#(
    .LOCK_SRC("LOCK_TO_0"),
    .DIVIDE(2)
)
mcb_bufpll
(
    .GCLK(mcbCalibClock),
    .PLLIN0(pll_mcb_clkout0_unbuffered_567p5_0),
    .PLLIN1(pll_mcb_clkout1_unbuffered_567p5_180),
    .IOCLK0(mcbSysClk2x0),
    .SERDESSTROBE0(mcbSerDesStrobe0),
    .IOCLK1(mcbSysClk2x180),
    .SERDESSTROBE1(mcbSerDesStrobe90),
    .LOCKED(pll_mcb_pal_locked),
    .LOCK()
);



BUFG palClock_bufg
(
    .I(pll_pal_clkout3_unbuffered_70p9375),
    .O(palClock)
);


// DCM_CLKGEN:  [22.5 MHz CLKIN] * [28 CLKFX_MULTIPLY] / [11 CLKFX_DIVIDE] = [57.2727... MHz CLKFX] <- ntscClock

wire ntsc_clk_unbuffered;
DCM_CLKGEN 
#(
    .CLKFX_MULTIPLY(28),
    .CLKFX_DIVIDE(11),
    .CLKFXDV_DIVIDE(2),
    .CLKIN_PERIOD(44.444),
    .STARTUP_WAIT("FALSE"),
    .SPREAD_SPECTRUM("NONE"),
    .CLKFX_MD_MAX(0.000)
)
dcm_ntsc
(
    .CLKIN(ntsc_clkin),
    .RST(1'b0),
    .FREEZEDCM(1'b0),
    .CLKFX(ntsc_clk_unbuffered),
    .CLKFX180(),
    .LOCKED(),
    .STATUS(),
    .CLKFXDV(),
    .PROGDONE(),
    .PROGDATA(1'b0),
    .PROGEN(1'b0),
    .PROGCLK(1'b0)
);
BUFG dcm_ntsc_bufg
(
    .I(ntsc_clk_unbuffered),
    .O(ntscClock)
);


endmodule