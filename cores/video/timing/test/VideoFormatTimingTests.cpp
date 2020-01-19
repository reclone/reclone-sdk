//
// VideoFormatTimingTests - Unit tests for verilated VideoFormatTiming module
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
#include "VVideoFormatTiming.h"

class VideoFormatTimingTests : public ::testing::Test
{
    public:
        VideoFormatTimingTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VideoFormatTimingTests()
        {
            _uut.final();
        }
        
    protected:
        VVideoFormatTiming _uut;
        unsigned int _tickCount;
};

TEST_F(VideoFormatTimingTests, Hd720p60)
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
            ASSERT_EQ(vCount, _uut.VideoFormatTiming__DOT__vCount);

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
                ASSERT_EQ(hCount, _uut.VideoFormatTiming__DOT__hCount);
                
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

TEST_F(VideoFormatTimingTests, Hd1080i60)
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
            ASSERT_EQ(vCount, _uut.VideoFormatTiming__DOT__vCount);

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
                ASSERT_EQ(hCount, _uut.VideoFormatTiming__DOT__hCount);
                
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
            ASSERT_EQ(vCount, _uut.VideoFormatTiming__DOT__vCount);

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
                ASSERT_EQ(hCount, _uut.VideoFormatTiming__DOT__hCount);
                
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


TEST_F(VideoFormatTimingTests, Vga640x480at60Hz)
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
            ASSERT_EQ(vCount, _uut.VideoFormatTiming__DOT__vCount);

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
                ASSERT_EQ(hCount, _uut.VideoFormatTiming__DOT__hCount);
                
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

TEST_F(VideoFormatTimingTests, Svga800x600at72Hz)
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
            ASSERT_EQ(vCount, _uut.VideoFormatTiming__DOT__vCount);

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
                ASSERT_EQ(hCount, _uut.VideoFormatTiming__DOT__hCount);
                
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

TEST_F(VideoFormatTimingTests, Xga1024x768at85Hz)
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
            ASSERT_EQ(vCount, _uut.VideoFormatTiming__DOT__vCount);

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
                ASSERT_EQ(hCount, _uut.VideoFormatTiming__DOT__hCount);
                
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



