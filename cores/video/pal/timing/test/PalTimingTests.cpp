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
    
    
    for (unsigned int frame = 0; frame < 2U; ++frame)
    {
        for (unsigned int line = 0; line <= 625U; ++line)
        {
            // The 0th line starts at its midpoint
            // The 625th line ends just before its midpoint
            for (unsigned int pixel = ((line == 0U) ? 567U : 0U); pixel < ((line == 625U) ? 567U : 1135U); ++pixel)
            {
                unsigned int vPos;
                
                ASSERT_EQ(_uut.PalTiming__DOT__vCount, line) << frame;
                ASSERT_EQ(_uut.PalTiming__DOT__hCount, pixel) << frame;
                
                bool vBlank = (line < 25U) || (line == 25U && pixel < 567U) || (line >= 313U && line < 338U);
                bool vSync = (line >= 3U && (line < 5U || (line == 5U && pixel < 567U))) || ((line > 315U || (line == 315U && pixel >= 567U)) && (line < 318U));
                bool vEqualize = !vSync && ((line < 8U) || (line >= 313U && (line < 320U || (line == 320U && pixel < 567U))));
                
                ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                
                if (line < 313U)
                {
                    // First field
                    
                    if (vBlank)
                    {
                        // Inactive line; the next active line is row 0
                        vPos = 0U;
                    }
                    else
                    {
                        // Active line
                        vPos = (line - 25U) * 2U;
                    }
                }
                else
                {
                    // Second field
                    
                    if (vBlank)
                    {
                        // Inactive line; the next active line is row 1
                        vPos = 1U;
                    }
                    else
                    {
                        // Active line
                        vPos = (line - 338U) * 2U + 1U;
                    }
                }
                ASSERT_EQ(_uut.vPos, vPos) << vBlank << std::endl << line << std::endl << pixel;
                
                // Front Porch
                if (pixel < 28U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Horizontal Sync
                else if (pixel < 112U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 1U);
                    ASSERT_EQ(_uut.sync, !vEqualize || (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Breezeway
                else if (pixel < 128U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Color Burst
                else if (pixel < 168U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    //ASSERT_EQ(_uut.burst, vBlank ? 0U : 1U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Back Porch
                else if (pixel < 212U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Active Video
                else
                {
                    ASSERT_EQ(_uut.blank, vBlank ? 1U : 0U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, pixel - 212U) << line << std::endl << pixel;
                }
                
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
    
    for (unsigned int frame = 0; frame < 2U; ++frame)
    {
        for (unsigned int line = 0; line <= 312U; ++line)
        {
            // The 0th line starts at its midpoint
            // The 312th line ends just before its midpoint
            for (unsigned int pixel = ((line == 0U) ? 567U : 0U); pixel < ((line == 312U) ? 567U : 1135U); ++pixel)
            {
                unsigned int vPos;
                
                ASSERT_EQ(_uut.PalTiming__DOT__vCount, line) << frame;
                ASSERT_EQ(_uut.PalTiming__DOT__hCount, pixel) << frame;
                
                bool vBlank = (line < 25U) || (line == 25U && pixel < 567U);
                bool vSync = (line >= 3U && (line < 5U || (line == 5U && pixel < 567U)));
                bool vEqualize = !vSync && (line < 8U);
                
                ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                
                if (vBlank)
                {
                    // Inactive line; the next active line is row 0
                    vPos = 0U;
                }
                else
                {
                    // Active line
                    vPos = line - 25U;
                }
                ASSERT_EQ(_uut.vPos, vPos) << vBlank << std::endl << line << std::endl << pixel;
                
                // Front Porch
                if (pixel < 28U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Horizontal Sync
                else if (pixel < 112U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 1U);
                    ASSERT_EQ(_uut.sync, !vEqualize || (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Breezeway
                else if (pixel < 128U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Color Burst
                else if (pixel < 168U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, vBlank ? 0U : 1U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Back Porch
                else if (pixel < 212U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                }
                
                // Active Video
                else
                {
                    ASSERT_EQ(_uut.blank, vBlank ? 1U : 0U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 70U))) || (vSync && (((pixel % 567U) >= 28U) && ((pixel % 567U) < 512U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, pixel - 212U) << line << std::endl << pixel;
                }
                
                nextPixel(vcd_trace);
            }
        }
    }
    
    vcd_trace.close();
}

