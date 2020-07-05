//
// SpdifChannelStatusTests - Unit tests for verilated SpdifChannelStatus module
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
#include "VSpdifChannelStatus.h"

class SpdifChannelStatusTests : public ::testing::Test
{
    public:
        SpdifChannelStatusTests() { }
        virtual ~SpdifChannelStatusTests()
        {
            _uut.final();
        }
        
    protected:
        VSpdifChannelStatus _uut;
};

TEST_F(SpdifChannelStatusTests, TypicalValues)
{
    _uut.channelNum = 1; // Left channel
    _uut.categoryCode = 0x60; // Analog-to-digital converter without copyright info
    _uut.samplingFreq = 2; // 48 kHz
    _uut.wordLength = 2; // 16 bits
    _uut.eval();
    EXPECT_EQ(0x02106004U, _uut.channelStatus[0]);
    EXPECT_EQ(0x00000002U, _uut.channelStatus[1]);
    EXPECT_EQ(0x00000000U, _uut.channelStatus[2]);
    EXPECT_EQ(0x00000000U, _uut.channelStatus[3]);
    EXPECT_EQ(0x00000000U, _uut.channelStatus[4]);
    EXPECT_EQ(0x00000000U, _uut.channelStatus[5]);
    EXPECT_EQ(0x00000000U, _uut.channelStatus[6]);
}

TEST_F(SpdifChannelStatusTests, RandomValues)
{
    srand(time(nullptr));
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        _uut.channelNum = rand() % 0x10;
        _uut.categoryCode = rand() % 0x100;
        _uut.samplingFreq = rand() % 0x10;
        _uut.wordLength = rand() % 0x10;
        _uut.eval();
        EXPECT_EQ(0x00000004U | _uut.categoryCode << 8 | _uut.samplingFreq << 24 | _uut.channelNum << 20, _uut.channelStatus[0]);
        EXPECT_EQ(0x00000000U | _uut.wordLength, _uut.channelStatus[1]);
        EXPECT_EQ(0x00000000U, _uut.channelStatus[2]);
        EXPECT_EQ(0x00000000U, _uut.channelStatus[3]);
        EXPECT_EQ(0x00000000U, _uut.channelStatus[4]);
        EXPECT_EQ(0x00000000U, _uut.channelStatus[5]);
        EXPECT_EQ(0x00000000U, _uut.channelStatus[6]);
    }
}


