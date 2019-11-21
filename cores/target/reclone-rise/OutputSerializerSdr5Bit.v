//
// reclone-rise/OutputSerializerSdr5Bit - 5-bit Single Data Rate Output Serializer
//
// This 5-bit serializer is composed of two Spartan-6 OSERDES2 primitives configured as
// master and slave.  It allows parallel data to be output as serial at a higher speed IO clock.
// This is useful for direct DVI-D or HDMI output.
//
// Design for this module is a Verilog port of a similar module from the 
// "MiniSpartan6+ DVID Output" project at:
// http://hamsterworks.co.nz/mediawiki/index.php/MiniSpartan6%2B_DVID_Output
// Used by permission from the author, Mike Field <hamster@snap.net.nz>.
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


module OutputSerializerSdr5Bit
(
    input wire      clkLoad,
    input wire      clkOutput,
    input wire      loadStrobe,
    input wire[4:0] serialData,
    output wire     serialOutput
);

wire [4:1] cascade;

OSERDES2
#(
    .BYPASS_GCLK_FF("FALSE"),       // Indicates whether to bypass CLKDIV syncronization registers.
    .DATA_RATE_OQ("SDR"),           // Data rate setting. Defines whether the data changes at every clock edge
                                    // or every positive clock edge with respect to CLK.
    .DATA_RATE_OT("SDR"),           // Tristate Data rate setting. Defines whether the 3-state changes at every
                                    // clock edge, every positive clock edge, or buffer configuration with
                                    // respect to CLK.
    .DATA_WIDTH(5),                 // Sets how many bits from the fabric to serialize to the IOB.
    .OUTPUT_MODE("SINGLE_ENDED"),   // Output Mode.
    .SERDES_MODE("MASTER"),         // Indicates whether SERDES is being used as a Master or Slave when
                                    // cascaded.
    .TRAIN_PATTERN(0)               // Training pattern. See comments with TRAIN pin.
)
Oserdes2Master
(
    .OQ(serialOutput),  // 1-bit Data path output to pad or IODELAY2.
    .SHIFTOUT1(cascade[1]), // SHIFTOUT1 - SHIFTOUT2: 1-bit (each) Cascade data output signal (dummy in Slave).
    .SHIFTOUT2(cascade[2]), // Used for DATA_WIDTHs greater than 4.
    .SHIFTOUT3(),       // SHIFTOUT3 - SHIFTOUT4: 1-bit (each) Differential data output signal (dummy in Master).
    .SHIFTOUT4(),
    .TQ(),              // 1-bit Tristate path output to pad or IODELAY2.
    .CLK0(clkOutput),   // 1-bit Optionally Invertible IO Clock network input. This is the primary clock
                        // input used when the clock doubler circuit is not engaged (see DATA_RATE attribute).
    .CLK1(1'b0),        // 1-bit IO Clock network input. Optionally Invertible. Timing note: CLK1 should
                        // be 180 degrees out of phase with CLK0.
    .CLKDIV(clkLoad),   // 1-bit Global clock network input. This is the clock for the fabric domain.
    .D1(serialData[4]), // D1 - D4: 1-bit (each) Data input
    .D2(1'b0),
    .D3(1'b0),
    .D4(1'b0),
    .IOCE(loadStrobe),  // 1-bit "Transfer Out" enable signal derived from BUFIO CE. This is the strobe
                        // that determines when the input data is sampled.
    .OCE(1'b1),         // 1-bit Clock enable for data inputs.
    .RST(1'b0),         // 1-bit Shared Data/Tristate Reset pin. Asynchronous only.
    .SHIFTIN1(1'b1),    // SHIFTIN1 - SHIFTIN2: 1-bit (each) Cascade data input signal (dummy in Master). 
    .SHIFTIN2(1'b1),    // Used for DATA_WIDTHs greater than 4.
    .SHIFTIN3(cascade[3]),  // SHIFTIN3 - SHIFTIN4: 1-bit (each) Differential data input Signal (dummy in Slave).
    .SHIFTIN4(cascade[4]),
    .T1(1'b0),          // T1 - T4: 1-bit (each) Parallel 3-State Inputs - Ports T1 to T4 are the location 
    .T2(1'b0),          // in which all parallel 3-state signals enters the OSERDES2 module. This port is 
    .T3(1'b0),          // connected to the FPGA fabric, and can be configured from 1 to 4 bits. This feature
    .T4(1'b0),          // is not supported in the extended width mode.
    .TCE(1'b1),         // 1-bit Clock enable for tristate inputs.
    .TRAIN(1'b0)        // 1-bit Enable use of the training pattern. The "train" function is a means of
                        // specifying a fixed output pattern that is used to calibrate the receiver of the
                        // signal. This pin allows the fabric to control whether the output is that fixed
                        // pattern or the input data from the pins.
);

OSERDES2
#(
    .BYPASS_GCLK_FF("FALSE"),       // Indicates whether to bypass CLKDIV syncronization registers.
    .DATA_RATE_OQ("SDR"),           // Data rate setting. Defines whether the data changes at every clock edge
                                    // or every positive clock edge with respect to CLK.
    .DATA_RATE_OT("SDR"),           // Tristate Data rate setting. Defines whether the 3-state changes at every
                                    // clock edge, every positive clock edge, or buffer configuration with
                                    // respect to CLK.
    .DATA_WIDTH(5),                 // Sets how many bits from the fabric to serialize to the IOB.
    .OUTPUT_MODE("SINGLE_ENDED"),   // Output Mode.
    .SERDES_MODE("SLAVE"),          // Indicates whether SERDES is being used as a Master or Slave when
                                    // cascaded.
    .TRAIN_PATTERN(0)               // Training pattern. See comments with TRAIN pin.
)
Oserdes2Slave
(
    .OQ(),              // 1-bit Data path output to pad or IODELAY2.
    .SHIFTOUT1(),       // SHIFTOUT1 - SHIFTOUT2: 1-bit (each) Cascade data output signal (dummy in Slave).
    .SHIFTOUT2(),       // Used for DATA_WIDTHs greater than 4.
    .SHIFTOUT3(cascade[3]), // SHIFTOUT3 - SHIFTOUT4: 1-bit (each) Differential data output signal (dummy in Master).
    .SHIFTOUT4(cascade[4]),
    .TQ(),              // 1-bit Tristate path output to pad or IODELAY2.
    .CLK0(clkOutput),   // 1-bit Optionally Invertible IO Clock network input. This is the primary clock
                        // input used when the clock doubler circuit is not engaged (see DATA_RATE attribute).
    .CLK1(1'b0),        // 1-bit IO Clock network input. Optionally Invertible. Timing note: CLK1 should
                        // be 180 degrees out of phase with CLK0.
    .CLKDIV(clkLoad),   // 1-bit Global clock network input. This is the clock for the fabric domain.
    .D1(serialData[0]), // D1 - D4: 1-bit (each) Data input
    .D2(serialData[1]),
    .D3(serialData[2]),
    .D4(serialData[3]),
    .IOCE(loadStrobe),  // 1-bit "Transfer Out" enable signal derived from BUFIO CE. This is the strobe
                        // that determines when the input data is sampled.
    .OCE(1'b1),         // 1-bit Clock enable for data inputs.
    .RST(1'b0),         // 1-bit Shared Data/Tristate Reset pin. Asynchronous only.
    .SHIFTIN1(cascade[1]),  // SHIFTIN1 - SHIFTIN2: 1-bit (each) Cascade data input signal (dummy in Master). 
    .SHIFTIN2(cascade[2]),  // Used for DATA_WIDTHs greater than 4.
    .SHIFTIN3(1'b1),    // SHIFTIN3 - SHIFTIN4: 1-bit (each) Differential data input Signal (dummy in Slave).
    .SHIFTIN4(1'b1),
    .T1(1'b0),          // T1 - T4: 1-bit (each) Parallel 3-State Inputs - Ports T1 to T4 are the location 
    .T2(1'b0),          // in which all parallel 3-state signals enters the OSERDES2 module. This port is 
    .T3(1'b0),          // connected to the FPGA fabric, and can be configured from 1 to 4 bits. This feature
    .T4(1'b0),          // is not supported in the extended width mode.
    .TCE(1'b1),         // 1-bit Clock enable for tristate inputs.
    .TRAIN(1'b0)        // 1-bit Enable use of the training pattern. The "train" function is a means of
                        // specifying a fixed output pattern that is used to calibrate the receiver of the
                        // signal. This pin allows the fabric to control whether the output is that fixed
                        // pattern or the input data from the pins.
);


endmodule
