//
// Cpu6502Tests - Unit tests for verilated Cpu6502 module
//
//
// Copyright 2019 - 2021 Reclone Labs <reclonelabs.com>
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

#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "gmock/gmock.h"
#include "VCpu6502.h"

// From perfect6502
extern "C"
{
#include "types.h"
#include "perfect6502.h"
#include "netlist_sim.h"
}

using namespace ::testing;

class Cpu6502Tests : public Test
{
    public:
        Cpu6502Tests() : _tickCount(1), _perfect6502state(nullptr)
        {
            Verilated::traceEverOn(true);
            _perfect6502state = initAndResetChip();
        }
        
        virtual ~Cpu6502Tests()
        {
            destroyChip(_perfect6502state);
            _uut.final();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VCpu6502 _uut;
        unsigned int _tickCount;
        state_t * _perfect6502state;
};

TEST_F(Cpu6502Tests, Startup)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("6502.vcd");
    
    _uut.reset = 0;
    _uut.nRESET = 1;
    _uut.nNMI = 1;
    _uut.nIRQ = 1;
    _uut.dataIn = 0;
    _uut.enable = 1;
    _uut.clock = 1;
    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        step(_perfect6502state);
        //chipStatus(_perfect6502state);
        _uut.clock = !_uut.clock;
        _uut.eval();
        _vcdTrace.dump(_tickCount++);
    }
    
    // Load the first byte of the reset vector

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0xAA);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    _uut.dataIn = 0xAA;
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0xAA);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);
    
    // Load the second byte of the reset vector
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x55);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    _uut.dataIn = 0x55;
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x55);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    
    // Fetch the first opcode
    
    step(_perfect6502state);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0x55AA, readAddressBus(_perfect6502state));
    ASSERT_EQ(0x55AA, _uut.address);
    
    step(_perfect6502state);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0x55AA, readAddressBus(_perfect6502state));
    ASSERT_EQ(0x55AA, _uut.address);
    
    _vcdTrace.close();
}


