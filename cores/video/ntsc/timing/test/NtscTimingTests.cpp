//
// NtscTimingTests - Unit tests for verilated NtscTiming module
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
#include "VNtscTiming.h"

class NtscTimingTests : public ::testing::Test
{
    public:
        NtscTimingTests() : _tickCount(1), _expectedPhase(0)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~NtscTimingTests()
        {
            _uut.final();
        }
        
    protected:
        VNtscTiming _uut;
        unsigned int _tickCount;
        unsigned int _expectedPhase;
        
        void nextPixel()
        {
            _uut.phaseClock = 1;
            _uut.eval();
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
            _uut.phaseClock = 1;
            _uut.eval();
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
            _uut.phaseClock = 1;
            _uut.eval();
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
            _uut.phaseClock = 1;
            _uut.eval();
            _expectedPhase = (_expectedPhase + 1) % 16;
            ASSERT_EQ(_expectedPhase, _uut.phase);
            
            _uut.phaseClock = 0;
            _uut.eval();
        }
};

TEST_F(NtscTimingTests, Interlaced)
{
    _uut.reset = 0;
    _uut.phaseClock = 0;
    _uut.progressive = 0;
    _uut.progressivePhaseAlternation = 0;
    _uut.eval();
    
    for (unsigned int frame = 0; frame < 3; ++frame)
    {
        for (unsigned int line = 0; line < 525; ++line)
        {
            for (unsigned int pixel = 0; pixel < 910U; ++pixel)
            {
                bool vBlank = (line < 20U) || ((line > 262U || (line == 262U && pixel >= 455U)) && (line < 282U || (line == 282U && pixel < 455U)));
                bool vSync = (line >= 3U && line < 6U) || ((line > 265U || (line == 265U && pixel >= 455U)) && (line < 268U || (line == 268U && pixel < 455U)));
                bool vEqualize = !vSync && ((line < 9U) || ((line > 262U || (line == 262U && pixel >= 455U)) && (line < 271U || (line == 271U && pixel < 455U))));
                
                // Front Porch
                if (pixel < 24U)
                {
                    ASSERT_EQ(_uut.blank, 1U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 455U) >= 24U) &&  ((pixel % 455U) < 58U))) || (vSync && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 412U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, 0U);
                    nextPixel();
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
                    nextPixel();
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
                    nextPixel();
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
                    nextPixel();
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
                    nextPixel();
                }

                // Active Video
                else
                {
                    ASSERT_EQ(_uut.blank, vBlank ? 1U : 0U);
                    ASSERT_EQ(_uut.hSync, 0U);
                    ASSERT_EQ(_uut.vSync, vSync ? 1U : 0U);
                    ASSERT_EQ(_uut.sync, (vEqualize && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 58U))) || (vSync && (((pixel % 455U) >= 24U) && ((pixel % 455U) < 412U))));
                    ASSERT_EQ(_uut.burst, 0U);
                    ASSERT_EQ(_uut.hPos, pixel - 156U);
                    nextPixel();
                }
            }
        }
    }
}

