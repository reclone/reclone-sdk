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

#include <queue>
#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VVideoGeneratorSource.h"
#include "VVideoTimingSink.h"
#include "GeneratorBuffer.h"
#include "ScanlineBuffer.h"

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
            _sink.final();
        }
        
    protected:
        VVideoGeneratorSource _uut;
        VVideoTimingSink _sink;
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

TEST_F(VideoGeneratorSourceTests, ReplicateBitmap)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("VideoGeneratorSource_ReplicateBitmap.vcd");

    GeneratorBuffer sourceBitmap;
    ASSERT_TRUE(sourceBitmap.readBitmap("rainbowswirls.bmp"));
    ScanlineBuffer scanlines(1280, 720, false, false);
    
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
    vcd_trace.dump(_tickCount++);
    
    _sink.pixelClock = 0;
    _sink.scalerClock = 0;
    _sink.reset = 0;
    _sink.hFrontPorch = 110;
    _sink.hSyncPulse = 40;
    _sink.hBackPorch = 220;
    _sink.hActive = 1280;
    _sink.vFrontPorch = 5;
    _sink.vSyncPulse = 5;
    _sink.vBackPorch = 20;
    _sink.vActive = 720;
    _sink.syncIsActiveLow = 0;
    _sink.isInterlaced = 0;
    _sink.requestFifoReadEnable = 0;
    _sink.responseFifoWriteEnable = 0;
    _sink.responseFifoWriteData = 0;
    _sink.eval();
    
    // Burn one cycle because the sink module adds a one cycle delay
    _sink.pixelClock = 1;
    _sink.eval();
    
    _sink.pixelClock = 0;
    _sink.eval();
    
    for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_sink.vFrontPorch + _sink.vSyncPulse + _sink.vBackPorch + _sink.vActive); ++vCount)
    {
        for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_sink.hFrontPorch + _sink.hSyncPulse + _sink.hBackPorch + _sink.hActive); ++hCount)
        {
            // One pixel clock and two scaler clocks
            
            _sink.pixelClock = 1;
            _sink.eval();
            scanlines.processPixel(_sink.dataEnable, _sink.hSync, _sink.vSync, _sink.red, _sink.green, _sink.blue);
            
            _sink.scalerClock = 1;
            _sink.eval();
            _uut.scalerClock = 1;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
            
            _uut.requestFifoEmpty = _sink.requestFifoEmpty;
            _uut.requestFifoReadData = _sink.requestFifoReadData;
            _uut.responseFifoFull = _sink.responseFifoFull;
            GeneratorBuffer::RgbPixel pix;
            pix = sourceBitmap.getPixel(_uut.hPos, _uut.vPos);
            _uut.r = pix.red;
            _uut.g = pix.green;
            _uut.b = pix.blue;
            _uut.dataEnableDelayed = _uut.dataEnable;
            _uut.eval();
            _sink.requestFifoReadEnable = _uut.requestFifoReadEnable;
            _sink.responseFifoWriteEnable = _uut.responseFifoWriteEnable;
            _sink.responseFifoWriteData = _uut.responseFifoWriteData;
            _sink.eval();
            vcd_trace.dump(_tickCount++);
            
            _sink.scalerClock = 0;
            _sink.eval();
            _uut.scalerClock = 0;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
            
            _uut.requestFifoEmpty = _sink.requestFifoEmpty;
            _uut.requestFifoReadData = _sink.requestFifoReadData;
            _uut.responseFifoFull = _sink.responseFifoFull;
            _uut.r = pix.red;
            _uut.g = pix.green;
            _uut.b = pix.blue;
            _uut.dataEnableDelayed = _uut.dataEnable;
            _uut.eval();
            _sink.requestFifoReadEnable = _uut.requestFifoReadEnable;
            _sink.responseFifoWriteEnable = _uut.responseFifoWriteEnable;
            _sink.responseFifoWriteData = _uut.responseFifoWriteData;
            _sink.eval();
            vcd_trace.dump(_tickCount++);
            
            _sink.pixelClock = 0;
            _sink.eval();
            _sink.scalerClock = 1;
            _sink.eval();
            _uut.scalerClock = 1;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
            
            _uut.requestFifoEmpty = _sink.requestFifoEmpty;
            _uut.requestFifoReadData = _sink.requestFifoReadData;
            _uut.responseFifoFull = _sink.responseFifoFull;
            pix = sourceBitmap.getPixel(_uut.hPos, _uut.vPos);
            _uut.r = pix.red;
            _uut.g = pix.green;
            _uut.b = pix.blue;
            _uut.dataEnableDelayed = _uut.dataEnable;
            _uut.eval();
            _sink.requestFifoReadEnable = _uut.requestFifoReadEnable;
            _sink.responseFifoWriteEnable = _uut.responseFifoWriteEnable;
            _sink.responseFifoWriteData = _uut.responseFifoWriteData;
            _sink.eval();
            vcd_trace.dump(_tickCount++);
            
            _sink.scalerClock = 0;
            _sink.eval();
            _uut.scalerClock = 0;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
            
            _uut.requestFifoEmpty = _sink.requestFifoEmpty;
            _uut.requestFifoReadData = _sink.requestFifoReadData;
            _uut.responseFifoFull = _sink.responseFifoFull;
            _uut.r = pix.red;
            _uut.g = pix.green;
            _uut.b = pix.blue;
            _uut.dataEnableDelayed = _uut.dataEnable;
            _uut.eval();
            _sink.requestFifoReadEnable = _uut.requestFifoReadEnable;
            _sink.responseFifoWriteEnable = _uut.responseFifoWriteEnable;
            _sink.responseFifoWriteData = _uut.responseFifoWriteData;
            _sink.eval();
            vcd_trace.dump(_tickCount++);
        }
    }
    
    EXPECT_TRUE(scanlines.writeBitmap("rainbowswirls_ReplicateBitmap.bmp"));

    GeneratorBuffer sinkBitmap;
    ASSERT_TRUE(sinkBitmap.readBitmap("rainbowswirls_ReplicateBitmap.bmp"));
    
    // Verify pixel data is identical (accounting for the 16-bit color truncation)
    for (unsigned int vPos = 0; vPos < _sink.vActive; ++vPos)
    {
        for (unsigned int hPos = 0; hPos < _sink.hActive; ++hPos)
        {
            GeneratorBuffer::RgbPixel sourcePix = sourceBitmap.getPixel(hPos, vPos);
            GeneratorBuffer::RgbPixel sinkPix = sinkBitmap.getPixel(hPos, vPos);
            ASSERT_NEAR(sourcePix.red, sinkPix.red, 15);
            ASSERT_NEAR(sourcePix.green, sinkPix.green, 7);
            ASSERT_NEAR(sourcePix.blue, sinkPix.blue, 15);
        }
    }

    vcd_trace.close();
}


