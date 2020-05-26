//
// VBlankDataIslandTests - Unit tests for verilated VBlankDataIsland module
//
//
// Copyright 2020 Reclone Labs <reclonelabs.com>
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
#include "VVBlankDataIsland.h"

class VBlankDataIslandTests : public ::testing::Test
{
    public:
        VBlankDataIslandTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~VBlankDataIslandTests()
        {
            _uut.final();
        }
        
    protected:
        VVBlankDataIsland _uut;
        unsigned int _tickCount;
};

TEST_F(VBlankDataIslandTests, NoVSync)
{
    _uut.pixelClock = 0;
    _uut.hSync = 0;
    _uut.vSync = 0;
    _uut.syncIsActiveLow = 0;
    _uut.videoFormatCode = 4; //720p
    _uut.rgbOrYCbCrCode = 0;
    _uut.yccQuantizationRange = 0;
    _uut.eval();
    
    for (unsigned int i = 0; i < 100; ++i)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
        
        _uut.pixelClock = 0;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
    }
    
    _uut.hSync = 1;
    
    for (unsigned int i = 0; i < 100; ++i)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
        
        _uut.pixelClock = 0;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
    }
    
    _uut.hSync = 0;
    
    for (unsigned int i = 0; i < 100; ++i)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
        
        _uut.pixelClock = 0;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
    }
}

TEST_F(VBlankDataIslandTests, Infoframe)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("DataIslandInfoframes.vcd");
    
    _uut.pixelClock = 0;
    _uut.hSync = 1;
    _uut.vSync = 1;
    _uut.syncIsActiveLow = 0;
    _uut.videoFormatCode = 4; //720p
    _uut.rgbOrYCbCrCode = 0;
    _uut.yccQuantizationRange = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    EXPECT_EQ(0, _uut.dataIslandActive);
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 0;
    _uut.eval();
    EXPECT_EQ(0, _uut.dataIslandActive);
    vcd_trace.dump(_tickCount++);
    
    _uut.hSync = 0;
    _uut.eval();
    
    // Margin of safety from the HBlank data island
    for (unsigned int count = 0; count < 42; ++count)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    // Preamble
    for (unsigned int count = 0; count < 8; ++count)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(1, _uut.dataIslandActive);
        EXPECT_EQ(0x154, _uut.channel0);
        EXPECT_EQ(0x0AB, _uut.channel1);
        EXPECT_EQ(0x0AB, _uut.channel2);
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    // Leading guard band
    for (unsigned int count = 0; count < 2; ++count)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(1, _uut.dataIslandActive);
        EXPECT_EQ(0x163, _uut.channel0);
        EXPECT_EQ(0x133, _uut.channel1);
        EXPECT_EQ(0x133, _uut.channel2);
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }

    // Packet data
    for (unsigned int count = 0; count < 32; ++count)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(1, _uut.dataIslandActive);
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }

    // Trailing guard band
    for (unsigned int count = 0; count < 2; ++count)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(1, _uut.dataIslandActive);
        EXPECT_EQ(0x163, _uut.channel0);
        EXPECT_EQ(0x133, _uut.channel1);
        EXPECT_EQ(0x133, _uut.channel2);
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    _uut.pixelClock = 1;
    _uut.eval();
    EXPECT_EQ(0, _uut.dataIslandActive);
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 0;
    _uut.eval();
    EXPECT_EQ(0, _uut.dataIslandActive);
    vcd_trace.dump(_tickCount++);
}


