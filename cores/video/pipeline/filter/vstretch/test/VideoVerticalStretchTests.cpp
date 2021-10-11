//
// VideoVerticalStretchTests - Unit tests for verilated VideoVerticalStretch module
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
#include "gmock/gmock.h"
#include "VVideoVerticalStretch.h"
#include "BmpPipelineSource.h"
#include "BmpPipelineSink.h"

using namespace ::testing;

class VideoVerticalStretchTests : public Test
{
    public:
        VideoVerticalStretchTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoVerticalStretchTests()
        {
            _uut.final();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VVideoVerticalStretch _uut;
        unsigned int _tickCount;
};

TEST_F(VideoVerticalStretchTests, TestImage50PercentTaller)
{
    _uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("VideoVerticalStretch_TestImage50PercentTaller.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("pexels-pixabay-163822.bmp"));
    
    BmpPipelineSink sink(source.getWidth(), source.getHeight() * 64 / 43, 0.8f);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale ~1.5x (shrink by ~0.666)
    _uut.vShrinkFactor = 43;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1600000; ++i)
    {
        _uut.scalerClock = 0;
        
        sink.setScalerClock(_uut.scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        source.setScalerClock(_uut.scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        
        //_vcdTrace.dump(_tickCount++);
        
        _uut.scalerClock = 1;
        
        sink.setScalerClock(_uut.scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        source.setScalerClock(_uut.scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        
        //_vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("pexels-pixabay-163822_taller50pct.bmp"));
    
    EXPECT_EQ(3295429494U, sink.getCrc32());
    
    //_vcdTrace.close();
}

TEST_F(VideoVerticalStretchTests, TestImage25PercentShorter)
{
    _uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("VideoVerticalStretch_TestImage25PercentShorter.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("pexels-pixabay-163822.bmp"));
    
    BmpPipelineSink sink(source.getWidth(), source.getHeight() * 64 / 85, 0.8f);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale ~0.75x (shrink by ~1.333)
    _uut.vShrinkFactor = 85;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1600000; ++i)
    {
        _uut.scalerClock = 0;
        
        sink.setScalerClock(_uut.scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        source.setScalerClock(_uut.scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        
        //_vcdTrace.dump(_tickCount++);
        
        _uut.scalerClock = 1;
        
        sink.setScalerClock(_uut.scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        source.setScalerClock(_uut.scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        
        //_vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("pexels-pixabay-163822_shorter25pct.bmp"));
    
    EXPECT_EQ(2966265744U, sink.getCrc32());
    
    //_vcdTrace.close();
}
