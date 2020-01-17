//
// AudioInfoFramePacketTests - Unit tests for verilated AudioInfoFramePacket module
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
#include "VAudioInfoFramePacket.h"

class AudioInfoFramePacketTests : public ::testing::Test
{
    public:
        AudioInfoFramePacketTests() { }
        virtual ~AudioInfoFramePacketTests()
        {
            _uut.final();
        }
        
    protected:
        VAudioInfoFramePacket _uut;
};

TEST_F(AudioInfoFramePacketTests, TypicalValues)
{
    _uut.cc = 1;
    _uut.ca = 0;
    _uut.lsv = 0;
    _uut.lfepbl = 0;
    _uut.eval();
    EXPECT_EQ(0x0A0184U, _uut.header);
    EXPECT_EQ(0x00000000000170LLU, _uut.subpacket0);
    EXPECT_EQ(0LLU, _uut.subpacket1);
    EXPECT_EQ(0LLU, _uut.subpacket2);
    EXPECT_EQ(0LLU, _uut.subpacket3);
}

TEST_F(AudioInfoFramePacketTests, RandomValues)
{
    srand(time(nullptr));
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        _uut.cc = rand() % 0x8;
        _uut.ca = rand() % 0x100;
        _uut.lsv = rand() % 0x10;
        _uut.lfepbl = rand() % 0x4;
        _uut.eval();
        EXPECT_EQ(0x0A0184U, _uut.header);
        unsigned int checksum = 0x0A + 0x01 + 0x84;
        checksum += ((_uut.subpacket0 >>  0) & 0xFF) + ((_uut.subpacket0 >>  8) & 0xFF) + ((_uut.subpacket0 >> 16) & 0xFF) + ((_uut.subpacket0 >> 24) & 0xFF) + 
                    ((_uut.subpacket0 >> 32) & 0xFF) + ((_uut.subpacket0 >> 40) & 0xFF) + ((_uut.subpacket0 >> 48) & 0xFF);
        checksum += ((_uut.subpacket1 >>  0) & 0xFF) + ((_uut.subpacket1 >>  8) & 0xFF) + ((_uut.subpacket1 >> 16) & 0xFF) + ((_uut.subpacket1 >> 24) & 0xFF) + 
                    ((_uut.subpacket1 >> 32) & 0xFF) + ((_uut.subpacket1 >> 40) & 0xFF) + ((_uut.subpacket1 >> 48) & 0xFF);
        checksum += ((_uut.subpacket2 >>  0) & 0xFF) + ((_uut.subpacket2 >>  8) & 0xFF) + ((_uut.subpacket2 >> 16) & 0xFF) + ((_uut.subpacket2 >> 24) & 0xFF) + 
                    ((_uut.subpacket2 >> 32) & 0xFF) + ((_uut.subpacket2 >> 40) & 0xFF) + ((_uut.subpacket2 >> 48) & 0xFF);
        checksum += ((_uut.subpacket3 >>  0) & 0xFF) + ((_uut.subpacket3 >>  8) & 0xFF) + ((_uut.subpacket3 >> 16) & 0xFF) + ((_uut.subpacket3 >> 24) & 0xFF) + 
                    ((_uut.subpacket3 >> 32) & 0xFF) + ((_uut.subpacket3 >> 40) & 0xFF) + ((_uut.subpacket3 >> 48) & 0xFF);
        checksum = checksum & 0xFF;
        EXPECT_EQ(0U, checksum);
        EXPECT_EQ(_uut.cc, (_uut.subpacket0 >> 8) & 0x7);
        EXPECT_EQ(_uut.ca, (_uut.subpacket0 >> 32) & 0xFF);
        EXPECT_EQ(_uut.lsv, (_uut.subpacket0 >> 43) & 0xF);
        EXPECT_EQ(_uut.lfepbl, (_uut.subpacket0 >> 40) & 0x3);
    }
}

