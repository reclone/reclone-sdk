//
// ClockEnableDividerTests - Unit tests for verilated ClockEnableDivider module
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

#include "gtest/gtest.h"
#include "VClockEnableDivider.h"

class ClockEnableDividerTests : public ::testing::Test
{
    public:
        ClockEnableDividerTests() { }
        virtual ~ClockEnableDividerTests()
        {
            _uut.final();
        }
        
    protected:
        VClockEnableDivider _uut;
};

TEST_F(ClockEnableDividerTests, ThreeInTen)
{
    _uut.clock = 0;
    _uut.masterEnable = 1;
    _uut.reset = 0;
    _uut.numerator = 3;
    _uut.denominator = 10;
    _uut.eval();
    
    unsigned int enableCount = 0;
    
    for (unsigned int i = 0; i < 100000; ++i)
    {
        _uut.clock = 1;
        _uut.eval();
        
        _uut.clock = 0;
        _uut.eval();

        if (_uut.dividedEnable)
        {
            ++enableCount;
        }
    }

    ASSERT_NEAR(30000U, enableCount, 1U);
}

TEST_F(ClockEnableDividerTests, OneIn1875)
{
    // Let's pretend we are trying to get a 48 kHz sample clock from a 90 MHz input clock
    // 90 MHz / 1875 = 48 KHz
    
    _uut.clock = 0;
    _uut.masterEnable = 1;
    _uut.reset = 0;
    _uut.numerator = 1;
    _uut.denominator = 1875;
    _uut.eval();
    
    unsigned int enableCount = 0;
    
    // Run for one tenth of a second
    for (unsigned int i = 0; i < 9000000; ++i)
    {
        _uut.clock = 1;
        _uut.eval();
        
        _uut.clock = 0;
        _uut.eval();

        if (_uut.dividedEnable)
        {
            ++enableCount;
        }
    }

    ASSERT_NEAR(4800U, enableCount, 1U);
}
