//
// HBlankDataIslandTests - Unit tests for verilated HBlankDataIsland module
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
#include "VHBlankDataIsland.h"

class HBlankDataIslandTests : public ::testing::Test
{
    public:
        HBlankDataIslandTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~HBlankDataIslandTests()
        {
            _uut.final();
        }
        
    protected:
        VHBlankDataIsland _uut;
        unsigned int _tickCount;
};

TEST_F(HBlankDataIslandTests, NoHSync)
{
    _uut.pixelClock = 0;
    _uut.hSync = 0;
    _uut.vSync = 0;
    _uut.n = 6144;
    _uut.cts = 74250;
    _uut.samplesPerRegenPacket = 48;
    _uut.spdifCategoryCode = 0x60;  // ADC without copyright
    _uut.spdifSamplingFreq = 2;     // 48 kHz
    _uut.spdifWordLength = 2;       // 16 bits
    _uut.sampleFifoEmpty = 1;
    _uut.sampleFifoReadData = 0;
    _uut.eval();
    
    for (unsigned int i = 0; i < 100000; ++i)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
        
        _uut.pixelClock = 0;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
    }
}

TEST_F(HBlankDataIslandTests, OneSample)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("DataIslandOneSample.vcd");
    
    _uut.pixelClock = 0;
    _uut.hSync = 0;
    _uut.vSync = 0;
    _uut.n = 6144;
    _uut.cts = 74250;
    _uut.samplesPerRegenPacket = 48;
    _uut.spdifCategoryCode = 0x60;  // ADC without copyright
    _uut.spdifSamplingFreq = 2;     // 48 kHz
    _uut.spdifWordLength = 2;       // 16 bits
    _uut.sampleFifoEmpty = 1;
    _uut.sampleFifoReadData = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    // Start HSync interval
    _uut.hSync = 1;
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    // Pass in a sample from the FIFO
    _uut.sampleFifoEmpty = 0;
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    EXPECT_EQ(1, _uut.sampleFifoReadEnable);
    
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    EXPECT_EQ(0, _uut.sampleFifoReadEnable);
    
    // FIFO provides the sample
    _uut.sampleFifoReadData = 0x118855AA;
    _uut.sampleFifoEmpty = 1;
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    // Should have just latched the sample
    _uut.sampleFifoReadData = 0;
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    EXPECT_EQ(0, _uut.sampleFifoReadEnable);

    // 12 cycle delay before starting data island
    // This is when more audio samples can get collected from the fifo
    for (unsigned int count = 0; count < 12; ++count)
    {
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        EXPECT_EQ(0, _uut.dataIslandActive) << count;
    }
    
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    // Should have started an audio sample data island
    // Preamble
    for (unsigned int count = 0; count < 8; ++count)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(1, _uut.dataIslandActive);
        EXPECT_EQ(0x0AB, _uut.channel0);
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
        EXPECT_EQ(0x271, _uut.channel0);
        EXPECT_EQ(0x133, _uut.channel1);
        EXPECT_EQ(0x133, _uut.channel2);
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    // Packet data (2 packets * 32 clocks per packet)
    for (unsigned int count = 0; count < 64; ++count)
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
        EXPECT_EQ(0x271, _uut.channel0);
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

TEST_F(HBlankDataIslandTests, NoSamples)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("DataIslandNoSamples.vcd");
    
    _uut.pixelClock = 0;
    _uut.hSync = 0;
    _uut.vSync = 0;
    _uut.n = 6144;
    _uut.cts = 74250;
    _uut.samplesPerRegenPacket = 48;
    _uut.spdifCategoryCode = 0x60;  // ADC without copyright
    _uut.spdifSamplingFreq = 2;     // 48 kHz
    _uut.spdifWordLength = 2;       // 16 bits
    _uut.sampleFifoEmpty = 1;
    _uut.sampleFifoReadData = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    
    // Start HSync interval without any new samples
    _uut.hSync = 1;
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    // 16 cycle delay before starting data island
    // This is when audio samples normally get collected from the fifo
    for (unsigned int count = 0; count < 16; ++count)
    {
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        EXPECT_EQ(0, _uut.dataIslandActive) << count;
    }
    
    _uut.pixelClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    // Should have started an audio sample data island
    // Preamble
    for (unsigned int count = 0; count < 8; ++count)
    {
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(1, _uut.dataIslandActive) << count;
        EXPECT_EQ(0x0AB, _uut.channel0);
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
        EXPECT_EQ(0x271, _uut.channel0);
        EXPECT_EQ(0x133, _uut.channel1);
        EXPECT_EQ(0x133, _uut.channel2);
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    // Packet data (2 packets * 32 clocks per packet)
    for (unsigned int count = 0; count < 64; ++count)
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
        EXPECT_EQ(0x271, _uut.channel0);
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

TEST_F(HBlankDataIslandTests, RegenPackets)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("DataIslandRegenPackets.vcd");
    
    _uut.pixelClock = 0;
    _uut.hSync = 0;
    _uut.vSync = 0;
    _uut.n = 6144;
    _uut.cts = 74250;
    _uut.samplesPerRegenPacket = 48;
    _uut.spdifCategoryCode = 0x60;  // ADC without copyright
    _uut.spdifSamplingFreq = 2;     // 48 kHz
    _uut.spdifWordLength = 2;       // 16 bits
    _uut.sampleFifoEmpty = 1;
    _uut.sampleFifoReadData = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    _uut.pixelClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    for (unsigned int packetCount = 0; packetCount < 400; ++packetCount)
    {
        // Start HSync interval
        _uut.hSync = 1;
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        // Pass in a sample from the FIFO
        _uut.sampleFifoEmpty = 0;
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        EXPECT_EQ(1, _uut.sampleFifoReadEnable);
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        EXPECT_EQ(0, _uut.sampleFifoReadEnable);
        
        // FIFO provides the sample
        _uut.sampleFifoReadData = 0x118855AA;
        _uut.sampleFifoEmpty = 1;
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        _uut.pixelClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        // Should have just latched the sample
        // Burn 13 more cycles
        for (unsigned int count = 0; count < 13; ++count)
        {
            _uut.sampleFifoReadData = 0;
            _uut.pixelClock = 0;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
            
            _uut.pixelClock = 1;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
            EXPECT_EQ(0, _uut.sampleFifoReadEnable);
        }
        
        _uut.pixelClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        // Should have started a data island
        // Preamble
        for (unsigned int count = 0; count < 8; ++count)
        {
            _uut.pixelClock = 1;
            _uut.eval();
            EXPECT_EQ(1, _uut.dataIslandActive);
            EXPECT_EQ(0x0AB, _uut.channel0);
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
            EXPECT_EQ(0x271, _uut.channel0);
            EXPECT_EQ(0x133, _uut.channel1);
            EXPECT_EQ(0x133, _uut.channel2);
            vcd_trace.dump(_tickCount++);
            
            _uut.pixelClock = 0;
            _uut.eval();
            vcd_trace.dump(_tickCount++);
        }
        
        // Packet data
        for (unsigned int count = 0; count < 64; ++count)
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
            EXPECT_EQ(0x271, _uut.channel0);
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
        
        // End HSync interval
        _uut.hSync = 0;
        
        for (unsigned int count = 0; count < 15; ++count)
        {
            _uut.pixelClock = 1;
            _uut.eval();
            EXPECT_EQ(0, _uut.dataIslandActive);
            vcd_trace.dump(_tickCount++);
            
            _uut.pixelClock = 0;
            _uut.eval();
            EXPECT_EQ(0, _uut.dataIslandActive);
            vcd_trace.dump(_tickCount++);
        }
        
        _uut.pixelClock = 1;
        _uut.eval();
        EXPECT_EQ(0, _uut.dataIslandActive);
        vcd_trace.dump(_tickCount++);
    }
}


