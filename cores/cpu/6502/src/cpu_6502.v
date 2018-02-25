//
// cpu_6502 - Top-level module for a 6502 work-alike CPU
//
// This top-level module is responsible for performing memory and register accesses,
// handling interrupts and reset, and integrating the lower-level ALU, addressing, and
// opcode decoding modules.  This CPU is half-cycle accurate to the MOS 6502, and does NOT
// require a higher-speed clock (e.g. to execute microcode or perform in-time memory accesses).
// All stable undocumented opcodes are implemented accurately, with possible unavoidable 
// inaccuracies in the 'unstable' or 'kill' opcodes.
//
// Like all Reclone CPU cores, this CPU intends to include some handy features:
// - Separate address/data bus to provide access to register values and all internal state.
//   This is useful in debugging and in performing deterministic save and restore of machine state.
// - Good Verilator support so that the core can be compiled as C++ code for simulation
//   or use as a library.  Verilator lint warnings should be noticed and handled promptly.
// - Accompanying GTest unit test suite and CMake build system, for automated cross-platform 
//   builds and regression testing.
//
// Copyright 2018 Reclone Labs <reclonelabs.com>
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

module cpu_6502
(
    output reg [7:0] q,
    input      [7:0] d,
    input      clock,
    input      write,
    input      reset
);

Register regA(q, d, clock, write, reset);

endmodule 