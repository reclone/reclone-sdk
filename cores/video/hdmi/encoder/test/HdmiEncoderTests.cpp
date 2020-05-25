//
// HdmiEncoderTests - Unit tests for verilated HdmiEncoder module
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
#include "VHdmiEncoder.h"
#include "VVideoFormatTiming.h"

class HdmiEncoderTests : public ::testing::Test
{
    public:
        HdmiEncoderTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~HdmiEncoderTests()
        {
            _uut.final();
        }
        
    protected:
        VHdmiEncoder _uut;
        VVideoFormatTiming _timing;
        unsigned int _tickCount;
};

TEST_F(HdmiEncoderTests, EncoderWith720pTiming)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("HdmiEncoderWith720pTiming.vcd");
    
    _timing.clock = 0;
    _timing.reset = 0;
    _timing.hFrontPorch = 110;
    _timing.hSyncPulse = 40;
    _timing.hBackPorch = 220;
    _timing.hActive = 1280;
    _timing.vFrontPorch = 5;
    _timing.vSyncPulse = 5;
    _timing.vBackPorch = 20;
    _timing.vActive = 720;
    _timing.syncIsActiveLow = 0;
    _timing.isInterlaced = 0;
    _timing.eval();
    _uut.pixelClock = _timing.clock;
    _uut.dataEnable = _timing.dataEnable;
    _uut.hSync = _timing.hSync;
    _uut.vSync = _timing.vSync;
    _uut.syncIsActiveLow = _timing.syncIsActiveLow;
    _uut.activeVideoPreamble = _timing.activeVideoPreamble;
    _uut.activeVideoGuardBand = _timing.activeVideoGuardBand;
    _uut.useYCbCr = 1;
    _uut.videoFormatCode = 4;
    _uut.blueOrCb = 255;
    _uut.greenOrY = 0;
    _uut.redOrCr = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    vcd_trace.flush();
    
    for (unsigned int frameCount = 0; frameCount < 2; ++frameCount)
    {
        for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_timing.vFrontPorch + _timing.vSyncPulse + _timing.vBackPorch + _timing.vActive); ++vCount)
        {
            // ASSERT_EQ(vCount, _uut.HdmiEncoder__DOT__vCount);

            // if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
            // {
                // ASSERT_EQ(vCount - _uut.vFrontPorch - _uut.vSyncPulse - _uut.vBackPorch, _uut.vPos);
            // }
            // else
            // {
                // ASSERT_EQ(0, _uut.vPos);
            // }

            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_timing.hFrontPorch + _timing.hSyncPulse + _timing.hBackPorch + _timing.hActive); ++hCount)
            {
                //std::cout << vCount << " " << hCount << std::endl;
                // ASSERT_EQ(hCount, _uut.HdmiEncoder__DOT__hCount);
                
                // if (hCount >= _uut.hFrontPorch && hCount < (_uut.hFrontPorch + _uut.hSyncPulse))
                // {
                    // ASSERT_EQ(!_uut.syncIsActiveLow, _uut.hSync);
                // }
                // else
                // {
                    // ASSERT_EQ(_uut.syncIsActiveLow, _uut.hSync);
                // }
                
                // if ((vCount > _uut.vFrontPorch || (vCount == _uut.vFrontPorch && hCount >= _uut.hFrontPorch)) && 
                    // (vCount < (_uut.vFrontPorch + _uut.vSyncPulse) || (vCount == (_uut.vFrontPorch + _uut.vSyncPulse) && hCount < _uut.hFrontPorch)))
                // {
                    // ASSERT_EQ(!_uut.syncIsActiveLow, _uut.vSync);
                // }
                // else
                // {
                    // ASSERT_EQ(_uut.syncIsActiveLow, _uut.vSync);
                // }
                
                // if (hCount >= static_cast<unsigned int>(_uut.hFrontPorch + _uut.hSyncPulse + _uut.hBackPorch))
                // {
                    // ASSERT_EQ(hCount - _uut.hFrontPorch - _uut.hSyncPulse - _uut.hBackPorch, _uut.hPos);

                    // if (vCount >= static_cast<unsigned int>(_uut.vFrontPorch + _uut.vSyncPulse + _uut.vBackPorch))
                    // {
                        // ASSERT_EQ(1, _uut.dataEnable);
                    // }
                    // else
                    // {
                        // ASSERT_EQ(0, _uut.dataEnable);
                    // }
                // }
                // else
                // {
                    // ASSERT_EQ(0, _uut.dataEnable);
                    // ASSERT_EQ(0, _uut.hPos);
                // }
                
                _timing.clock = 1;
                _timing.eval();
                _uut.pixelClock = _timing.clock;
                _uut.dataEnable = _timing.dataEnable;
                _uut.hSync = _timing.hSync;
                _uut.vSync = _timing.vSync;
                _uut.syncIsActiveLow = _timing.syncIsActiveLow;
                _uut.activeVideoPreamble = _timing.activeVideoPreamble;
                _uut.activeVideoGuardBand = _timing.activeVideoGuardBand;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                _timing.clock = 0;
                _timing.eval();
                _uut.pixelClock = _timing.clock;
                _uut.dataEnable = _timing.dataEnable;
                _uut.hSync = _timing.hSync;
                _uut.vSync = _timing.vSync;
                _uut.syncIsActiveLow = _timing.syncIsActiveLow;
                _uut.activeVideoPreamble = _timing.activeVideoPreamble;
                _uut.activeVideoGuardBand = _timing.activeVideoGuardBand;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                //vcd_trace.flush();
            }
            vcd_trace.flush();
        }
    }
    
    vcd_trace.close();
}

