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

TEST_F(VideoGeneratorSourceTests, InitialConditions)
{
    _uut.scalerClock = 0;
    _uut.reset = 0;
    _uut.requestFifoEmpty = 1;
    _uut.requestFifoReadData = 0;
    _uut.responseFifoFull = 0;
    _uut.r = 0;
    _uut.g = 0;
    _uut.b = 0;
    _uut.dataEnableDelayed = 0;
    _uut.eval();
    
    for (unsigned int i = 0; i < 10; ++i)
    {
        _uut.scalerClock = 1;
        _uut.eval();
        _uut.scalerClock = 0;
        _uut.eval();
        
        ASSERT_EQ(0, _uut.requestFifoReadEnable);
        ASSERT_EQ(0, _uut.responseFifoWriteEnable);
        ASSERT_EQ(0, _uut.responseFifoWriteData);
        ASSERT_EQ(0, _uut.hPos);
        ASSERT_EQ(0, _uut.vPos);
        ASSERT_EQ(0, _uut.dataEnable);
    }
}

TEST_F(VideoGeneratorSourceTests, RequestOneChunk)
{
    _uut.scalerClock = 0;
    _uut.reset = 0;
    _uut.requestFifoEmpty = 1;
    _uut.requestFifoReadData = 0;
    _uut.responseFifoFull = 0;
    _uut.r = 0;
    _uut.g = 0;
    _uut.b = 0;
    _uut.dataEnableDelayed = 0;
    _uut.eval();
    
    _uut.scalerClock = 1;
    _uut.eval();
    _uut.scalerClock = 0;
    _uut.eval();
    
    ASSERT_EQ(0, _uut.requestFifoReadEnable);
    ASSERT_EQ(0, _uut.responseFifoWriteEnable);
    ASSERT_EQ(0, _uut.responseFifoWriteData);
    ASSERT_EQ(0, _uut.hPos);
    ASSERT_EQ(0, _uut.vPos);
    ASSERT_EQ(0, _uut.dataEnable);
    
    // Indicate there is a pending request
    _uut.requestFifoEmpty = 0;
    _uut.scalerClock = 1;
    _uut.eval();
    _uut.scalerClock = 0;
    _uut.eval();
    ASSERT_EQ(1, _uut.requestFifoReadEnable);
    ASSERT_EQ(0, _uut.responseFifoWriteEnable);
    ASSERT_EQ(0, _uut.responseFifoWriteData);
    ASSERT_EQ(0, _uut.hPos);
    ASSERT_EQ(0, _uut.vPos);
    ASSERT_EQ(0, _uut.dataEnable);
    
    // Say the request is for row 1, chunk number 2
    // Chunks are 32 pixels wide, so chunk 2 starts at hPos of 64
    _uut.requestFifoReadData = (1 << 6) | 2;
    _uut.requestFifoEmpty = 1;
    _uut.scalerClock = 1;
    _uut.eval();
    _uut.scalerClock = 0;
    _uut.eval();
    ASSERT_EQ(0, _uut.requestFifoReadEnable);
    ASSERT_EQ(0, _uut.responseFifoWriteEnable);
    ASSERT_EQ(0, _uut.responseFifoWriteData);
    ASSERT_EQ(2*32, _uut.hPos);
    ASSERT_EQ(1, _uut.vPos);
    ASSERT_EQ(1, _uut.dataEnable);
    _uut.r = 0;
    _uut.g = 255;
    _uut.b = 255;
    
    
    for (unsigned int i = 1; i < 32; ++i)
    {
        _uut.dataEnableDelayed = 1;
        _uut.scalerClock = 1;
        _uut.eval();
        _uut.scalerClock = 0;
        _uut.eval();
        ASSERT_EQ(0, _uut.requestFifoReadEnable);
        ASSERT_EQ(1, _uut.responseFifoWriteEnable);
        ASSERT_EQ(0x07FF, _uut.responseFifoWriteData);
        ASSERT_EQ(2*32+i, _uut.hPos);
        ASSERT_EQ(1, _uut.vPos);
        ASSERT_EQ(1, _uut.dataEnable);
    }

    _uut.dataEnableDelayed = 1;
    _uut.scalerClock = 1;
    _uut.eval();
    _uut.scalerClock = 0;
    _uut.eval();
    ASSERT_EQ(0, _uut.requestFifoReadEnable);
    ASSERT_EQ(1, _uut.responseFifoWriteEnable);
    ASSERT_EQ(0x07FF, _uut.responseFifoWriteData);
    ASSERT_EQ(0, _uut.hPos);
    ASSERT_EQ(0, _uut.vPos);
    ASSERT_EQ(0, _uut.dataEnable);
    _uut.r = 0;
    _uut.g = 0;
    _uut.b = 0;
    _uut.dataEnableDelayed = 0;
    
    // No more requests, so no more activity
    for (unsigned int i = 0; i < 100; ++i)
    {
        _uut.scalerClock = 1;
        _uut.eval();
        _uut.scalerClock = 0;
        _uut.eval();
        
        ASSERT_EQ(0, _uut.requestFifoReadEnable);
        ASSERT_EQ(0, _uut.responseFifoWriteEnable);
        ASSERT_EQ(0, _uut.responseFifoWriteData);
        ASSERT_EQ(0, _uut.hPos);
        ASSERT_EQ(0, _uut.vPos);
        ASSERT_EQ(0, _uut.dataEnable);
    }

}

