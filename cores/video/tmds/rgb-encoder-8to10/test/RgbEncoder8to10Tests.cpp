//
// RgbEncoder8to10Tests - Unit tests for verilated RgbEncoder8to10 module
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

#include <stdlib.h>
#include <time.h>
#include "gtest/gtest.h"
#include "VRgbEncoder8to10.h"

class RgbEncoder8to10Tests : public ::testing::Test
{
    public:
        RgbEncoder8to10Tests() :
            _expectedDisparityCnt(0)
        {
            
        }
        
        virtual ~RgbEncoder8to10Tests()
        {
            _uut.final();
        }
        
    protected:
        VRgbEncoder8to10 _uut;
        int _expectedDisparityCnt;
        
        void testEncodingByteWithTmds(unsigned char d);
        static int numberOfOneBits(unsigned char d);
        static int numberOfZeroBits(unsigned char d) { return 8 - numberOfOneBits(d); }
};

int RgbEncoder8to10Tests::numberOfOneBits(unsigned char d)
{
    int numOnes = 0;
    
    for (int i = 0; i < 8; ++i)
    {
        if (((d >> i) & 1U) != 0U)
        {
            ++numOnes;
        }
    }
    
    return numOnes;
}

void RgbEncoder8to10Tests::testEncodingByteWithTmds(unsigned char d)
{
    // First, set the input and evaluate the module
    _uut.d = d;
    _uut.clock = 0;
    _uut.reset = 0;
    _uut.eval();
    
    // Calculate the expected encoded output and updated disparity count
    
    unsigned int q_m = (d & 1);
    if (numberOfOneBits(d) > 4 || (numberOfOneBits(d) == 4 && (d & 1) == 0))
    {
        // xnor (bitwise equality)
        q_m |= (((q_m >> 0) & 1) == ((d >> 1) & 1)) << 1;
        q_m |= (((q_m >> 1) & 1) == ((d >> 2) & 1)) << 2;
        q_m |= (((q_m >> 2) & 1) == ((d >> 3) & 1)) << 3;
        q_m |= (((q_m >> 3) & 1) == ((d >> 4) & 1)) << 4;
        q_m |= (((q_m >> 4) & 1) == ((d >> 5) & 1)) << 5;
        q_m |= (((q_m >> 5) & 1) == ((d >> 6) & 1)) << 6;
        q_m |= (((q_m >> 6) & 1) == ((d >> 7) & 1)) << 7;
        q_m |= 0U << 8;
    }
    else
    {
        // xor
        q_m |= (((q_m >> 0) & 1) ^ ((d >> 1) & 1)) << 1;
        q_m |= (((q_m >> 1) & 1) ^ ((d >> 2) & 1)) << 2;
        q_m |= (((q_m >> 2) & 1) ^ ((d >> 3) & 1)) << 3;
        q_m |= (((q_m >> 3) & 1) ^ ((d >> 4) & 1)) << 4;
        q_m |= (((q_m >> 4) & 1) ^ ((d >> 5) & 1)) << 5;
        q_m |= (((q_m >> 5) & 1) ^ ((d >> 6) & 1)) << 6;
        q_m |= (((q_m >> 6) & 1) ^ ((d >> 7) & 1)) << 7;
        q_m |= 1U << 8;
    }
    
    unsigned int q_out = 0;
    if (0 == _expectedDisparityCnt || numberOfOneBits(q_m) == numberOfZeroBits(q_m))
    {
        q_out |= (((~q_m >> 8) & 1)) << 9;
        q_out |= (((q_m >> 8) & 1)) << 8;
        q_out |= ((q_m >> 8) & 1) ? (q_m & 0xFF) : (~q_m & 0xFF);
        
        if (((q_m >> 8) & 1) == 0)
        {
            _expectedDisparityCnt += numberOfZeroBits(q_m) - numberOfOneBits(q_m);
        }
        else
        {
            _expectedDisparityCnt += numberOfOneBits(q_m) - numberOfZeroBits(q_m);
        }
    }
    else
    {
        if ((_expectedDisparityCnt > 0 && numberOfOneBits(q_m) > numberOfZeroBits(q_m)) ||
            (_expectedDisparityCnt < 0 && numberOfZeroBits(q_m) > numberOfOneBits(q_m)))
        {
            q_out |= 1U << 9;
            q_out |= (((q_m >> 8) & 1)) << 8;
            q_out |= (~q_m & 0xFF);
            _expectedDisparityCnt += 2 * ((q_m >> 8) & 1) + numberOfZeroBits(q_m) - numberOfOneBits(q_m);
        }
        else
        {
            q_out |= 0U << 9;
            q_out |= (((q_m >> 8) & 1)) << 8;
            q_out |= (q_m & 0xFF);
            _expectedDisparityCnt += -2 * ((~q_m >> 8) & 1) + numberOfOneBits(q_m) - numberOfZeroBits(q_m);
        }
    }
    
    // Check the encoded output
    //std::cout << "Output q is " << static_cast<unsigned int>(_uut.q) << std::endl;
    ASSERT_EQ(q_out, _uut.q);
    
    // Decode and make sure it matches the input
    
    unsigned char q_possibly_inverted;
    if ((_uut.q >> 9) & 1)
    {
        q_possibly_inverted = (~_uut.q) & 0xFF;
    }
    else
    {
        q_possibly_inverted = (_uut.q) & 0xFF;
    }
    
    unsigned char q_decoded = 0;
    if ((_uut.q >> 8) & 1)
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
    
    ASSERT_EQ(d, q_decoded);
    
    // Check the new disparity count
    // Normalize to an unsigned 5-bit field for comparison to the internal disparity count register
    ASSERT_EQ((_expectedDisparityCnt + 0x20) % 0x20, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
    
    // Rising clock edge to store the new disparity count
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ((_expectedDisparityCnt + 0x20) % 0x20, _uut.RgbEncoder8to10__DOT__disparity_cnt);
    
    // Disparity count should never stray outside of -10..10
    ASSERT_LE(abs(_expectedDisparityCnt), 10);
}

TEST_F(RgbEncoder8to10Tests, InitialConditions)
{
    _uut.eval();
    ASSERT_EQ(0U, _uut.RgbEncoder8to10__DOT__disparity_cnt);
}

TEST_F(RgbEncoder8to10Tests, XnorWithFive1Bits)
{
    _uut.d = 0x1F;
    _uut.eval();
    ASSERT_EQ(0U, (_uut.q >> 8) & 1U);
}

TEST_F(RgbEncoder8to10Tests, XnorWithFour1BitsWith0BitZero)
{
    _uut.d = 0x1E;
    _uut.eval();
    ASSERT_EQ(0U, (_uut.q >> 8) & 1U);
}

TEST_F(RgbEncoder8to10Tests, XorWithThree1Bits)
{
    _uut.d = 0x70;
    _uut.eval();
    ASSERT_EQ(1U, (_uut.q >> 8) & 1U);
}

TEST_F(RgbEncoder8to10Tests, ZeroDisparityCntXor)
{
    _uut.d = 0x49;
    _uut.eval();
    ASSERT_EQ(0U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(1U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0xC7, _uut.q & 0xFF); //11000111
    ASSERT_EQ(2, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
}

TEST_F(RgbEncoder8to10Tests, ZeroDisparityCntXnor)
{
    _uut.d = 0x79;
    _uut.eval();
    ASSERT_EQ(1U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(0U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0x82, _uut.q & 0xFF); //10000010
    ASSERT_EQ(0x20-4, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
}

TEST_F(RgbEncoder8to10Tests, PosDisparityMoreOnes)
{
    _uut.clock = 0;
    _uut.d = 0x49;
    _uut.eval();
    ASSERT_EQ(0U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(1U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0xC7, _uut.q & 0xFF); //11000111
    ASSERT_EQ(2, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(2, _uut.RgbEncoder8to10__DOT__disparity_cnt);
    _uut.d = 0xFF;
    _uut.eval();
    ASSERT_EQ(1U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(0U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0x00, _uut.q & 0xFF);
    ASSERT_EQ(0x20-6, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
}

TEST_F(RgbEncoder8to10Tests, PosDisparityMoreZeros)
{
    _uut.clock = 0;
    _uut.d = 0x49;
    _uut.eval();
    ASSERT_EQ(0U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(1U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0xC7, _uut.q & 0xFF); //11000111
    ASSERT_EQ(2, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(2, _uut.RgbEncoder8to10__DOT__disparity_cnt);
    _uut.d = 0x00;
    _uut.eval();
    ASSERT_EQ(0U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(1U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0x00, _uut.q & 0xFF);
    ASSERT_EQ(0x20-6, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
}

TEST_F(RgbEncoder8to10Tests, NegDisparityMoreOnes)
{
    _uut.d = 0x79;
    _uut.eval();
    ASSERT_EQ(1U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(0U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0x82, _uut.q & 0xFF); //10000010
    ASSERT_EQ(0x20-4, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x20-4, _uut.RgbEncoder8to10__DOT__disparity_cnt);
    _uut.d = 0xFF;
    _uut.eval();
    ASSERT_EQ(0U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(0U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0xFF, _uut.q & 0xFF);
    ASSERT_EQ(0x02, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
}

TEST_F(RgbEncoder8to10Tests, NegDisparityMoreZeros)
{
    _uut.d = 0x79;
    _uut.eval();
    ASSERT_EQ(1U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(0U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0x82, _uut.q & 0xFF); //10000010
    ASSERT_EQ(0x20-4, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x20-4, _uut.RgbEncoder8to10__DOT__disparity_cnt);
    _uut.d = 0x00;
    _uut.eval();
    ASSERT_EQ(1U, (_uut.q >> 9) & 1U);
    ASSERT_EQ(1U, (_uut.q >> 8) & 1U);
    ASSERT_EQ(0xFF, _uut.q & 0xFF);
    ASSERT_EQ(0x06, _uut.RgbEncoder8to10__DOT__disparity_cnt_next);
}

TEST_F(RgbEncoder8to10Tests, InputSweepAscending)
{
    _uut.eval();
    for (unsigned int i = 0; i <= 0xFF; ++i)
    {
        //std::cout << "Testing input of " << i << std::endl;
        testEncodingByteWithTmds(static_cast<unsigned char>(i));
        //std::cout << "Disparity count is " << static_cast<unsigned int>(_uut.RgbEncoder8to10__DOT__disparity_cnt) << std::endl;
    }
}

TEST_F(RgbEncoder8to10Tests, InputSweepDescending)
{
    _uut.eval();
    for (int i = 0xFF; i >= 0; --i)
    {
        //std::cout << "Testing input of " << i << std::endl;
        testEncodingByteWithTmds(static_cast<unsigned char>(i));
        //std::cout << "Disparity count is " << static_cast<unsigned int>(_uut.RgbEncoder8to10__DOT__disparity_cnt) << std::endl;
    }
}

TEST_F(RgbEncoder8to10Tests, InputSweepAscendingXor)
{
    _uut.eval();
    for (unsigned int i = 0; i <= 0xFF; ++i)
    {
        //std::cout << "Testing input of " << i << std::endl;
        testEncodingByteWithTmds(static_cast<unsigned char>(i ^ 0x5A));
        //std::cout << "Disparity count is " << static_cast<unsigned int>(_uut.RgbEncoder8to10__DOT__disparity_cnt) << std::endl;
    }
}

TEST_F(RgbEncoder8to10Tests, RandomInputs)
{
    srand(time(nullptr));
    _uut.eval();
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        int d = rand() % 0x100;
        //std::cout << "Testing input of " << d << std::endl;
        testEncodingByteWithTmds(static_cast<unsigned char>(d));
        //std::cout << "Disparity count is " << _expectedDisparityCnt << std::endl;
    }
}




