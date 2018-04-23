//
// Cpu6502StateConstants - Definitions of constants used by the 6502 state machine
//
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

`ifndef __CPU6502STATECONSTANTS_VH_
`define __CPU6502STATECONSTANTS_VH_

// Next State Determination
`define NEXT_STATE_DEFAULT      3'h0 /* Next state is OptionA */
`define NEXT_STATE_OPCODE       3'h1 /* Next state is (9'h100 | opcode) */
`define NEXT_STATE_CARRY        3'h2 /* Next state is OptionA if carry flag set, otherwise OptionB */
`define NEXT_STATE_OVERFLOW     3'h3 /* Next state is OptionA if overflow flag set, otherwise OptionB */
`define NEXT_STATE_NEGATIVE     3'h4 /* Next state is OptionA if sign flag set, otherwise OptionB */
`define NEXT_STATE_ZERO         3'h5 /* Next state is OptionA if zero flag set, otherwise OptionB */
`define NEXT_STATE_WRITE_BACK   3'h6 /* Next state is OptionA if write back is needed, otherwise OptionB */
`define NEXT_STATE_FIX_PAGE     3'h7 /* Next state is OptionA if page correction is needed, otherwise OptionB */

// States
`define DECODE          8'h00



`endif //__CPU6502STATECONSTANTS_VH_