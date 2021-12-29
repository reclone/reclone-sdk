//
// GrayCounterTests - Unit tests for verilated GrayCounter module
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

#include "gtest/gtest.h"
#include "VGrayCounter.h"
#include "VGrayCounter___024root.h"

class GrayCounterTests : public ::testing::Test
{
    public:
        GrayCounterTests() { }
        virtual ~GrayCounterTests()
        {
            _uut.final();
        }
        
    protected:
        VGrayCounter _uut;
};

TEST_F(GrayCounterTests, InitialDefaults)
{
    _uut.clock = 0;
    _uut.enable = 0;
    _uut.reset = 0;
    _uut.eval();
    
    ASSERT_EQ(0x0, _uut.grayCount);
    ASSERT_EQ(0x1, _uut.grayCountNext);
    ASSERT_EQ(0x3, _uut.grayCountNextNext);
    ASSERT_EQ(0U, _uut.rootp->GrayCounter__DOT__binaryCount);
}

TEST_F(GrayCounterTests, Reset)
{
    ASSERT_EQ(0U, _uut.grayCount);
    ASSERT_EQ(0U, _uut.rootp->GrayCounter__DOT__binaryCount);
    
    _uut.clock = 0;
    _uut.enable = 1;
    _uut.reset = 0;
    _uut.eval();
    ASSERT_EQ(0x0, _uut.grayCount);
    
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x1, _uut.grayCount);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x3, _uut.grayCount);
    _uut.clock = 0;
    _uut.eval();

    _uut.reset = 1;
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x0, _uut.grayCount);
    ASSERT_EQ(0x1, _uut.grayCountNext);
    ASSERT_EQ(0x3, _uut.grayCountNextNext);
    ASSERT_EQ(0U, _uut.rootp->GrayCounter__DOT__binaryCount);
    _uut.clock = 0;
    _uut.eval();

    _uut.reset = 0;
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x1, _uut.grayCount);
    _uut.clock = 0;
    _uut.eval();
}

TEST_F(GrayCounterTests, Enable)
{
    ASSERT_EQ(0U, _uut.grayCount);
    ASSERT_EQ(0U, _uut.rootp->GrayCounter__DOT__binaryCount);
    
    _uut.clock = 0;
    _uut.enable = 1;
    _uut.reset = 0;
    _uut.eval();
    ASSERT_EQ(0x0, _uut.grayCount);
    
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x1, _uut.grayCount);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x3, _uut.grayCount);
    _uut.clock = 0;
    _uut.eval();

    _uut.enable = 0;
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x3, _uut.grayCount);
    _uut.clock = 0;
    _uut.eval();

    _uut.enable = 1;
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x2, _uut.grayCount);
    _uut.clock = 0;
    _uut.eval();
}

TEST_F(GrayCounterTests, FourBitGrayCount)
{
    _uut.clock = 0;
    _uut.enable = 1;
    _uut.reset = 0;
    _uut.eval();
    ASSERT_EQ(0x0, _uut.grayCount);
    ASSERT_EQ(0x1, _uut.grayCountNext);
    ASSERT_EQ(0x3, _uut.grayCountNextNext);
    
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x1, _uut.grayCount);
    ASSERT_EQ(0x3, _uut.grayCountNext);
    ASSERT_EQ(0x2, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x3, _uut.grayCount);
    ASSERT_EQ(0x2, _uut.grayCountNext);
    ASSERT_EQ(0x6, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x2, _uut.grayCount);
    ASSERT_EQ(0x6, _uut.grayCountNext);
    ASSERT_EQ(0x7, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x6, _uut.grayCount);
    ASSERT_EQ(0x7, _uut.grayCountNext);
    ASSERT_EQ(0x5, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x7, _uut.grayCount);
    ASSERT_EQ(0x5, _uut.grayCountNext);
    ASSERT_EQ(0x4, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x5, _uut.grayCount);
    ASSERT_EQ(0x4, _uut.grayCountNext);
    ASSERT_EQ(0xC, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x4, _uut.grayCount);
    ASSERT_EQ(0xC, _uut.grayCountNext);
    ASSERT_EQ(0xD, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xC, _uut.grayCount);
    ASSERT_EQ(0xD, _uut.grayCountNext);
    ASSERT_EQ(0xF, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xD, _uut.grayCount);
    ASSERT_EQ(0xF, _uut.grayCountNext);
    ASSERT_EQ(0xE, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xF, _uut.grayCount);
    ASSERT_EQ(0xE, _uut.grayCountNext);
    ASSERT_EQ(0xA, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xE, _uut.grayCount);
    ASSERT_EQ(0xA, _uut.grayCountNext);
    ASSERT_EQ(0xB, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xA, _uut.grayCount);
    ASSERT_EQ(0xB, _uut.grayCountNext);
    ASSERT_EQ(0x9, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xB, _uut.grayCount);
    ASSERT_EQ(0x9, _uut.grayCountNext);
    ASSERT_EQ(0x8, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x9, _uut.grayCount);
    ASSERT_EQ(0x8, _uut.grayCountNext);
    ASSERT_EQ(0x0, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x8, _uut.grayCount);
    ASSERT_EQ(0x0, _uut.grayCountNext);
    ASSERT_EQ(0x1, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x0, _uut.grayCount);
    ASSERT_EQ(0x1, _uut.grayCountNext);
    ASSERT_EQ(0x3, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x1, _uut.grayCount);
    ASSERT_EQ(0x3, _uut.grayCountNext);
    ASSERT_EQ(0x2, _uut.grayCountNextNext);
    _uut.clock = 0;
    _uut.eval();

}