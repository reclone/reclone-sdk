//
// reclone-rise/LvdsOut5Bit - 5-bit Serialized Low-Voltage Differential Signalling Output
//
// This output module pairs an OutputSerializer5Bit with an OBUFDS to drive differential signalling.
// The serial output from this module is meant to connect directly to a p/n pair of IO pins 
// configured as LVDS33.  This is useful for direct DVI-D or HDMI output.
//
// This encapsulation will hopefully reduce copy/paste and improve code readability.
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

module LvdsOut5Bit
(
    input wire      clkLoad,
    input wire      clkOutput,
    input wire      loadStrobe,
    input wire[4:0] serialData,
    output wire     lvdsOutputP,
    output wire     lvdsOutputN
);

wire serialized;

OutputSerializerSdr5Bit serializer
(
    .clkLoad(clkLoad),
    .clkOutput(clkOutput),
    .loadStrobe(loadStrobe),
    .serialData(serialData),
    .serialOutput(serialized)
);

OBUFDS lvdsDriver
(
    .I(serialized),
    .O(lvdsOutputP),
    .OB(lvdsOutputN)
);

endmodule
