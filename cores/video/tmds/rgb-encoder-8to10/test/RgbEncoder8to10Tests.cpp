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
        unsigned int _expectedDisparityCnt;
};

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


