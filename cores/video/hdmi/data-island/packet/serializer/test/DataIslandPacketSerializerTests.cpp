//
// DataIslandPacketSerializerTests - Unit tests for verilated DataIslandPacketSerializer module
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
#include "VDataIslandPacketSerializer.h"

class DataIslandPacketSerializerTests : public ::testing::Test
{
    public:
        DataIslandPacketSerializerTests() { }
        virtual ~DataIslandPacketSerializerTests()
        {
            _uut.final();
        }
        
    protected:
        VDataIslandPacketSerializer _uut;
};

TEST_F(DataIslandPacketSerializerTests, FixedValues)
{
    const unsigned char ch0[] = {0x4, 0x8, 0x8, 0x8, 0x9, 0x9, 0x9, 0xD, 0xC, 0x8, 0xC, 0x8, 0x9, 0xD, 0x9, 0xD,
                                 0xE, 0xE, 0xA, 0xA, 0xB, 0xB, 0xF, 0xF, 0xE, 0xE, 0xE, 0xA, 0xB, 0xF, 0xF, 0xB};
    const unsigned char ch1[] = {0xF, 0xF, 0xA, 0x0, 0x0, 0xF, 0xA, 0x0, 0xF, 0xF, 0xA, 0x0, 0x0, 0xF, 0xA, 0x0,
                                 0xF, 0x0, 0xA, 0x0, 0x0, 0x0, 0xA, 0x0, 0xF, 0x0, 0xA, 0x0, 0xA, 0x0, 0x9, 0xF};
    const unsigned char ch2[] = {0xF, 0xF, 0xC, 0x0, 0xF, 0xF, 0xC, 0x0, 0x0, 0xF, 0xC, 0x0, 0x0, 0xF, 0xC, 0x0,
                                 0xF, 0xF, 0xC, 0x0, 0xF, 0xF, 0xC, 0x0, 0x0, 0xF, 0xC, 0x0, 0xC, 0x5, 0x3, 0x0};
    
    _uut.header = 0xC3A581;
    _uut.subpacket0 = 0x090A0B0C0D0E0F;
    _uut.subpacket1 = 0x191A1B1C1D1E1F;
    _uut.subpacket2 = 0x292A2B2C2D2E2F;
    _uut.subpacket3 = 0x393A3B3C3D3E3F;
    
    for (unsigned int i = 0; i < sizeof(ch1) / sizeof(ch1[0]); ++i)
    {
        _uut.isFirstPacketClock = (i == 0) ? 1 : 0;
        _uut.vsync = (i >= 16) ? 1 : 0;
        _uut.hsync = ((i % 8) >= 4) ? 1 : 0;
        _uut.clock = 0;
        _uut.eval();
        
        ASSERT_EQ(ch0[i], _uut.terc4channel0) << i;
        ASSERT_EQ(ch1[i], _uut.terc4channel1) << i;
        ASSERT_EQ(ch2[i], _uut.terc4channel2) << i;
        _uut.clock = 1;
        _uut.eval();
    }
}

TEST_F(DataIslandPacketSerializerTests, RandomValues)
{
    srand(time(nullptr));
}

