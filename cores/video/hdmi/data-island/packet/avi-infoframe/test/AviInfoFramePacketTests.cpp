//
// AviInfoFramePacketTests - Unit tests for verilated AviInfoFramePacket module
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
#include "VAviInfoFramePacket.h"

class AviInfoFramePacketTests : public ::testing::Test
{
    public:
        AviInfoFramePacketTests() { }
        virtual ~AviInfoFramePacketTests()
        {
            _uut.final();
        }
        
    protected:
        VAviInfoFramePacket _uut;
};

TEST_F(AviInfoFramePacketTests, TypicalValues)
{
    _uut.s = 2U;
    _uut.a = 0;
    _uut.y = 0;
    _uut.r = 8U;
    _uut.m = 2U;
    _uut.c = 0;
    _uut.sc = 0;
    _uut.q = 0;
    _uut.ec = 0;
    _uut.itc = 0;
    _uut.vic = 4U;
    _uut.pr = 0;
    _uut.cn = 3U;
    _uut.yq = 0;
    _uut.eval();
    EXPECT_EQ(0x0D0282U, _uut.header);
    EXPECT_EQ(0x300400280211LLU, _uut.subpacket0);
    EXPECT_EQ(0LLU, _uut.subpacket1);
    EXPECT_EQ(0LLU, _uut.subpacket2);
    EXPECT_EQ(0LLU, _uut.subpacket3);
}

TEST_F(AviInfoFramePacketTests, RandomValues)
{
    srand(time(nullptr));
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        _uut.s = rand() % 0x4;
        _uut.a = rand() % 0x2;
        _uut.y = rand() % 0x4;
        _uut.r = rand() % 0x10;
        _uut.m = rand() % 0x4;
        _uut.c = rand() % 0x4;
        _uut.sc = rand() % 0x4;
        _uut.q = rand() % 0x4;
        _uut.ec = rand() % 0x8;
        _uut.itc = rand() % 0x2;
        _uut.vic = rand() % 0x80;
        _uut.pr = rand() % 0x10;
        _uut.cn = rand() % 0x4;
        _uut.yq = rand() % 0x4;
        _uut.eval();
        EXPECT_EQ(0x0D0282U, _uut.header);
        unsigned int checksum = 0x0D + 0x02 + 0x82;
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
        EXPECT_EQ(_uut.s, (_uut.subpacket0 >>  8) & 0x3);
        EXPECT_EQ(_uut.a, (_uut.subpacket0 >> 12) & 0x1);
        EXPECT_EQ(_uut.y, (_uut.subpacket0 >> 13) & 0x3);
        EXPECT_EQ(_uut.r, (_uut.subpacket0 >> 16) & 0xF);
        EXPECT_EQ(_uut.m, (_uut.subpacket0 >> 20) & 0x3);
        EXPECT_EQ(_uut.c, (_uut.subpacket0 >> 22) & 0x3);
        EXPECT_EQ(_uut.sc, (_uut.subpacket0 >> 24) & 0x3);
        EXPECT_EQ(_uut.q, (_uut.subpacket0 >> 26) & 0x3);
        EXPECT_EQ(_uut.ec, (_uut.subpacket0 >> 28) & 0x7);
        EXPECT_EQ(_uut.itc, (_uut.subpacket0 >> 31) & 0x1);
        EXPECT_EQ(_uut.vic, (_uut.subpacket0 >> 32) & 0x7F);
        EXPECT_EQ(_uut.pr, (_uut.subpacket0 >> 40) & 0x0F);
        EXPECT_EQ(_uut.cn, (_uut.subpacket0 >> 44) & 0x3);
        EXPECT_EQ(_uut.yq, (_uut.subpacket0 >> 46) & 0x3);
    }
}


