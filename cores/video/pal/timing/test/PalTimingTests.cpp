//
// PalTimingTests - Unit tests for verilated PalTiming module
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
#include "VPalTiming.h"

class PalTimingTests : public ::testing::Test
{
    public:
        PalTimingTests() : _tickCount(1), _expectedPhase(0)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~PalTimingTests()
        {
            _uut.final();
        }
        
    protected:
        VPalTiming _uut;
        unsigned int _tickCount;
        unsigned int _expectedPhase;
        
        void nextPixel(VerilatedVcdC & tracer)
        {
            _uut.phaseClock = 1;
            _uut.eval();
            tracer.dump(_tickCount++);
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
            tracer.dump(_tickCount++);
            _uut.phaseClock = 1;
            _uut.eval();
            tracer.dump(_tickCount++);
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
            tracer.dump(_tickCount++);
            _uut.phaseClock = 1;
            _uut.eval();
            tracer.dump(_tickCount++);
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
            tracer.dump(_tickCount++);
            _uut.phaseClock = 1;
            _uut.eval();
            tracer.dump(_tickCount++);
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
            tracer.dump(_tickCount++);
        }
};

TEST_F(PalTimingTests, Interlaced)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PalInterlaced.vcd");
    
    _uut.reset = 0;
    _uut.phaseClock = 0;
    _uut.progressive = 0;
    _uut.eval();
    
    //bool firstPixel = true;
    
    for (unsigned int frame = 0; frame < 2U; ++frame)
    {
        for (unsigned int line = 0; line < 625U; ++line)
        {
            for (unsigned int pixel = 0; pixel < 1135U; ++pixel)
            {
                nextPixel(vcd_trace);
            }
        }
    }
    
    vcd_trace.close();
}

TEST_F(PalTimingTests, FakeProgressive)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PalFakeProgressive.vcd");
    
    _uut.reset = 0;
    _uut.phaseClock = 0;
    _uut.progressive = 1;
    _uut.eval();
    
    //bool firstPixel = true;
    
    for (unsigned int frame = 0; frame < 2U; ++frame)
    {
        for (unsigned int line = 0; line < 312U; ++line)
        {
            for (unsigned int pixel = 0; pixel < 1135U; ++pixel)
            {
                nextPixel(vcd_trace);
            }
        }
    }
    
    vcd_trace.close();
}

/* TEST_F(PalTimingTests, FakeProgressive)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("NtscFakeProgressive.vcd");
    
    _uut.reset = 0;
    _uut.phaseClock = 0;
    _uut.progressive = 1;
    _uut.eval();
    
    for (unsigned int frame = 0; frame < 2; ++frame)
    {
        for (unsigned int line = 0; line < 262; ++line)
        {
            // The 0th line of every frame is shortened by two pixels, to switch subcarrier phase
            for (unsigned int pixel = 0; pixel < 910U && (pixel < 908U || line != 9U); ++pixel)
            {
                unsigned int vPos;
                
                bool vBlank = (line < 20U);
                bool vSync = (line >= 3U && line < 6U);
                bool vEqualize = !vSync && (line < 9U);
                if (vBlank)
                {
                    vPos = 0U;
                }
                else
                {
                    vPos = line - 20U;
                }
                
                // Front Porch
                if (pixel < 24U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 455U) >= 24U) &&  ((pixel % 455U) < 58U))) || (vSync && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 412U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                    ASSERT_EQ(_uut.vPos, vPos);
                    nextPixel(vcd_trace);
                }
                
                // Horizontal Sync
                else if (pixel < 92)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 1U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, !vEqualize || (vEqualize && (((pixel % 455U) >= 24U) &&  ((pixel % 455U) < 58U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                    ASSERT_EQ(_uut.vPos, vPos);
                    nextPixel(vcd_trace);
                }
                
                // Breezeway
                else if (pixel < 100U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 58U))) || (vSync && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 412U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                    ASSERT_EQ(_uut.vPos, vPos);
                    nextPixel(vcd_trace);
                }
                
                // Color Burst
                else if (pixel < 136U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 58U))) || (vSync && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 412U))));
                    ASSERT_EQ(_uut.burst, vBlank ? 0U : 1U);
                    ASSERT_EQ(_uut.hPos, 0U);
                    ASSERT_EQ(_uut.vPos, vPos);
                    nextPixel(vcd_trace);
                }
                
                // Back Porch
                else if (pixel < 156U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 58U))) || (vSync && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 412U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                    ASSERT_EQ(_uut.vPos, vPos);
                    nextPixel(vcd_trace);
                }

                // Active Video
                else
                {
                    ASSERT_EQ(_uut.blank, vBlank ? 1U : 0U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 58U))) || (vSync && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 412U)))) << line << std::endl << pixel;
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, pixel - 156U);
                    ASSERT_EQ(_uut.vPos, vPos);
                    nextPixel(vcd_trace);
                }
            }
        }
    }
    
    vcd_trace.close();
} */

