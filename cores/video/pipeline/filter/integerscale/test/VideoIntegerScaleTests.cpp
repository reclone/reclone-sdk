//
// VideoIntegerScaleTests - Unit tests for verilated VideoIntegerScale module
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
#include "VVideoIntegerScale.h"
#include "BmpPipelineSource.h"
#include "BmpPipelineSink.h"

using namespace ::testing;

class VideoIntegerScaleTests : public Test
{
    public:
        VideoIntegerScaleTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoIntegerScaleTests()
        {
            _uut.final();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VVideoIntegerScale _uut;
        unsigned int _tickCount;
        
        std::queue<uint32_t> _downstreamRequests;
        std::queue<uint16_t> _downstreamResponses;
        std::queue<uint16_t> _upstreamResponses;
        
        MOCK_METHOD(void, requestUpstreamChunk, (uint16_t row, uint16_t chunk), (const));
        MOCK_METHOD(bool, downstreamResponseFifoFull, (), (const));
        
        void executeCycle()
        {
            _uut.scalerClock = 0;
            _uut.eval();
            _vcdTrace.dump(_tickCount++);

            if (_uut.downstreamRequestFifoReadEnable && !_downstreamRequests.empty())
            {
                _uut.downstreamRequestFifoReadData = _downstreamRequests.front();
                _downstreamRequests.pop();
            }
            _uut.downstreamRequestFifoEmpty = _downstreamRequests.empty();
            
            bool responseFifoFull = downstreamResponseFifoFull();
            if (_uut.downstreamResponseFifoWriteEnable && !responseFifoFull)
            {
                _downstreamResponses.push(_uut.downstreamResponseFifoWriteData);
            }
            _uut.downstreamResponseFifoFull = responseFifoFull;
            
            if (_uut.upstreamRequestFifoReadEnable)
            {
                requestUpstreamChunk((_uut.upstreamRequestFifoReadData >> 6) & 0x7FF, _uut.upstreamRequestFifoReadData & 0x3F);
            }
            
            _uut.upstreamRequestFifoReadEnable = !_uut.upstreamRequestFifoEmpty;
            
            if (!_uut.upstreamResponseFifoFull && !_upstreamResponses.empty())
            {
                _uut.upstreamResponseFifoWriteData = _upstreamResponses.front();
                _upstreamResponses.pop();
                _uut.upstreamResponseFifoWriteEnable = 1;
            }
            else
            {
                _uut.upstreamResponseFifoWriteEnable = 0;
            }

            _uut.scalerClock = 1;
            _uut.eval();
            _vcdTrace.dump(_tickCount++);
        }
};

TEST_F(VideoIntegerScaleTests, InitialConditions)
{
    _uut.eval();
    
    ASSERT_EQ(0U, _uut.downstreamRequestFifoReadEnable);
    ASSERT_EQ(0U, _uut.downstreamResponseFifoWriteEnable);
    ASSERT_EQ(0U, _uut.downstreamResponseFifoWriteData);
    ASSERT_EQ(1U, _uut.upstreamRequestFifoEmpty);
    ASSERT_EQ(0U, _uut.upstreamRequestFifoReadData);
    ASSERT_EQ(0U, _uut.upstreamResponseFifoFull);
    
    _uut.reset = 1;
    _uut.eval();
    _uut.reset = 0;
    _uut.eval();
    
    ASSERT_EQ(0U, _uut.downstreamRequestFifoReadEnable);
    ASSERT_EQ(0U, _uut.downstreamResponseFifoWriteEnable);
    ASSERT_EQ(0U, _uut.downstreamResponseFifoWriteData);
    ASSERT_EQ(1U, _uut.upstreamRequestFifoEmpty);
    ASSERT_EQ(0U, _uut.upstreamRequestFifoReadData);
    ASSERT_EQ(0U, _uut.upstreamResponseFifoFull);
}

TEST_F(VideoIntegerScaleTests, OneRequestOneResponse)
{
    
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_OneRequestOneResponse.vcd");

    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 3x horizontally, 2x vertically
    _uut.hScaleFactor = 3;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 0;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;

    _uut.eval();
    _vcdTrace.dump(_tickCount++);
    _vcdTrace.flush();

    // Unlimited downstream response FIFO
    EXPECT_CALL(*this, downstreamResponseFifoFull()).WillRepeatedly(Return(false));

    // Request row 7, chunk 10
    _downstreamRequests.push((7U << 6) | 10U);
    // We should get one upstream request for row 3, chunk 3
    EXPECT_CALL(*this, requestUpstreamChunk(3,3)).WillOnce(InvokeWithoutArgs([&]()
    {
        // Upstream chunk contains 0..31 for pixel color values
        for (uint16_t i = 0; i < 32U; ++i)
        {
            _upstreamResponses.push(i);
        }
    }));
    
    for (unsigned int cycleCount = 0; cycleCount < 100; ++cycleCount)
    {
        executeCycle();
    }
    
    // Verify that responses are:
    // 10 11 11 11 12 12 12 13 13 13 14 14 14 15 15 15
    // 16 16 16 17 17 17 18 18 18 19 19 19 20 20 20 21
    for (unsigned int i = 320U; i < 352U; ++i)
    {
        ASSERT_FALSE(_downstreamResponses.empty());
        ASSERT_EQ((i / 3) - 96U, _downstreamResponses.front());
        _downstreamResponses.pop();
    }
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImage3x)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImage3x.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*3, source.getHeight()*3);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 3x
    _uut.hScaleFactor = 3;
    _uut.vScaleFactor = 3;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 0;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_3x.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImage5x2)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImage5x2.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*5, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 5x horizontally and 2x vertically
    _uut.hScaleFactor = 5;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 0;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_5x2.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImage5x2VScanlines)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImage5x2_VScanlines.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*5, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 5x horizontally and 2x vertically
    _uut.hScaleFactor = 5;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 1;
    _uut.scanlineIntensity = 3;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_5x2_vscanlines.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageVScanlinesDarkest)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageVScanlinesDarkest.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 1;
    _uut.scanlineIntensity = 3;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_VScanlinesDarkest.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageVScanlinesDarker)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageVScanlinesDarker.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 1;
    _uut.scanlineIntensity = 2;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_VScanlinesDarker.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageVScanlinesMedium)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageVScanlinesMedium.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 1;
    _uut.scanlineIntensity = 1;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_VScanlinesMedium.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageVScanlinesLight)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageVScanlinesLight.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 0;
    _uut.vScanlineEnable = 1;
    _uut.scanlineIntensity = 0;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_VScanlinesLight.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageHScanlinesDarkest)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageHScanlinesDarkest.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 1;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 3;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_HScanlinesDarkest.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageHScanlinesDarker)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageHScanlinesDarker.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 1;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 2;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_HScanlinesDarker.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageHScanlinesMedium)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageHScanlinesMedium.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 1;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 1;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_HScanlinesMedium.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageHScanlinesLight)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageHScanlinesLight.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*2, source.getHeight()*2);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 1;
    _uut.vScanlineEnable = 0;
    _uut.scanlineIntensity = 0;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_HScanlinesLight.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoIntegerScaleTests, TestImageBothScanlinesMedium)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoIntegerScale_TestImageBothScanlinesMedium.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_327413.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*3, source.getHeight()*3);
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 2x horizontally and 2x vertically
    _uut.hScaleFactor = 3;
    _uut.vScaleFactor = 3;
    _uut.backgroundColor = 0;
    _uut.hScanlineEnable = 1;
    _uut.vScanlineEnable = 1;
    _uut.scanlineIntensity = 1;
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();

        
        _vcdTrace.dump(_tickCount++);
        
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
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.eval();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_327413_BothScanlinesMedium.bmp"));
    
    _vcdTrace.close();
}

