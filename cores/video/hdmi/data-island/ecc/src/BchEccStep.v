//
// BchEccStep - Asynchronously calculate the next state of a BCH ECC for HDMI data islands
//
// This is the core part of the Bose–Chaudhuri–Hocquenghem (BCH) Error Correction Code (ECC)
// algorithm that is performed to generate the parity bits in HDMI data islands.
//
// This core part is broken out and kept asynchronous so that its common algorithm can be used
// (and potentially cascaded) in different encoders and/or decoders.  For example, generation of
// an HDMI data island packet *header* requires the BCH algorithm to process one bit per pixel
// clock, whereas an HDMI data island *subpacket* requires processing two bits per pixel clock.
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

module BchEccStep
(
    input wire data,
    input wire [7:0] ecc,
    output wire [7:0] eccNext
);

assign eccNext = (ecc >> 1) ^ ((ecc[0] ^ data) ? 8'h83 : 8'h00);

endmodule
