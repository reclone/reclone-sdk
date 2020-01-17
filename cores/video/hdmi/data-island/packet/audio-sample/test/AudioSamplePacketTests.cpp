//
// AudioSamplePacketTests - Unit tests for verilated AudioSamplePacket module
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
#include "VAudioSamplePacket.h"

class AudioSamplePacketTests : public ::testing::Test
{
    public:
        AudioSamplePacketTests() { }
        virtual ~AudioSamplePacketTests()
        {
            _uut.final();
        }
        
    protected:
        VAudioSamplePacket _uut;
};

TEST_F(AudioSamplePacketTests, RandomValues)
{
    srand(time(nullptr));
    for (unsigned int i = 0; i < 1; ++i)
    {
        _uut.layout = rand() % 0x2;
        _uut.present = rand() % 0x10;
        _uut.flat = rand() % 0x10;
        _uut.sample0 = (rand() % 0x1000000) | (static_cast<unsigned long long>(rand() % 0x1000000) << 24);
        _uut.sample1 = (rand() % 0x1000000) | (static_cast<unsigned long long>(rand() % 0x1000000) << 24);
        _uut.sample2 = (rand() % 0x1000000) | (static_cast<unsigned long long>(rand() % 0x1000000) << 24);
        _uut.sample3 = (rand() % 0x1000000) | (static_cast<unsigned long long>(rand() % 0x1000000) << 24);
        _uut.p0 = rand() % 0x4;
        _uut.p1 = rand() % 0x4;
        _uut.p2 = rand() % 0x4;
        _uut.p3 = rand() % 0x4;
        _uut.c0 = rand() % 0x4;
        _uut.c1 = rand() % 0x4;
        _uut.c2 = rand() % 0x4;
        _uut.c3 = rand() % 0x4;
        _uut.u0 = rand() % 0x4;
        _uut.u1 = rand() % 0x4;
        _uut.u2 = rand() % 0x4;
        _uut.u3 = rand() % 0x4;
        _uut.v0 = rand() % 0x4;
        _uut.v1 = rand() % 0x4;
        _uut.v2 = rand() % 0x4;
        _uut.v3 = rand() % 0x4;
        _uut.eval();
        EXPECT_EQ(0x02U, _uut.header & 0xFF);
        EXPECT_EQ(static_cast<unsigned int>(_uut.present | (_uut.layout << 4)), (_uut.header >> 8) & 0xFF);
        EXPECT_EQ(_uut.flat, (_uut.header >> 16) & 0xFF);
        EXPECT_EQ(_uut.sample0, _uut.subpacket0 & 0xFFFFFFFFFFFF); 
        EXPECT_EQ(_uut.sample1, _uut.subpacket1 & 0xFFFFFFFFFFFF);
        EXPECT_EQ(_uut.sample2, _uut.subpacket2 & 0xFFFFFFFFFFFF);
        EXPECT_EQ(_uut.sample3, _uut.subpacket3 & 0xFFFFFFFFFFFF);
        EXPECT_EQ(static_cast<unsigned int>((_uut.v0 & 1) | ((_uut.u0 & 1) << 1) | ((_uut.c0 & 1) << 2) | ((_uut.p0 & 1) << 3) | ((_uut.v0 & 2) << 3) | ((_uut.u0 & 2) << 4) | ((_uut.c0 & 2) << 5) | ((_uut.p0 & 2) << 6)), (_uut.subpacket0 >> 48) & 0xFF);
        EXPECT_EQ(static_cast<unsigned int>((_uut.v1 & 1) | ((_uut.u1 & 1) << 1) | ((_uut.c1 & 1) << 2) | ((_uut.p1 & 1) << 3) | ((_uut.v1 & 2) << 3) | ((_uut.u1 & 2) << 4) | ((_uut.c1 & 2) << 5) | ((_uut.p1 & 2) << 6)), (_uut.subpacket1 >> 48) & 0xFF);
        EXPECT_EQ(static_cast<unsigned int>((_uut.v2 & 1) | ((_uut.u2 & 1) << 1) | ((_uut.c2 & 1) << 2) | ((_uut.p2 & 1) << 3) | ((_uut.v2 & 2) << 3) | ((_uut.u2 & 2) << 4) | ((_uut.c2 & 2) << 5) | ((_uut.p2 & 2) << 6)), (_uut.subpacket2 >> 48) & 0xFF);
        EXPECT_EQ(static_cast<unsigned int>((_uut.v3 & 1) | ((_uut.u3 & 1) << 1) | ((_uut.c3 & 1) << 2) | ((_uut.p3 & 1) << 3) | ((_uut.v3 & 2) << 3) | ((_uut.u3 & 2) << 4) | ((_uut.c3 & 2) << 5) | ((_uut.p3 & 2) << 6)), (_uut.subpacket3 >> 48) & 0xFF);
    }
}


