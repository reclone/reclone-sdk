//
// AudioDeltaSigmaDacTests - Unit tests for verilated AudioDeltaSigmaDac module
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
#include "VAudioDeltaSigmaDac.h"

class AudioDeltaSigmaDacTests : public ::testing::Test
{
    public:
        AudioDeltaSigmaDacTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~AudioDeltaSigmaDacTests()
        {
            _uut.final();
        }
        
    protected:
        VAudioDeltaSigmaDac _uut;
        unsigned int _tickCount;
};

TEST_F(AudioDeltaSigmaDacTests, Ramp)
{
    const unsigned int numOversamples = 2000;
    
    for (int sample = -32768; sample <= 32767; ++sample)
    {
        _uut.oversampleClock = 0;
        _uut.reset = 1;
        _uut.sampleEnable = 0;
        _uut.sampleLevel = sample;
        _uut.eval();
        
        _uut.oversampleClock = 1;
        _uut.eval();
        
        _uut.reset = 0;
        _uut.oversampleClock = 0;
        _uut.sampleEnable = 1;
        _uut.eval();
        
        _uut.oversampleClock = 1;
        _uut.eval();
        
        _uut.sampleEnable = 0;
        unsigned int numOneBits = 0;
        
        for (unsigned int i = 0; i < numOversamples; ++i)
        {
            _uut.oversampleClock = 0;
            _uut.eval();

            _uut.oversampleClock = 1;
            _uut.eval();
            
            if (_uut.bitstream)
            {
                ++numOneBits;
            }
        }

        double bitstreamRatio = static_cast<double>(numOneBits) / static_cast<double>(numOversamples);
        double expectedRatio = static_cast<double>(sample) / 262144.0 + 0.5;
        EXPECT_NEAR(expectedRatio, bitstreamRatio, 0.001);
    }
}

TEST_F(AudioDeltaSigmaDacTests, Sine)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("DeltaSigmaSine.vcd");
    
    const unsigned int numOversamples = 2000;
    
    // Simulating two cycles of a 1kHz sine wave at a 48kHz sample rate
    for (unsigned int sampleNum = 0; sampleNum < 96; ++sampleNum)
    {
        int sample = static_cast<int>(round(32767 * sin(M_PI * static_cast<double>(sampleNum) / 24.0)));
        
        _uut.oversampleClock = 0;
        _uut.reset = 1;
        _uut.sampleEnable = 0;
        _uut.sampleLevel = sample;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.oversampleClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.reset = 0;
        _uut.oversampleClock = 0;
        _uut.sampleEnable = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.oversampleClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.sampleEnable = 0;
        
        for (unsigned int i = 0; i < numOversamples; ++i)
        {
            _uut.oversampleClock = 0;
            _uut.eval();
            vcd_trace.dump(_tickCount++);

            _uut.oversampleClock = 1;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
        }
    }
    
    vcd_trace.close();
}