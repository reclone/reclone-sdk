//
// VideoGeneratorSourceTests - Unit tests for verilated VideoGeneratorSource module
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

#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VVideoGeneratorSource.h"
#include "GeneratorBuffer.h"

class VideoGeneratorSourceTests : public ::testing::Test
{
    public:
        VideoGeneratorSourceTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoGeneratorSourceTests()
        {
            _uut.final();
        }
        
    protected:
        VVideoGeneratorSource _uut;
        unsigned int _tickCount;
};

TEST_F(VideoGeneratorSourceTests, LoadGreenScreenTestBitmap)
{
    GeneratorBuffer bmp;
    ASSERT_TRUE(bmp.readBitmap("greenscreen.bmp"));
    
    for (int32_t vPos = 0; vPos < bmp.getHeight(); ++vPos)
    {
        for (int32_t hPos = 0; hPos < bmp.getWidth(); ++hPos)
        {
            GeneratorBuffer::RgbPixel pix = bmp.getPixel(hPos, vPos);
            EXPECT_EQ(0, pix.red);
            EXPECT_EQ(255, pix.green);
            EXPECT_EQ(0, pix.blue);
        }
    }
}

TEST_F(VideoGeneratorSourceTests, LoadRedBluePatternTestBitmap)
{
    GeneratorBuffer bmp;
    ASSERT_TRUE(bmp.readBitmap("redbluepattern.bmp"));
    
    for (int32_t vPos = 0; vPos < bmp.getHeight(); ++vPos)
    {
        for (int32_t hPos = 0; hPos < bmp.getWidth(); ++hPos)
        {
            GeneratorBuffer::RgbPixel pix = bmp.getPixel(hPos, vPos);
            EXPECT_EQ(((hPos % 0x20) << 3) | ((hPos % 0x20) >> 2), pix.red);
            EXPECT_EQ(0, pix.green);
            EXPECT_EQ(((vPos % 0x20) << 3) | ((vPos % 0x20) >> 2), pix.blue);
        }
    }
}



