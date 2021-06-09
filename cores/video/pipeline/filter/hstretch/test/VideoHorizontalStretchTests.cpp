//
// VideoHorizontalStretchTests - Unit tests for verilated VideoHorizontalStretch module
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
#include "VVideoHorizontalStretch.h"
#include "BmpPipelineSource.h"
#include "BmpPipelineSink.h"

using namespace ::testing;

class VideoHorizontalStretchTests : public Test
{
    public:
        VideoHorizontalStretchTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoHorizontalStretchTests()
        {
            _uut.final();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VVideoHorizontalStretch _uut;
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

TEST_F(VideoHorizontalStretchTests, TestImage4by3)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoHorizontalStretch_TestImage4by3.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_330518.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*4/3, source.getHeight());
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 1.3333x (shrink by 0.75)
    _uut.hShrinkFactor = 48;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1500000; ++i)
    {
        _uut.scalerClock = 0;
        
        sink.setScalerClock(_uut.scalerClock);
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
        source.setScalerClock(_uut.scalerClock);
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

        
        _vcdTrace.dump(_tickCount++);
        
        _uut.scalerClock = 1;
        
        sink.setScalerClock(_uut.scalerClock);
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
        source.setScalerClock(_uut.scalerClock);
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
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_330518_4x3.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoHorizontalStretchTests, TestImageHalf)
{
    _uut.trace(&_vcdTrace, 99);
    _vcdTrace.open("VideoHorizontalStretch_TestImageHalf.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("openclipart_330518.bmp"));
    
    BmpPipelineSink sink(source.getWidth()/2, source.getHeight());
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 0.5x (shrink by 1.999)
    _uut.hShrinkFactor = 127;
    _uut.downstreamRequestFifoEmpty = 1;
    _uut.downstreamRequestFifoReadData = 0;
    _uut.downstreamResponseFifoFull = 0;
    _uut.upstreamRequestFifoReadEnable = 0;
    _uut.upstreamResponseFifoWriteEnable = 0;
    _uut.upstreamResponseFifoWriteData = 0;
    _uut.eval();
    
    sink.requestFrame();

    unsigned int responseNum = 0;
    for (unsigned int i = 0; i < 1500000; ++i)
    {
        _uut.scalerClock = 0;
        
        sink.setScalerClock(_uut.scalerClock);
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
        source.setScalerClock(_uut.scalerClock);
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

        
        _vcdTrace.dump(_tickCount++);
        
        _uut.scalerClock = 1;
        
        sink.setScalerClock(_uut.scalerClock);
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
        source.setScalerClock(_uut.scalerClock);
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
        
        _vcdTrace.dump(_tickCount++);
        
        if (_uut.upstreamResponseFifoWriteEnable)
        {
            //printf("Upstream response %u: 0x%04X\n", responseNum, _uut.upstreamResponseFifoWriteData);
            ++responseNum;
        }
    }

    ASSERT_TRUE(sink.writeBitmap("openclipart_330518_half.bmp"));
    
    _vcdTrace.close();
}

TEST_F(VideoHorizontalStretchTests, TestPhotoUpscale)
{
    //_uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("VideoHorizontalStretch_TestPhotoUpscale.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("tetiana-bykovets-z-kkcidqW_U-unsplash.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*64/39, source.getHeight());
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 1.64x (shrink by 39/64)
    _uut.hShrinkFactor = 39;
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
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(_uut.scalerClock);
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
        
        _uut.scalerClock = 1;
        
        sink.setScalerClock(_uut.scalerClock);
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
        source.setScalerClock(_uut.scalerClock);
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

    ASSERT_TRUE(sink.writeBitmap("tetiana-bykovets-z-kkcidqW_U-unsplash_upscale.bmp"));
    
    //_vcdTrace.close();
}

TEST_F(VideoHorizontalStretchTests, TestPhotoDownscale)
{
    //_uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("VideoHorizontalStretch_TestPhotoDownscale.vcd");
    
    BmpPipelineSource source;
    ASSERT_TRUE(source.readBitmap("tetiana-bykovets-z-kkcidqW_U-unsplash.bmp"));
    
    BmpPipelineSink sink(source.getWidth()*64/103, source.getHeight());
    
    // Initialize inputs
    _uut.scalerClock = 0;
    _uut.reset = 0;
    // Scale 0.62x (shrink by 103/64)
    _uut.hShrinkFactor = 103;
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
        _uut.downstreamRequestFifoEmpty = sink.getRequestFifoEmpty();
        _uut.downstreamRequestFifoReadData = sink.getRequestFifoReadData();
        _uut.downstreamResponseFifoFull = sink.getResponseFifoFull();
        _uut.upstreamRequestFifoReadEnable = source.getRequestFifoReadEnable();
        _uut.upstreamResponseFifoWriteEnable = source.getResponseFifoWriteEnable();
        _uut.upstreamResponseFifoWriteData = source.getResponseFifoWriteData();
        _uut.eval();
        source.setScalerClock(_uut.scalerClock);
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
        
        _uut.scalerClock = 1;
        
        sink.setScalerClock(_uut.scalerClock);
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
        source.setScalerClock(_uut.scalerClock);
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

    ASSERT_TRUE(sink.writeBitmap("tetiana-bykovets-z-kkcidqW_U-unsplash_downscale.bmp"));
    
    //_vcdTrace.close();
}
