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

#include <cstdlib>     /* srand, rand */
#include <ctime>       /* time */
#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VDataIslandPacketSerializer.h"

class DataIslandPacketSerializerTests : public ::testing::Test
{
    public:
        DataIslandPacketSerializerTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
            srand(time(NULL));
        }
        
        virtual ~DataIslandPacketSerializerTests()
        {
            _uut.final();
        }
        
    protected:
        VDataIslandPacketSerializer _uut;
        unsigned int _tickCount;
        
        unsigned char bchParity(unsigned long long payload, unsigned int numBits)
        {
            unsigned char parity = 0;

            for (unsigned int i = 0; i < numBits; ++i)
            {
                parity = (parity >> 1) ^ ((((payload >> i) & 1) ^ (parity & 1)) ? 0x83 : 0x00);
            }

            return parity;
        }

        unsigned long long randomUInt64()
        {
            return rand() ^ (static_cast<unsigned long long>(rand()) << 16) ^ (static_cast<unsigned long long>(rand()) << 32) ^ (static_cast<unsigned long long>(rand()) << 48);
        }
};

TEST_F(DataIslandPacketSerializerTests, FixedValues)
{
    const unsigned char ch0[] = {0x4, 0x8, 0x8, 0x8, 0x9, 0x9, 0x9, 0xD, 0xC, 0x8, 0xC, 0x8, 0x9, 0xD, 0x9, 0xD,
                                 0xE, 0xE, 0xA, 0xA, 0xB, 0xB, 0xF, 0xF, 0xE, 0xA, 0xE, 0xA, 0xF, 0xF, 0xB, 0xB};
    const unsigned char ch1[] = {0xF, 0xF, 0xA, 0x0, 0x0, 0xF, 0xA, 0x0, 0xF, 0xF, 0xA, 0x0, 0x0, 0xF, 0xA, 0x0,
                                 0xF, 0x0, 0xA, 0x0, 0x0, 0x0, 0xA, 0x0, 0xF, 0x0, 0xA, 0x0, 0xC, 0x9, 0xF, 0xC};
    const unsigned char ch2[] = {0xF, 0xF, 0xC, 0x0, 0xF, 0xF, 0xC, 0x0, 0x0, 0xF, 0xC, 0x0, 0x0, 0xF, 0xC, 0x0,
                                 0xF, 0xF, 0xC, 0x0, 0xF, 0xF, 0xC, 0x0, 0x0, 0xF, 0xC, 0x0, 0xC, 0xC, 0x5, 0xA};
    
    _uut.header = 0xC3A581;
    _uut.subpacket0 = 0x090A0B0C0D0E0F;
    _uut.subpacket1 = 0x191A1B1C1D1E1F;
    _uut.subpacket2 = 0x292A2B2C2D2E2F;
    _uut.subpacket3 = 0x393A3B3C3D3E3F;
    
    for (unsigned int i = 0; i < 32; ++i)
    {
        _uut.isFirstPacketClock = (i == 0) ? 1 : 0;
        _uut.vsync = (i >= 16) ? 1 : 0;
        _uut.hsync = ((i % 8) >= 4) ? 1 : 0;
        _uut.clock = 0;
        _uut.eval();
        
        EXPECT_EQ(ch0[i], _uut.terc4channel0) << i;
        EXPECT_EQ(ch1[i], _uut.terc4channel1) << i;
        EXPECT_EQ(ch2[i], _uut.terc4channel2) << i;
        _uut.clock = 1;
        _uut.eval();
    }
}

TEST_F(DataIslandPacketSerializerTests, RandomValues)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("DataIslandPacketSerializerRandoms.vcd");
    

    // Set up random header and subpackets
    _uut.header = randomUInt64() & 0xFFFFFF;
    _uut.subpacket0 = randomUInt64() & 0xFFFFFFFFFFFFFF;
    _uut.subpacket1 = randomUInt64() & 0xFFFFFFFFFFFFFF;
    _uut.subpacket2 = randomUInt64() & 0xFFFFFFFFFFFFFF;
    _uut.subpacket3 = randomUInt64() & 0xFFFFFFFFFFFFFF;
    _uut.vsync = 0;
    _uut.hsync = 1;
    
    // Calculate expected TERC4 channel values
    
    unsigned long long headerWithParity = _uut.header | (bchParity(_uut.header, 24) << 24);
    unsigned char ch0[32];
    for (unsigned int i = 0; i < 32; ++i)
    {
        // Bit 0: HSync
        // Bit 1: VSync
        // Bit 2: Header bit (LSbit first)
        // Bit 3: Zero if first bit of the data island
        ch0[i] = (_uut.hsync & 0x1) | ((_uut.vsync & 0x1) << 1) | (((headerWithParity >> i) & 0x1) << 2) | ((0 != i) << 3);
    }
    
    unsigned long long subpacket0WithParity = _uut.subpacket0 | (static_cast<unsigned long long>(bchParity(_uut.subpacket0, 56)) << 56);
    unsigned long long subpacket1WithParity = _uut.subpacket1 | (static_cast<unsigned long long>(bchParity(_uut.subpacket1, 56)) << 56);
    unsigned long long subpacket2WithParity = _uut.subpacket2 | (static_cast<unsigned long long>(bchParity(_uut.subpacket2, 56)) << 56);
    unsigned long long subpacket3WithParity = _uut.subpacket3 | (static_cast<unsigned long long>(bchParity(_uut.subpacket3, 56)) << 56);
    
    unsigned char ch1[32];
    for (unsigned int i = 0; i < 32; ++i)
    {
        // Bit 0: Even-numbered bits of subpacket 0 plus parity
        // Bit 1: Even-numbered bits of subpacket 1 plus parity
        // Bit 2: Even-numbered bits of subpacket 2 plus parity
        // Bit 3: Even-numbered bits of subpacket 3 plus parity
        ch1[i] = ((subpacket0WithParity >> (2*i)) & 1) | (((subpacket1WithParity >> (2*i)) & 1) << 1) | (((subpacket2WithParity >> (2*i)) & 1) << 2) | (((subpacket3WithParity >> (2*i)) & 1) << 3);
    }
    
    unsigned char ch2[32];
    for (unsigned int i = 0; i < 32; ++i)
    {
        // Bit 0: Odd-numbered bits of subpacket 0 plus parity
        // Bit 1: Odd-numbered bits of subpacket 1 plus parity
        // Bit 2: Odd-numbered bits of subpacket 2 plus parity
        // Bit 3: Odd-numbered bits of subpacket 3 plus parity
        ch2[i] = ((subpacket0WithParity >> (2*i+1)) & 1) | (((subpacket1WithParity >> (2*i+1)) & 1) << 1) | (((subpacket2WithParity >> (2*i+1)) & 1) << 2) | (((subpacket3WithParity >> (2*i+1)) & 1) << 3);
    }
    
    for (unsigned int i = 0; i < 32; ++i)
    {
        _uut.isFirstPacketClock = (i == 0) ? 1 : 0;
        _uut.vsync = 0;
        _uut.hsync = 1;
        _uut.clock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        EXPECT_EQ(ch0[i], _uut.terc4channel0) << i;
        EXPECT_EQ(ch1[i], _uut.terc4channel1) << i;
        EXPECT_EQ(ch2[i], _uut.terc4channel2) << i;
        
        _uut.clock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
}

TEST_F(DataIslandPacketSerializerTests, AviInfoframe)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("DataIslandPacketSerializerAviInfoframe.vcd");
    

    // Set up header and subpackets
    _uut.header = 0x0D0282;
    _uut.subpacket0 = 0x0000000000402F;
    _uut.subpacket1 = 0x00000000000000;
    _uut.subpacket2 = 0x00000000000000;
    _uut.subpacket3 = 0x00000000000000;
    _uut.vsync = 0;
    _uut.hsync = 1;
    
    // Calculate expected TERC4 channel values
    
    unsigned long long headerWithParity = _uut.header | (bchParity(_uut.header, 24) << 24);
    unsigned char ch0[32];
    for (unsigned int i = 0; i < 32; ++i)
    {
        // Bit 0: HSync
        // Bit 1: VSync
        // Bit 2: Header bit (LSbit first)
        // Bit 3: Zero if first bit of the data island
        ch0[i] = (_uut.hsync & 0x1) | ((_uut.vsync & 0x1) << 1) | (((headerWithParity >> i) & 0x1) << 2) | ((0 != i) << 3);
    }
    
    unsigned long long subpacket0WithParity = _uut.subpacket0 | (static_cast<unsigned long long>(bchParity(_uut.subpacket0, 56)) << 56);
    unsigned long long subpacket1WithParity = _uut.subpacket1 | (static_cast<unsigned long long>(bchParity(_uut.subpacket1, 56)) << 56);
    unsigned long long subpacket2WithParity = _uut.subpacket2 | (static_cast<unsigned long long>(bchParity(_uut.subpacket2, 56)) << 56);
    unsigned long long subpacket3WithParity = _uut.subpacket3 | (static_cast<unsigned long long>(bchParity(_uut.subpacket3, 56)) << 56);
    
    unsigned char ch1[32];
    for (unsigned int i = 0; i < 32; ++i)
    {
        // Bit 0: Even-numbered bits of subpacket 0 plus parity
        // Bit 1: Even-numbered bits of subpacket 1 plus parity
        // Bit 2: Even-numbered bits of subpacket 2 plus parity
        // Bit 3: Even-numbered bits of subpacket 3 plus parity
        ch1[i] = ((subpacket0WithParity >> (2*i)) & 1) | (((subpacket1WithParity >> (2*i)) & 1) << 1) | (((subpacket2WithParity >> (2*i)) & 1) << 2) | (((subpacket3WithParity >> (2*i)) & 1) << 3);
    }
    
    unsigned char ch2[32];
    for (unsigned int i = 0; i < 32; ++i)
    {
        // Bit 0: Odd-numbered bits of subpacket 0 plus parity
        // Bit 1: Odd-numbered bits of subpacket 1 plus parity
        // Bit 2: Odd-numbered bits of subpacket 2 plus parity
        // Bit 3: Odd-numbered bits of subpacket 3 plus parity
        ch2[i] = ((subpacket0WithParity >> (2*i+1)) & 1) | (((subpacket1WithParity >> (2*i+1)) & 1) << 1) | (((subpacket2WithParity >> (2*i+1)) & 1) << 2) | (((subpacket3WithParity >> (2*i+1)) & 1) << 3);
    }
    
    for (unsigned int i = 0; i < 32; ++i)
    {
        _uut.isFirstPacketClock = (i == 0) ? 1 : 0;
        _uut.vsync = 0;
        _uut.hsync = 1;
        _uut.clock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        EXPECT_EQ(ch0[i], _uut.terc4channel0) << i;
        EXPECT_EQ(ch1[i], _uut.terc4channel1) << i;
        EXPECT_EQ(ch2[i], _uut.terc4channel2) << i;
        
        _uut.clock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
}

