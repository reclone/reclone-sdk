//
// ClockEnableDivider - Generate "numerator" clock enable pulses every "demoninator" clocks
//
// This clock enable generator uses a counter to enable only a fractional amount of clock edges.
//
// This is the recommended way to do something at a slower rate using a faster clock.
// A standard clock divider creates a new clock domain, requiring you to add synchronization
// to avoid metastability or data loss issues if you want to transfer data between domains.
// Clock gating can save power, but not all FPGAs handle it well, and you might have to
// use vendor-specific primitives, thus limiting HDL portability.  ClockEnableDivider works
// nicely on most FPGAs because the enable signal is wired directly to each relevant flip flop.
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

module ClockEnableDivider #(parameter COUNTER_BITS = 16)
(
    input wire clock,
    input wire masterEnable,
    input wire reset,
    input wire [COUNTER_BITS-1:0] numerator,
    input wire [COUNTER_BITS-1:0] denominator,
    
    output reg dividedEnable = 1'd0
);

reg [COUNTER_BITS-1:0] counter = {COUNTER_BITS{1'b0}};

wire [COUNTER_BITS:0] sum = {1'b0, counter} + {1'b0, numerator};

wire overflow = (sum > {1'b0, denominator});

/* verilator lint_off UNUSED */
wire [COUNTER_BITS:0] rollover = sum - {1'b0, denominator};
/* verilator lint_on UNUSED */

wire [COUNTER_BITS-1:0] counterNext = overflow ? rollover[COUNTER_BITS-1:0] : sum[COUNTER_BITS-1:0];

always @ (posedge clock) begin
    if (reset) begin
    
        dividedEnable <= 1'd0;
        counter <= {COUNTER_BITS{1'b0}};
        
    end else begin

        dividedEnable <= masterEnable ? overflow : 1'b0;
        counter <= counterNext;

    end
end

endmodule
