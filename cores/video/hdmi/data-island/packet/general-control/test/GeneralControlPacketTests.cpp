//
// GeneralControlPacketTests - Unit tests for verilated GeneralControlPacket module
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
#include "VGeneralControlPacket.h"

class GeneralControlPacketTests : public ::testing::Test
{
    public:
        GeneralControlPacketTests() { }
        virtual ~GeneralControlPacketTests()
        {
            _uut.final();
        }
        
    protected:
        VGeneralControlPacket _uut;
};

TEST_F(GeneralControlPacketTests, TypicalValues)
{
    _uut.avmute = 0;
    _uut.cd = 0;
    _uut.pp = 0;
    _uut.defaultPhase = 0;
    _uut.eval();
    EXPECT_EQ(0x000003U, _uut.header);
    EXPECT_EQ(0x00000000000010LLU, _uut.subpacket0);
    EXPECT_EQ(0x00000000000010LLU, _uut.subpacket1);
    EXPECT_EQ(0x00000000000010LLU, _uut.subpacket2);
    EXPECT_EQ(0x00000000000010LLU, _uut.subpacket3);
}

TEST_F(GeneralControlPacketTests, RandomValues)
{
    srand(time(nullptr));
    for (unsigned int i = 0; i < 10000; ++i)
    {
        _uut.avmute = rand() & 1;
        _uut.cd = rand() & 0xF;
        _uut.pp = rand() & 0xF;
        _uut.defaultPhase = rand() & 1;
        _uut.eval();
        EXPECT_EQ(0x000003U, _uut.header);
        EXPECT_EQ(_uut.avmute,                               _uut.subpacket0 & 0x1);
        EXPECT_EQ(static_cast<unsigned int>(!_uut.avmute),  (_uut.subpacket0 >> 4) & 0x1);
        EXPECT_EQ(_uut.cd,                                  (_uut.subpacket0 >> 8) & 0xF);
        EXPECT_EQ(_uut.pp,                                  (_uut.subpacket0 >> 12) & 0xF);
        EXPECT_EQ(_uut.defaultPhase,                        (_uut.subpacket0 >> 16) & 1);
        EXPECT_EQ(_uut.avmute,                               _uut.subpacket1 & 0x1);
        EXPECT_EQ(static_cast<unsigned int>(!_uut.avmute),  (_uut.subpacket1 >> 4) & 0x1);
        EXPECT_EQ(_uut.cd,                                  (_uut.subpacket1 >> 8) & 0xF);
        EXPECT_EQ(_uut.pp,                                  (_uut.subpacket1 >> 12) & 0xF);
        EXPECT_EQ(_uut.defaultPhase,                        (_uut.subpacket1 >> 16) & 1);
        EXPECT_EQ(_uut.avmute,                               _uut.subpacket2 & 0x1);
        EXPECT_EQ(static_cast<unsigned int>(!_uut.avmute),  (_uut.subpacket2 >> 4) & 0x1);
        EXPECT_EQ(_uut.cd,                                  (_uut.subpacket2 >> 8) & 0xF);
        EXPECT_EQ(_uut.pp,                                  (_uut.subpacket2 >> 12) & 0xF);
        EXPECT_EQ(_uut.defaultPhase,                        (_uut.subpacket2 >> 16) & 1);
        EXPECT_EQ(_uut.avmute,                               _uut.subpacket3 & 0x1);
        EXPECT_EQ(static_cast<unsigned int>(!_uut.avmute),  (_uut.subpacket3 >> 4) & 0x1);
        EXPECT_EQ(_uut.cd,                                  (_uut.subpacket3 >> 8) & 0xF);
        EXPECT_EQ(_uut.pp,                                  (_uut.subpacket3 >> 12) & 0xF);
        EXPECT_EQ(_uut.defaultPhase,                        (_uut.subpacket3 >> 16) & 1);
    }
}

