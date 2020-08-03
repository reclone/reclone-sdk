//
// VideoTimingSinkTests - Unit tests for verilated VideoTimingSink module
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

#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VVideoTimingSink.h"
#include "ScanlineBuffer.h"

class VideoTimingSinkTests : public ::testing::Test
{
    public:
        VideoTimingSinkTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoTimingSinkTests()
        {
            _uut.final();
        }
        
    protected:
        VVideoTimingSink _uut;
        unsigned int _tickCount;
        
        enum class RequestHandlingState : int
        {
            IDLE,
            READ_REQUEST,
            FULFILL_REQUEST
        };

};

TEST_F(VideoTimingSinkTests, Hd720p60GreenScreen)
{
    VerilatedVcdC vcd_trace;
    RequestHandlingState reqState = RequestHandlingState::IDLE;
    unsigned int reqCount = 0;
    ScanlineBuffer scanlines(1280, 720, false);
    
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("Hd720p60GreenScreen.vcd");
    _uut.pixelClock = 0;
    _uut.scalerClock = 0;
    _uut.reset = 0;
    _uut.hFrontPorch = 110;
    _uut.hSyncPulse = 40;
    _uut.hBackPorch = 220;
    _uut.hActive = 1280;
    _uut.vFrontPorch = 5;
    _uut.vSyncPulse = 5;
    _uut.vBackPorch = 20;
    _uut.vActive = 720;
    _uut.syncIsActiveLow = 0;
    _uut.isInterlaced = 0;
    _uut.requestFifoReadEnable = 0;
    _uut.responseFifoWriteEnable = 0;
    _uut.responseFifoWriteData = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    vcd_trace.flush();
    
    // Burn one cycle because the sink module adds a one cycle delay
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive); ++vCount)
    {
        for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
        {
            if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
            {
                ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
            }
            else
            {
                ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
            }
            
            if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
            {
                ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
            }
            else
            {
                ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
            }
            
            if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
            {
                if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                {
                    ASSERT_EQ(1, _uut.dataEnable);
                    EXPECT_EQ(0, _uut.red);
                    EXPECT_EQ(255, _uut.green) << hCount;
                    EXPECT_EQ(0, _uut.blue);
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.red);
                    ASSERT_EQ(0, _uut.green);
                    ASSERT_EQ(0, _uut.blue);
                }
            }
            else
            {
                ASSERT_EQ(0, _uut.dataEnable);
            }
            
            scanlines.processPixel(_uut.dataEnable, _uut.hSync, _uut.vSync, _uut.red, _uut.green, _uut.blue);
            
            for (unsigned int i = 0; i < 2; ++i)
            {
                // Handle video pipeline requests
                switch (reqState)
                {
                    case RequestHandlingState::READ_REQUEST:
                        _uut.requestFifoReadEnable = 0;
                        reqCount = 0;
                        reqState = RequestHandlingState::FULFILL_REQUEST;
                        break;

                    case RequestHandlingState::FULFILL_REQUEST:
                        if (reqCount < 32)
                        {
                            if (_uut.responseFifoFull)
                            {
                                _uut.responseFifoWriteEnable = 0;
                                _uut.responseFifoWriteData = 0;
                            }
                            else
                            {
                                _uut.responseFifoWriteEnable = 1;
                                _uut.responseFifoWriteData = 0x07E0;
                                ++reqCount;
                            }
                        }
                        else
                        {
                            _uut.responseFifoWriteEnable = 0;
                            _uut.responseFifoWriteData = 0;
                            reqState = RequestHandlingState::IDLE;
                        }
                        break;

                    case RequestHandlingState::IDLE:
                    default:
                        if (!_uut.requestFifoEmpty)
                        {
                            _uut.requestFifoReadEnable = 1;
                            reqState = RequestHandlingState::READ_REQUEST;
                        }
                        break;
                }
                _uut.eval();
                
                // For this test, scaler clock is twice as fast as the pixel clock
                _uut.pixelClock = !_uut.pixelClock;
                _uut.scalerClock = 1;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                _uut.scalerClock = 0;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
            }
            
            //vcd_trace.flush();
        }
        vcd_trace.flush();
    }
    
    EXPECT_TRUE(scanlines.writeBitmap("Hd720p60GreenScreen.bmp"));
    
    vcd_trace.close();
}

TEST_F(VideoTimingSinkTests, Hd720p60RedBluePattern)
{
    VerilatedVcdC vcd_trace;
    RequestHandlingState reqState = RequestHandlingState::IDLE;
    unsigned int requestedRow = 0;
    unsigned int requestedChunk = 0;
    unsigned int reqCount = 0;
    ScanlineBuffer scanlines(1280, 720, false);
    
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("Hd720p60RedBluePattern.vcd");
    _uut.pixelClock = 0;
    _uut.scalerClock = 0;
    _uut.reset = 0;
    _uut.hFrontPorch = 110;
    _uut.hSyncPulse = 40;
    _uut.hBackPorch = 220;
    _uut.hActive = 1280;
    _uut.vFrontPorch = 5;
    _uut.vSyncPulse = 5;
    _uut.vBackPorch = 20;
    _uut.vActive = 720;
    _uut.syncIsActiveLow = 0;
    _uut.isInterlaced = 0;
    _uut.requestFifoReadEnable = 0;
    _uut.responseFifoWriteEnable = 0;
    _uut.responseFifoWriteData = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    vcd_trace.flush();
    
    // Burn one cycle because the sink module adds a one cycle delay
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive); ++vCount)
    {
        for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
        {
            if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
            {
                ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
            }
            else
            {
                ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
            }
            
            if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
            {
                ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
            }
            else
            {
                ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
            }
            
            if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
            {
                if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                {
                    ASSERT_EQ(1, _uut.dataEnable);
                    uint8_t red = (hCount - static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch)) % 32U;
                    uint8_t blue = (vCount - static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch)) % 32U;
                    EXPECT_EQ((red << 3) | (red >> 2), _uut.red);
                    EXPECT_EQ(0, _uut.green);
                    EXPECT_EQ((blue << 3) | (blue >> 2), _uut.blue);
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.red);
                    ASSERT_EQ(0, _uut.green);
                    ASSERT_EQ(0, _uut.blue);
                }
            }
            else
            {
                ASSERT_EQ(0, _uut.dataEnable);
            }
            
            scanlines.processPixel(_uut.dataEnable, _uut.hSync, _uut.vSync, _uut.red, _uut.green, _uut.blue);
            
            for (unsigned int i = 0; i < 2; ++i)
            {
                // Handle video pipeline requests
                switch (reqState)
                {
                    case RequestHandlingState::READ_REQUEST:
                        _uut.requestFifoReadEnable = 0;
                        requestedRow = _uut.requestFifoReadData >> 6;
                        requestedChunk = _uut.requestFifoReadData & 0x3F;
                        reqCount = 0;
                        reqState = RequestHandlingState::FULFILL_REQUEST;
                        break;

                    case RequestHandlingState::FULFILL_REQUEST:
                        if (reqCount < 32)
                        {
                            if (_uut.responseFifoFull)
                            {
                                _uut.responseFifoWriteEnable = 0;
                                _uut.responseFifoWriteData = 0;
                            }
                            else
                            {
                                _uut.responseFifoWriteEnable = 1;
                                unsigned int red = ((requestedChunk << 5) + reqCount) % 0x20;
                                unsigned int blue = requestedRow % 0x20;
                                _uut.responseFifoWriteData = (red << 11)| blue;
                                ++reqCount;
                            }
                        }
                        else
                        {
                            _uut.responseFifoWriteEnable = 0;
                            _uut.responseFifoWriteData = 0;
                            reqState = RequestHandlingState::IDLE;
                        }
                        break;

                    case RequestHandlingState::IDLE:
                    default:
                        if (!_uut.requestFifoEmpty)
                        {
                            _uut.requestFifoReadEnable = 1;
                            reqState = RequestHandlingState::READ_REQUEST;
                        }
                        break;
                }
                _uut.eval();
                
                // For this test, scaler clock is twice as fast as the pixel clock
                _uut.pixelClock = !_uut.pixelClock;
                _uut.scalerClock = 1;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                _uut.scalerClock = 0;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
            }
            
            //vcd_trace.flush();
        }
        vcd_trace.flush();
    }
    
    EXPECT_TRUE(scanlines.writeBitmap("Hd720p60RedBluePattern.bmp"));
    
    vcd_trace.close();
}

/*
TEST_F(VideoTimingSinkTests, Hd720p60)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("Hd720p60.vcd");
    
    _uut.clock = 0;
    _uut.reset = 0;
    _uut.hFrontPorch = 110;
    _uut.hSyncPulse = 40;
    _uut.hBackPorch = 220;
    _uut.hActive = 1280;
    _uut.vFrontPorch = 5;
    _uut.vSyncPulse = 5;
    _uut.vBackPorch = 20;
    _uut.vActive = 720;
    _uut.syncIsActiveLow = 0;
    _uut.isInterlaced = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    vcd_trace.flush();
    
    for (unsigned int frameCount = 0; frameCount < 2; ++frameCount)
    {
        for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive); ++vCount)
        {
            ASSERT_EQ(vCount, _uut.VideoTimingSink__DOT__vCount);

            if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
            {
                ASSERT_EQ(vCount - _uut.vFrontPorch - _uut.vSyncPulse - _uut.vBackPorch, _uut.vPos);
            }
            else
            {
                ASSERT_EQ(0, _uut.vPos);
            }

            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
            {
                //std::cout << vCount << " " << hCount << std::endl;
                ASSERT_EQ(hCount, _uut.VideoTimingSink__DOT__hCount);
                
                if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
                }
                
                if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                    (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
                }
                
                if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
                {
                    ASSERT_EQ(hCount - _uut.hFrontPorch - _uut.hSyncPulse - _uut.hBackPorch, _uut.hPos);

                    if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                    {
                        ASSERT_EQ(1, _uut.dataEnable);
                    }
                    else
                    {
                        ASSERT_EQ(0, _uut.dataEnable);
                    }
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.hPos);
                }
                
                _uut.clock = 1;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                _uut.clock = 0;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                //vcd_trace.flush();
            }
            vcd_trace.flush();
        }
    }
    
    vcd_trace.close();
}

TEST_F(VideoTimingSinkTests, Hd1080i60)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("Hd1080i60.vcd");
    
    _uut.clock = 0;
    _uut.reset = 0;
    _uut.hFrontPorch = 88;
    _uut.hSyncPulse = 44;
    _uut.hBackPorch = 148;
    _uut.hActive = 1920;
    _uut.vFrontPorch = 4;
    _uut.vSyncPulse = 10;
    _uut.vBackPorch = 30;
    _uut.vActive = 1080;
    _uut.syncIsActiveLow = 0;
    _uut.isInterlaced = 1;
    _uut.eval();
    
    vcd_trace.dump(_tickCount++);
    vcd_trace.flush();
    
    unsigned int hHalfLine = (_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive)/2U;
    
    for (unsigned int frameCount = 0; frameCount < 2; ++frameCount)
    {
        // even field
        for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive); vCount += 2)
        {
            ASSERT_EQ(vCount, _uut.VideoTimingSink__DOT__vCount);

            if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
            {
                ASSERT_EQ(vCount - _uut.vFrontPorch - _uut.vSyncPulse - _uut.vBackPorch, _uut.vPos);
            }
            else
            {
                ASSERT_EQ(0, _uut.vPos);
            }

            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
            {
                //std::cout << vCount << " " << hCount << std::endl;
                ASSERT_EQ(hCount, _uut.VideoTimingSink__DOT__hCount);
                
                if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
                }
                
                if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                    (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
                }
                
                if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
                {
                    ASSERT_EQ(hCount - _uut.hFrontPorch - _uut.hSyncPulse - _uut.hBackPorch, _uut.hPos);

                    if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                    {
                        ASSERT_EQ(1, _uut.dataEnable);
                    }
                    else
                    {
                        ASSERT_EQ(0, _uut.dataEnable);
                    }
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.hPos);
                }
                
                _uut.clock = 1;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                _uut.clock = 0;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                //vcd_trace.flush();
            }
            vcd_trace.flush();
        }
        
        // odd field (one more line than in even field)
        for (unsigned int vCount = 1; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive + 2U); vCount += 2U)
        {
            //std::cout << vCount << std::endl;
            ASSERT_EQ(vCount, _uut.VideoTimingSink__DOT__vCount);

            if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + 2))
            {
                ASSERT_EQ(vCount - _uut.vFrontPorch - _uut.vSyncPulse - _uut.vBackPorch - 2, _uut.vPos);
            }
            else
            {
                ASSERT_EQ(0, _uut.vPos);
            }

            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
            {
                //std::cout << vCount << " " << hCount << std::endl;
                ASSERT_EQ(hCount, _uut.VideoTimingSink__DOT__hCount);
                
                if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
                }
                
                if ((vCount > _uut.vFrontPorch + 1U || (vCount == _uut.vFrontPorch + 1U && hCount >= _uut.hFrontPorch + hHalfLine)) && 
                    (vCount < (_uut.vFrontPorch + _uut.vSyncPulse + 1U) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse + 1U) && hCount < _uut.hFrontPorch + hHalfLine)))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
                }
                
                if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
                {
                    ASSERT_EQ(hCount - _uut.hFrontPorch - _uut.hSyncPulse - _uut.hBackPorch, _uut.hPos);

                    if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + 2U))
                    {
                        ASSERT_EQ(1, _uut.dataEnable);
                    }
                    else
                    {
                        ASSERT_EQ(0, _uut.dataEnable);
                    }
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.hPos);
                }
                
                _uut.clock = 1;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                _uut.clock = 0;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                //vcd_trace.flush();
            }
            vcd_trace.flush();
        }
    }
    
    vcd_trace.close();
}


TEST_F(VideoTimingSinkTests, Vga640x480at60Hz)
{
    _uut.clock = 0;
    _uut.reset = 1;
    _uut.hFrontPorch = 16;
    _uut.hSyncPulse = 96;
    _uut.hBackPorch = 48;
    _uut.hActive = 640;
    _uut.vFrontPorch = 11;
    _uut.vSyncPulse = 2;
    _uut.vBackPorch = 31;
    _uut.vActive = 480;
    _uut.syncIsActiveLow = 1;
    _uut.isInterlaced = 0;
    _uut.eval();
    
    // Reset so that the non-default sync polarity takes effect
    _uut.clock = 1;
    _uut.eval();
    _uut.reset = 0;
    _uut.clock = 0;
    _uut.eval();
    
    for (unsigned int frameCount = 0; frameCount < 2; ++frameCount)
    {
        for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive); ++vCount)
        {
            ASSERT_EQ(vCount, _uut.VideoTimingSink__DOT__vCount);

            if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
            {
                ASSERT_EQ(vCount - _uut.vFrontPorch - _uut.vSyncPulse - _uut.vBackPorch, _uut.vPos);
            }
            else
            {
                ASSERT_EQ(0, _uut.vPos);
            }

            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
            {
                //std::cout << vCount << " " << hCount << std::endl;
                ASSERT_EQ(hCount, _uut.VideoTimingSink__DOT__hCount);
                
                if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
                }
                
                if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                    (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
                }
                
                if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
                {
                    ASSERT_EQ(hCount - _uut.hFrontPorch - _uut.hSyncPulse - _uut.hBackPorch, _uut.hPos);

                    if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                    {
                        ASSERT_EQ(1, _uut.dataEnable);
                    }
                    else
                    {
                        ASSERT_EQ(0, _uut.dataEnable);
                    }
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.hPos);
                }
                
                _uut.clock = 1;
                _uut.eval();
                _uut.clock = 0;
                _uut.eval();
            }
        }
    }
}

TEST_F(VideoTimingSinkTests, Svga800x600at72Hz)
{
    _uut.clock = 0;
    _uut.reset = 0;
    _uut.hFrontPorch = 56;
    _uut.hSyncPulse = 120;
    _uut.hBackPorch = 64;
    _uut.hActive = 800;
    _uut.vFrontPorch = 37;
    _uut.vSyncPulse = 6;
    _uut.vBackPorch = 23;
    _uut.vActive = 600;
    _uut.syncIsActiveLow = 0;
    _uut.isInterlaced = 0;
    _uut.eval();
    
    for (unsigned int frameCount = 0; frameCount < 2; ++frameCount)
    {
        for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive); ++vCount)
        {
            ASSERT_EQ(vCount, _uut.VideoTimingSink__DOT__vCount);

            if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
            {
                ASSERT_EQ(vCount - _uut.vFrontPorch - _uut.vSyncPulse - _uut.vBackPorch, _uut.vPos);
            }
            else
            {
                ASSERT_EQ(0, _uut.vPos);
            }

            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
            {
                //std::cout << vCount << " " << hCount << std::endl;
                ASSERT_EQ(hCount, _uut.VideoTimingSink__DOT__hCount);
                
                if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
                }
                
                if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                    (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
                }
                
                if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
                {
                    ASSERT_EQ(hCount - _uut.hFrontPorch - _uut.hSyncPulse - _uut.hBackPorch, _uut.hPos);

                    if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                    {
                        ASSERT_EQ(1, _uut.dataEnable);
                    }
                    else
                    {
                        ASSERT_EQ(0, _uut.dataEnable);
                    }
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.hPos);
                }
                
                _uut.clock = 1;
                _uut.eval();
                _uut.clock = 0;
                _uut.eval();
            }
        }
    }
}

TEST_F(VideoTimingSinkTests, Xga1024x768at85Hz)
{
    _uut.clock = 0;
    _uut.reset = 0;
    _uut.hFrontPorch = 48;
    _uut.hSyncPulse = 96;
    _uut.hBackPorch = 208;
    _uut.hActive = 1024;
    _uut.vFrontPorch = 1;
    _uut.vSyncPulse = 3;
    _uut.vBackPorch = 36;
    _uut.vActive = 768;
    _uut.syncIsActiveLow = 0;
    _uut.isInterlaced = 0;
    _uut.eval();
    
    for (unsigned int frameCount = 0; frameCount < 2; ++frameCount)
    {
        for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch + _uut.vActive); ++vCount)
        {
            ASSERT_EQ(vCount, _uut.VideoTimingSink__DOT__vCount);

            if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
            {
                ASSERT_EQ(vCount - _uut.vFrontPorch - _uut.vSyncPulse - _uut.vBackPorch, _uut.vPos);
            }
            else
            {
                ASSERT_EQ(0, _uut.vPos);
            }

            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch + _uut.hActive); ++hCount)
            {
                //std::cout << vCount << " " << hCount << std::endl;
                ASSERT_EQ(hCount, _uut.VideoTimingSink__DOT__hCount);
                
                if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
                }
                
                if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                    (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
                {
                    ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
                }
                else
                {
                    ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
                }
                
                if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
                {
                    ASSERT_EQ(hCount - _uut.hFrontPorch - _uut.hSyncPulse - _uut.hBackPorch, _uut.hPos);

                    if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                    {
                        ASSERT_EQ(1, _uut.dataEnable);
                    }
                    else
                    {
                        ASSERT_EQ(0, _uut.dataEnable);
                    }
                }
                else
                {
                    ASSERT_EQ(0, _uut.dataEnable);
                    ASSERT_EQ(0, _uut.hPos);
                }
                
                _uut.clock = 1;
                _uut.eval();
                _uut.clock = 0;
                _uut.eval();
            }
        }
    }
}
*/


