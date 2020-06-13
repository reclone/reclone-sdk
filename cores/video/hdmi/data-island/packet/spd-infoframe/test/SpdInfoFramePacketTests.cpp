//
// SpdInfoFramePacketTests - Unit tests for verilated SpdInfoFramePacket module
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
#include "VSpdInfoFramePacket.h"

class SpdInfoFramePacketTests : public ::testing::Test
{
    public:
        SpdInfoFramePacketTests() { }
        virtual ~SpdInfoFramePacketTests()
        {
            _uut.final();
        }
        
    protected:
        VSpdInfoFramePacket _uut;
};

TEST_F(SpdInfoFramePacketTests, TypicalValues)
{
    _uut.vn = 0x5265636C6F6E6500LLU ; // "Reclone"
    _uut.pd[3] = 0x52697365; // "Rise"
    _uut.pd[2] = 0x20534252; // " SBR"
    _uut.pd[1] = 0x43000000; // "C"
    _uut.pd[0] = 0x00000000; // ""
    _uut.sdi = 0x08; // Game
    _uut.eval();
    EXPECT_EQ(0x190183U, _uut.header);
    EXPECT_EQ(0x6E6F6C636552B6LLU, _uut.subpacket0);
    EXPECT_EQ(0x20657369520065LLU, _uut.subpacket1);
    EXPECT_EQ(0x00000043524253LLU, _uut.subpacket2);
    EXPECT_EQ(0x00000800000000LLU, _uut.subpacket3);
}

TEST_F(SpdInfoFramePacketTests, RandomValues)
{
    srand(time(nullptr));
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        _uut.vn = (static_cast<unsigned long long>(rand()) << 32) | rand();
        _uut.pd[3] = rand();
        _uut.pd[2] = rand();
        _uut.pd[1] = rand();
        _uut.pd[0] = rand();
        _uut.sdi = rand() % 0xFF;
        _uut.eval();
        EXPECT_EQ(0x190183U, _uut.header);
        unsigned int checksum = 0x19 + 0x01 + 0x83;
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
        EXPECT_EQ((_uut.vn >> 56) & 0xFF, (_uut.subpacket0 >>  8) & 0xFF);
        EXPECT_EQ((_uut.vn >> 48) & 0xFF, (_uut.subpacket0 >> 16) & 0xFF);
        EXPECT_EQ((_uut.vn >> 40) & 0xFF, (_uut.subpacket0 >> 24) & 0xFF);
        EXPECT_EQ((_uut.vn >> 32) & 0xFF, (_uut.subpacket0 >> 32) & 0xFF);
        EXPECT_EQ((_uut.vn >> 24) & 0xFF, (_uut.subpacket0 >> 40) & 0xFF);
        EXPECT_EQ((_uut.vn >> 16) & 0xFF, (_uut.subpacket0 >> 48) & 0xFF);
        EXPECT_EQ((_uut.vn >>  8) & 0xFF, (_uut.subpacket1 >>  0) & 0xFF);
        EXPECT_EQ((_uut.vn >>  0) & 0xFF, (_uut.subpacket1 >>  8) & 0xFF);
        EXPECT_EQ((_uut.pd[3] >> 24) & 0xFF, (_uut.subpacket1 >> 16) & 0xFF);
        EXPECT_EQ((_uut.pd[3] >> 16) & 0xFF, (_uut.subpacket1 >> 24) & 0xFF);
        EXPECT_EQ((_uut.pd[3] >>  8) & 0xFF, (_uut.subpacket1 >> 32) & 0xFF);
        EXPECT_EQ((_uut.pd[3] >>  0) & 0xFF, (_uut.subpacket1 >> 40) & 0xFF);
        EXPECT_EQ((_uut.pd[2] >> 24) & 0xFF, (_uut.subpacket1 >> 48) & 0xFF);
        EXPECT_EQ((_uut.pd[2] >> 16) & 0xFF, (_uut.subpacket2 >>  0) & 0xFF);
        EXPECT_EQ((_uut.pd[2] >>  8) & 0xFF, (_uut.subpacket2 >>  8) & 0xFF);
        EXPECT_EQ((_uut.pd[2] >>  0) & 0xFF, (_uut.subpacket2 >> 16) & 0xFF);
        EXPECT_EQ((_uut.pd[1] >> 24) & 0xFF, (_uut.subpacket2 >> 24) & 0xFF);
        EXPECT_EQ((_uut.pd[1] >> 16) & 0xFF, (_uut.subpacket2 >> 32) & 0xFF);
        EXPECT_EQ((_uut.pd[1] >>  8) & 0xFF, (_uut.subpacket2 >> 40) & 0xFF);
        EXPECT_EQ((_uut.pd[1] >>  0) & 0xFF, (_uut.subpacket2 >> 48) & 0xFF);
        EXPECT_EQ((_uut.pd[0] >> 24) & 0xFF, (_uut.subpacket3 >>  0) & 0xFF);
        EXPECT_EQ((_uut.pd[0] >> 16) & 0xFF, (_uut.subpacket3 >>  8) & 0xFF);
        EXPECT_EQ((_uut.pd[0] >>  8) & 0xFF, (_uut.subpacket3 >> 16) & 0xFF);
        EXPECT_EQ((_uut.pd[0] >>  0) & 0xFF, (_uut.subpacket3 >> 24) & 0xFF);
        EXPECT_EQ(_uut.sdi, (_uut.subpacket3 >> 32) & 0xFF);
        EXPECT_EQ(0U, (_uut.subpacket3 >> 40) & 0xFF);
        EXPECT_EQ(0U, (_uut.subpacket3 >> 48) & 0xFF);
    }
}


