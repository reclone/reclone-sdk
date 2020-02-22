//
// PalGeneratorTests - Unit tests for verilated PalGenerator module
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

#include <math.h>
#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VPalGenerator.h"
#include "VPalTiming.h"

class PalGeneratorTests : public ::testing::Test
{
    public:
        PalGeneratorTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~PalGeneratorTests()
        {
            _uut.final();
        }
        
    protected:
        VPalGenerator _uut;
        unsigned int _tickCount;
};

TEST_F(PalGeneratorTests, ColorBurst)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PalGeneratorColorBurst.vcd");

    _uut.reset = 0;
    _uut.phaseClock = 0;
    _uut.subcarrierPhase = 0;
    _uut.blank = 1;
    _uut.sync = 0;
    _uut.burst = 1;
    //_uut.oddFrame = 1;
    //_uut.oddLine = 1;
    _uut.eval();

    for (unsigned int i = 0; i < 9U * 16U; ++i)
    {
        _uut.phaseClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        //TODO assert
        
        _uut.subcarrierPhase = (_uut.subcarrierPhase + 1) % 16;
        _uut.phaseClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }

    vcd_trace.close();
}

TEST_F(PalGeneratorTests, JustBlue)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PalGeneratorBlue.vcd");

    _uut.reset = 0;
    _uut.phaseClock = 0;
    _uut.subcarrierPhase = 0;
    _uut.blank = 0;
    _uut.sync = 0;
    _uut.burst = 0;
    //_uut.oddFrame = 1;
    //_uut.oddLine = 1;
    _uut.y = 29;
    _uut.u = 111;
    _uut.v = -26;
    _uut.eval();

    for (unsigned int i = 0; i < 9U * 16U; ++i)
    {
        _uut.phaseClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        // TODO
        //ASSERT_EQ(8 - round(4 * cos(2 * 3.14159265 * _uut.subcarrierPhase / 16.0)), _uut.dacSample);
        
        _uut.subcarrierPhase = (_uut.subcarrierPhase + 1) % 16;
        _uut.phaseClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }

    vcd_trace.close();
}

TEST_F(PalGeneratorTests, JustYellow)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PalGeneratorYellow.vcd");

    _uut.reset = 0;
    _uut.phaseClock = 0;
    _uut.subcarrierPhase = 0;
    _uut.blank = 0;
    _uut.sync = 0;
    _uut.burst = 0;
    //_uut.oddFrame = 1;
    //_uut.oddLine = 1;
    _uut.y = 226;
    _uut.u = -111;
    _uut.v = 26;
    _uut.eval();

    for (unsigned int i = 0; i < 9U * 16U; ++i)
    {
        _uut.phaseClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        // TODO
        //ASSERT_EQ(8 - round(4 * cos(2 * 3.14159265 * _uut.subcarrierPhase / 16.0)), _uut.dacSample);
        
        _uut.subcarrierPhase = (_uut.subcarrierPhase + 1) % 16;
        _uut.phaseClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }

    vcd_trace.close();
}

TEST_F(PalGeneratorTests, TimingWithPositiveU)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PalGeneratorPositiveU.vcd");
    
    VPalTiming timing;
    timing.reset = 0;
    timing.phaseClock = 0;
    timing.progressive = 0;
    timing.eval();
    
    _uut.reset = 0;
    _uut.subcarrierPhase = 0;
    _uut.y = 0x80;
    _uut.u = 0x80;
    _uut.v = 0x00;
    _uut.blank = timing.blank;
    _uut.sync = timing.sync;
    _uut.burst = timing.burst;
    _uut.burstPhase = 0;
    _uut.eval();
    
    for (unsigned int i = 0; i < 910U * 4U * 40U; ++i)
    {
        _uut.phaseClock = 1;
        timing.phaseClock = 1;
        _uut.eval();
        timing.eval();
        vcd_trace.dump(_tickCount++);
        // TODO
        //ASSERT_EQ(8 - round(4 * cos(2 * 3.14159265 * _uut.subcarrierPhase / 16.0)), _uut.dacSample);
        
        _uut.y = (timing.hPos > 17U && timing.hPos < 737U) ? 226 : 0;
        _uut.u = (timing.hPos > 17U && timing.hPos < 737U) ? -111 : 0;
        _uut.v = (timing.hPos > 17U && timing.hPos < 737U) ? 26 : 0;
        _uut.phaseClock = 0;
        timing.phaseClock = 0;
        timing.eval();
        _uut.subcarrierPhase = timing.phase;
        _uut.blank = timing.blank;
        _uut.sync = timing.sync;
        _uut.burst = timing.burst;
        _uut.burstPhase = timing.burstPhase;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    
    timing.final();
    vcd_trace.close();
}

