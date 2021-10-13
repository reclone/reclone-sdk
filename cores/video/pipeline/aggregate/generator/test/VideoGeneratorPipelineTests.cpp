//
// VideoGeneratorPipelineTests - Unit tests for verilated VideoGeneratorPipeline module
//
//
// Copyright 2021 Reclone Labs <reclonelabs.com>
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
#include "VVideoGeneratorPipeline.h"
#include "GeneratorBuffer.h"
#include "ScanlineBuffer.h"

class VideoGeneratorPipelineTests : public ::testing::Test
{
    public:
        VideoGeneratorPipelineTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoGeneratorPipelineTests()
        {
            _uut.final();
        }
        
    protected:
        VVideoGeneratorPipeline _uut;
        unsigned int _tickCount;
        
        static void applyColorPattern(VVideoGeneratorPipeline & gen);
};


void VideoGeneratorPipelineTests::applyColorPattern(VVideoGeneratorPipeline & gen)
{
    unsigned int coordSum = gen.generatorHPos + gen.generatorVPos;
    
    if (gen.generatorDataEnable)
    {
        gen.generatorR = (coordSum & 0x04) ? 0xFF : 0;
        gen.generatorG = (coordSum & 0x08) ? 0xFF : 0;
        gen.generatorB = (coordSum & 0x10) ? 0xFF : 0;
        gen.generatorDataEnableDelayed = 1;
    }
    else
    {
        gen.generatorR = 0;
        gen.generatorG = 0;
        gen.generatorB = 0;
        gen.generatorDataEnableDelayed = 0;
    }
}

TEST_F(VideoGeneratorPipelineTests, ColorPattern720p)
{
    const bool enableTrace = false;
    const unsigned int testCycles = 1300000;
    ScanlineBuffer scanlines(1280, 720, false, false);
    
    VerilatedVcdC vcd_trace;
    if (enableTrace)
    {
        _uut.trace(&vcd_trace, 99);
        vcd_trace.open("VideoGeneratorPipelineTests_ColorPattern720p.vcd");
    }

    _uut.scalerClock = 0;
    _uut.pixelClock = 0;
    _uut.reset = 0;
    _uut.cropRows = 0;
    _uut.cropChunks = 0;
    _uut.padTopRows = 0;
    _uut.padLeftColumns = 0;
    _uut.sourceRows = 720;
    _uut.sourceColumns = 1280;
    _uut.padColor = 0;
    _uut.enableBinning = 0;
    _uut.hScaleFactor = 0;
    _uut.vScaleFactor = 0;
    _uut.hShrinkFactor = 64;
    _uut.vShrinkFactor = 64;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 0;
    _uut.hFrontPorch = 110;
    _uut.hSyncPulse = 40;
    _uut.hBackPorch = 220;
    _uut.hActive = 1280;
    _uut.vFrontPorch = 5;
    _uut.vSyncPulse = 5;
    _uut.vBackPorch = 20;
    _uut.vActive = 720;
    _uut.isInterlaced = 0;
    _uut.generatorR = 0;
    _uut.generatorG = 0;
    _uut.generatorB = 0;
    _uut.generatorDataEnableDelayed = 0;
    _uut.eval();
    if (enableTrace) vcd_trace.dump(_tickCount++);

    
    for (unsigned int cycle = 0; cycle < testCycles; ++cycle)
    {
        SCOPED_TRACE(cycle);
        
        _uut.scalerClock = 1;
        _uut.pixelClock = 1;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
        applyColorPattern(_uut);
        scanlines.processPixel(_uut.dataEnable, _uut.hSync, _uut.vSync, _uut.red, _uut.green, _uut.blue);

        _uut.scalerClock = 0;
        _uut.pixelClock = 1;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);

        _uut.scalerClock = 1;
        _uut.pixelClock = 0;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
        applyColorPattern(_uut);

        _uut.scalerClock = 0;
        _uut.pixelClock = 0;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
    }
    
    ASSERT_TRUE(scanlines.writeBitmap("VideoGeneratorPipelineTests_ColorPattern720p.bmp"));
    
    EXPECT_EQ(561443426U, scanlines.getCrc32());

    if (enableTrace) vcd_trace.close();
    
    GeneratorBuffer sinkBitmap;
    ASSERT_TRUE(sinkBitmap.readBitmap("VideoGeneratorPipelineTests_ColorPattern720p.bmp"));
    
    // Verify pixel data matches pattern (accounting for the 16-bit color truncation)
    for (unsigned int vPos = 0; vPos < _uut.vActive; ++vPos)
    {
        SCOPED_TRACE(vPos);
        
        for (unsigned int hPos = 0; hPos < _uut.hActive; ++hPos)
        {
            SCOPED_TRACE(hPos);
            
            _uut.generatorHPos = hPos;
            _uut.generatorVPos = vPos;
            _uut.generatorDataEnable = 1;
            applyColorPattern(_uut);
            
            GeneratorBuffer::RgbPixel sinkPix = sinkBitmap.getPixel(hPos, vPos);
            ASSERT_NEAR(_uut.generatorR, sinkPix.red, 15);
            ASSERT_NEAR(_uut.generatorG, sinkPix.green, 7);
            ASSERT_NEAR(_uut.generatorB, sinkPix.blue, 15);
        }
    }

}

TEST_F(VideoGeneratorPipelineTests, ColorPattern720pUpscaleScanlines)
{
    const bool enableTrace = false;
    const unsigned int testCycles = 1300000;
    ScanlineBuffer scanlines(1280, 720, false, false);
    
    VerilatedVcdC vcd_trace;
    if (enableTrace)
    {
        _uut.trace(&vcd_trace, 99);
        vcd_trace.open("VideoGeneratorPipelineTests_ColorPattern720pUpscaleScanlines.vcd");
    }

    _uut.scalerClock = 0;
    _uut.pixelClock = 0;
    _uut.reset = 0;
    _uut.cropRows = 0;
    _uut.cropChunks = 0;
    _uut.padTopRows = 0;
    _uut.padLeftColumns = 0;
    _uut.sourceRows = 720;
    _uut.sourceColumns = 1280;
    _uut.padColor = 0;
    _uut.enableBinning = 0;
    _uut.hScaleFactor = 5;
    _uut.vScaleFactor = 3;
    _uut.hShrinkFactor = 31;
    _uut.vShrinkFactor = 43;
    //_uut.hShrinkFactor = 64;
    //_uut.vShrinkFactor = 64;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 1;
    //_uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 2;
    _uut.hFrontPorch = 110;
    _uut.hSyncPulse = 40;
    _uut.hBackPorch = 220;
    _uut.hActive = 1280;
    _uut.vFrontPorch = 5;
    _uut.vSyncPulse = 5;
    _uut.vBackPorch = 20;
    _uut.vActive = 720;
    _uut.isInterlaced = 0;
    _uut.generatorR = 0;
    _uut.generatorG = 0;
    _uut.generatorB = 0;
    _uut.generatorDataEnableDelayed = 0;
    _uut.eval();
    if (enableTrace) vcd_trace.dump(_tickCount++);

    
    for (unsigned int cycle = 0; cycle < testCycles; ++cycle)
    {
        SCOPED_TRACE(cycle);
        
        _uut.scalerClock = 1;
        _uut.pixelClock = 1;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
        applyColorPattern(_uut);
        scanlines.processPixel(_uut.dataEnable, _uut.hSync, _uut.vSync, _uut.red, _uut.green, _uut.blue);

        _uut.scalerClock = 0;
        _uut.pixelClock = 1;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);

        _uut.scalerClock = 1;
        _uut.pixelClock = 0;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
        applyColorPattern(_uut);

        _uut.scalerClock = 0;
        _uut.pixelClock = 0;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
    }
    
    ASSERT_TRUE(scanlines.writeBitmap("VideoGeneratorPipelineTests_ColorPattern720pUpscaleScanlines.bmp"));

    if (enableTrace) vcd_trace.close();
    
    EXPECT_EQ(866791038U, scanlines.getCrc32());
}

/* This binning test fails because scaler clock is <4x the pixel clock.
TEST_F(VideoGeneratorPipelineTests, ColorPattern720pBinning)
{
    const bool enableTrace = true;
    const unsigned int testCycles = 1000000;
    ScanlineBuffer scanlines(1280, 720, false, false);
    
    VerilatedVcdC vcd_trace;
    if (enableTrace)
    {
        _uut.trace(&vcd_trace, 99);
        vcd_trace.open("VideoGeneratorPipelineTests_ColorPattern720pBinning.vcd");
    }

    _uut.scalerClock = 0;
    _uut.pixelClock = 0;
    _uut.reset = 0;
    _uut.cropRows = 0;
    _uut.cropChunks = 0;
    _uut.padTopRows = 0;
    _uut.padLeftColumns = 0;
    _uut.sourceRows = 720;
    _uut.sourceColumns = 1280;
    _uut.padColor = 0;
    _uut.enableBinning = 1;
    _uut.hScaleFactor = 1;
    _uut.vScaleFactor = 1;
    //_uut.hShrinkFactor = 31;
    //_uut.vShrinkFactor = 43;
    _uut.hShrinkFactor = 64;
    _uut.vShrinkFactor = 64;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    //_uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 2;
    _uut.hFrontPorch = 110;
    _uut.hSyncPulse = 40;
    _uut.hBackPorch = 220;
    _uut.hActive = 1280;
    _uut.vFrontPorch = 5;
    _uut.vSyncPulse = 5;
    _uut.vBackPorch = 20;
    _uut.vActive = 720;
    _uut.isInterlaced = 0;
    _uut.generatorR = 0;
    _uut.generatorG = 0;
    _uut.generatorB = 0;
    _uut.generatorDataEnableDelayed = 0;
    _uut.eval();
    if (enableTrace) vcd_trace.dump(_tickCount++);

    
    for (unsigned int cycle = 0; cycle < testCycles; ++cycle)
    {
        SCOPED_TRACE(cycle);
        
        _uut.scalerClock = 1;
        _uut.pixelClock = 1;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
        applyColorPattern(_uut);
        scanlines.processPixel(_uut.dataEnable, _uut.hSync, _uut.vSync, _uut.red, _uut.green, _uut.blue);

        _uut.scalerClock = 0;
        _uut.pixelClock = 1;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);

        _uut.scalerClock = 1;
        _uut.pixelClock = 0;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
        applyColorPattern(_uut);

        _uut.scalerClock = 0;
        _uut.pixelClock = 0;
        _uut.eval();
        if (enableTrace) vcd_trace.dump(_tickCount++);
    }
    
    ASSERT_TRUE(scanlines.writeBitmap("VideoGeneratorPipelineTests_ColorPattern720pBinning.bmp"));

    if (enableTrace) vcd_trace.close();
    
    EXPECT_EQ(0U, scanlines.getCrc32());
} */

