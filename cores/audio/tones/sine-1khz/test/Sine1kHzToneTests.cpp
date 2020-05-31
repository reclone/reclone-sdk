//
// Sine1kHzToneTests - Unit tests for verilated Sine1kHzTone module
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

#include <cmath>
#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VSine1kHzTone.h"

class Sine1kHzToneTests : public ::testing::Test
{
    public:
        Sine1kHzToneTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~Sine1kHzToneTests()
        {
            _uut.final();
        }
        
    protected:
        VSine1kHzTone _uut;
        unsigned int _tickCount;
};


TEST_F(Sine1kHzToneTests, Accuracy)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("Sine1kHzTone.vcd");

    _uut.reset = 0;
    _uut.sampleEnable = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    // Check two cycles of the sine wave
    for (unsigned int i = 0; i < 96; ++i)
    {
        int generatedSample = static_cast<short>(static_cast<unsigned short>(_uut.sample));
        int expectedSample = static_cast<int>(round(2048.0 * sin(static_cast<double>(i * M_PI / 24.0))));
        ASSERT_EQ(expectedSample, generatedSample);
        
        _uut.audioClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.audioClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    vcd_trace.close();
}