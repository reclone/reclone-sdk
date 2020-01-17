//
// AudioClockRegenPacketTests - Unit tests for verilated AudioClockRegenPacket module
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

#include "gtest/gtest.h"
#include "VAudioClockRegenPacket.h"

class AudioClockRegenPacketTests : public ::testing::Test
{
    public:
        AudioClockRegenPacketTests() { }
        virtual ~AudioClockRegenPacketTests()
        {
            _uut.final();
        }
        
    protected:
        VAudioClockRegenPacket _uut;
};

TEST_F(AudioClockRegenPacketTests, TypicalValues)
{
    _uut.n = 6144U;
    _uut.cts = 74250U;
    _uut.eval();
    EXPECT_EQ(0x000001U, _uut.header);
    EXPECT_EQ(0x0018000A220100LLU, _uut.subpacket0);
    EXPECT_EQ(0x0018000A220100LLU, _uut.subpacket1);
    EXPECT_EQ(0x0018000A220100LLU, _uut.subpacket2);
    EXPECT_EQ(0x0018000A220100LLU, _uut.subpacket3);
}

TEST_F(AudioClockRegenPacketTests, RandomValues)
{
    srand(time(nullptr));
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        _uut.n = rand() % 0x100000;
        _uut.cts = rand() % 0x100000;
        _uut.eval();
        EXPECT_EQ(0x000001U, _uut.header);
        EXPECT_EQ(_uut.cts, ((_uut.subpacket0 >> 24) & 0xFF) | ((_uut.subpacket0 >> 8) & 0xFF00) | ((_uut.subpacket0 << 8) & 0x0F0000));
        EXPECT_EQ(_uut.n, ((_uut.subpacket0 >> 48) & 0xFF) | ((_uut.subpacket0 >> 32) & 0xFF00) | ((_uut.subpacket0 >> 16) & 0x0F0000));
        EXPECT_EQ(_uut.cts, ((_uut.subpacket1 >> 24) & 0xFF) | ((_uut.subpacket1 >> 8) & 0xFF00) | ((_uut.subpacket1 << 8) & 0x0F0000));
        EXPECT_EQ(_uut.n, ((_uut.subpacket1 >> 48) & 0xFF) | ((_uut.subpacket1 >> 32) & 0xFF00) | ((_uut.subpacket1 >> 16) & 0x0F0000));
        EXPECT_EQ(_uut.cts, ((_uut.subpacket2 >> 24) & 0xFF) | ((_uut.subpacket2 >> 8) & 0xFF00) | ((_uut.subpacket2 << 8) & 0x0F0000));
        EXPECT_EQ(_uut.n, ((_uut.subpacket2 >> 48) & 0xFF) | ((_uut.subpacket2 >> 32) & 0xFF00) | ((_uut.subpacket2 >> 16) & 0x0F0000));
        EXPECT_EQ(_uut.cts, ((_uut.subpacket3 >> 24) & 0xFF) | ((_uut.subpacket3 >> 8) & 0xFF00) | ((_uut.subpacket3 << 8) & 0x0F0000));
        EXPECT_EQ(_uut.n, ((_uut.subpacket3 >> 48) & 0xFF) | ((_uut.subpacket3 >> 32) & 0xFF00) | ((_uut.subpacket3 >> 16) & 0x0F0000));
    }
}

