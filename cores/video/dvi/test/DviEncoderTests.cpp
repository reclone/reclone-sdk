//
// DviEncoderTests - Unit tests for verilated DviEncoder module
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
#include "VDviEncoder.h"

class DviEncoderTests : public ::testing::Test
{
    public:
        DviEncoderTests() { }
        virtual ~DviEncoderTests()
        {
            _uut.final();
        }
        
    protected:
        VDviEncoder _uut;
        
        static unsigned int tmdsDecode(unsigned int tmdsWord)
        {
            unsigned int q_possibly_inverted;
            if ((tmdsWord >> 9) & 1)
            {
                q_possibly_inverted = (~tmdsWord) & 0xFF;
            }
            else
            {
                q_possibly_inverted = (tmdsWord) & 0xFF;
            }
            
            unsigned int q_decoded = 0;
            if ((tmdsWord >> 8) & 1)
            {
                // xor
                q_decoded |= (q_possibly_inverted >> 0) & 1;
                q_decoded |= (((q_possibly_inverted >> 1) & 1) ^ ((q_possibly_inverted >> 0) & 1)) << 1;
                q_decoded |= (((q_possibly_inverted >> 2) & 1) ^ ((q_possibly_inverted >> 1) & 1)) << 2;
                q_decoded |= (((q_possibly_inverted >> 3) & 1) ^ ((q_possibly_inverted >> 2) & 1)) << 3;
                q_decoded |= (((q_possibly_inverted >> 4) & 1) ^ ((q_possibly_inverted >> 3) & 1)) << 4;
                q_decoded |= (((q_possibly_inverted >> 5) & 1) ^ ((q_possibly_inverted >> 4) & 1)) << 5;
                q_decoded |= (((q_possibly_inverted >> 6) & 1) ^ ((q_possibly_inverted >> 5) & 1)) << 6;
                q_decoded |= (((q_possibly_inverted >> 7) & 1) ^ ((q_possibly_inverted >> 6) & 1)) << 7;
            }
            else
            {
                // xnor
                q_decoded |= (q_possibly_inverted >> 0) & 1;
                q_decoded |= (((q_possibly_inverted >> 1) & 1) == ((q_possibly_inverted >> 0) & 1)) << 1;
                q_decoded |= (((q_possibly_inverted >> 2) & 1) == ((q_possibly_inverted >> 1) & 1)) << 2;
                q_decoded |= (((q_possibly_inverted >> 3) & 1) == ((q_possibly_inverted >> 2) & 1)) << 3;
                q_decoded |= (((q_possibly_inverted >> 4) & 1) == ((q_possibly_inverted >> 3) & 1)) << 4;
                q_decoded |= (((q_possibly_inverted >> 5) & 1) == ((q_possibly_inverted >> 4) & 1)) << 5;
                q_decoded |= (((q_possibly_inverted >> 6) & 1) == ((q_possibly_inverted >> 5) & 1)) << 6;
                q_decoded |= (((q_possibly_inverted >> 7) & 1) == ((q_possibly_inverted >> 6) & 1)) << 7;
            }
            
            return q_decoded;
        }
};

TEST_F(DviEncoderTests, Blanking)
{
    _uut.pixelClock = 0;
    _uut.dataEnable = 0;
    _uut.blue = 0;
    _uut.green = 0;
    _uut.red = 0;

    _uut.vSync = 0;
    _uut.hSync = 0;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x354, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);

    _uut.vSync = 0;
    _uut.hSync = 1;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x0AB, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);

    _uut.vSync = 1;
    _uut.hSync = 0;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x154, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);

    _uut.vSync = 1;
    _uut.hSync = 1;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x2AB, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);
}

TEST_F(DviEncoderTests, ActiveVideo)
{
    _uut.pixelClock = 0;
    _uut.dataEnable = 1;
    _uut.vSync = 0;
    _uut.hSync = 0;

    _uut.blue = 0x5A;
    _uut.green = 0x0F;
    _uut.red = 0xA5;
    _uut.eval();

    for (unsigned int i = 0; i < 10000U; ++i)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        _uut.pixelClock = 0;
        _uut.eval();
        
        ASSERT_EQ(_uut.blue, tmdsDecode(_uut.channel0));
        ASSERT_EQ(_uut.green, tmdsDecode(_uut.channel1));
        ASSERT_EQ(_uut.red, tmdsDecode(_uut.channel2));
        ASSERT_EQ(0x3E0, _uut.channelC);
    }
}

TEST_F(DviEncoderTests, Multiplexing)
{
    _uut.pixelClock = 0;
    _uut.dataEnable = 0;
    _uut.blue = 0x5A;
    _uut.green = 0x0F;
    _uut.red = 0xA5;

    _uut.vSync = 0;
    _uut.hSync = 0;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x354, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);

    _uut.vSync = 0;
    _uut.hSync = 1;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x0AB, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);
    
    _uut.dataEnable = 1;
    _uut.vSync = 0;
    _uut.hSync = 0;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(_uut.blue, tmdsDecode(_uut.channel0));
    ASSERT_EQ(_uut.green, tmdsDecode(_uut.channel1));
    ASSERT_EQ(_uut.red, tmdsDecode(_uut.channel2));
    ASSERT_EQ(0x3E0, _uut.channelC);
    
    _uut.dataEnable = 0;
    _uut.vSync = 1;
    _uut.hSync = 0;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x154, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);

    _uut.vSync = 1;
    _uut.hSync = 1;
    _uut.eval();
    _uut.pixelClock = 1;
    _uut.eval();
    _uut.pixelClock = 0;
    ASSERT_EQ(0x2AB, _uut.channel0);
    ASSERT_EQ(0x354, _uut.channel1);
    ASSERT_EQ(0x354, _uut.channel2);
    ASSERT_EQ(0x3E0, _uut.channelC);
}

