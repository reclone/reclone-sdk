//
// VideoCroppingFilterTests - Unit tests for verilated VideoCroppingFilter module
//
//
// Copyright 2019 - 2021 Reclone Labs <reclonelabs.com>
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
#include "VVideoCroppingFilter.h"
#include "BmpPipelineSource.h"
#include "BmpPipelineSink.h"

using namespace ::testing;

class VideoCroppingFilterTests : public Test
{
    public:
        VideoCroppingFilterTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoCroppingFilterTests()
        {
            _uut.final();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VVideoCroppingFilter _uut;
        unsigned int _tickCount;
};

TEST_F(VideoCroppingFilterTests, TestImageNoCrop)
{
    _uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("VideoCroppingFilter_TestImageNoCrop.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327550.bmp"));
    
    BmpPipelineSink sink(source.getWidth(), source.getHeight());
    
    // Initialize inputs
    unsigned int scalerClock = 0;
    // Crop nothing
    _uut.cropRows = 0;
    _uut.cropChunks = 0;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        scalerClock = 0;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();

        
        //_vcdTrace.dump(_tickCount++);
        
        scalerClock = 1;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        
        //_vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327550_noCrop.bmp"));
    
    //_vcdTrace.close();
    
    EXPECT_EQ(2109623126U, sink.getCrc32());
}

TEST_F(VideoCroppingFilterTests, TestImageCropTop)
{
    //_uut.trace(&_vcdTrace, 99);
   // _vcdTrace.open("VideoCroppingFilter_TestImageCropTop.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327550.bmp"));
    
    BmpPipelineSink sink(source.getWidth(), source.getHeight()-8);
    
    // Initialize inputs
    unsigned int scalerClock = 0;
    // Crop 8 rows
    _uut.cropRows = 8;
    _uut.cropChunks = 0;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        scalerClock = 0;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();

        
        //_vcdTrace.dump(_tickCount++);
        
        scalerClock = 1;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        
        //_vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327550_cropTop.bmp"));
    
    //_vcdTrace.close();
    
    EXPECT_EQ(376826640U, sink.getCrc32());
}

TEST_F(VideoCroppingFilterTests, TestImageCropLeft)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoCroppingFilter_TestImageCropLeft.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327550.bmp"));
    
    BmpPipelineSink sink(source.getWidth()-96, source.getHeight());
    
    // Initialize inputs
    unsigned int scalerClock = 0;
    // Crop 3 chunks (96 pixels)
    _uut.cropRows = 0;
    _uut.cropChunks = 3;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        scalerClock = 0;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();

        
        //_vcdTrace.dump(_tickCount++);
        
        scalerClock = 1;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        
        //_vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327550_cropLeft.bmp"));
    
    //_vcdTrace.close();
    
    EXPECT_EQ(3545964577U, sink.getCrc32());
}

TEST_F(VideoCroppingFilterTests, TestImageCropAllSides)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoCroppingFilter_TestImageCropAllSides.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327550.bmp"));
    
    BmpPipelineSink sink(source.getWidth()-192, source.getHeight()-16);
    
    // Initialize inputs
    unsigned int scalerClock = 0;
    // Crop 3 chunks (96 pixels) and 8 rows
    _uut.cropRows = 8;
    _uut.cropChunks = 3;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1000000; ++i)
    {
        scalerClock = 0;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();

        
        //_vcdTrace.dump(_tickCount++);
        
        scalerClock = 1;
        
        sink.setScalerClock(scalerClock);
        sink.setRequestFifoReadEnable(_uut.downstreamRequestFifoReadEnable);
        sink.setResponseFifoWriteEnable(_uut.downstreamResponseFifoWriteEnable);
        sink.setResponseFifoWriteData(_uut.downstreamResponseFifoWriteData);
        sink.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(scalerClock);
        source.setRequestFifoEmpty(_uut.upstreamRequestFifoEmpty);
        source.setRequestFifoReadData(_uut.upstreamRequestFifoReadData);
        source.setResponseFifoFull(_uut.upstreamResponseFifoFull);
        source.eval();
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        
        //_vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327550_cropAllSides.bmp"));
    
    //_vcdTrace.close();
    
    EXPECT_EQ(1879602040U, sink.getCrc32());
}

