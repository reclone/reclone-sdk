//
// AsyncFifoTests - Unit tests for verilated AsyncFifo module
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
#include "VAsyncFifo.h"

class AsyncFifoTests : public ::testing::Test
{
    public:
        AsyncFifoTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~AsyncFifoTests()
        {
            _uut.final();
        }
        
    protected:
        VAsyncFifo _uut;
        unsigned int _tickCount;
};

TEST_F(AsyncFifoTests, InitialDefaults)
{
    _uut.asyncReset = 0;
    _uut.readClock = 0;
    _uut.readEnable = 0;
    _uut.writeClock = 0;
    _uut.writeEnable = 0;
    _uut.eval();
    
    EXPECT_EQ(1U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
}

TEST_F(AsyncFifoTests, OneWriteOneRead)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("AsyncFifoOneWriteOneRead.vcd");
    
    _uut.asyncReset = 0;
    _uut.readClock = 0;
    _uut.readEnable = 0;
    _uut.writeClock = 0;
    _uut.writeEnable = 1;
    _uut.writeData = 0xA9;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    EXPECT_EQ(1U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    _uut.writeClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.writeEnable = 0;
    _uut.writeClock = 0;
    _uut.readClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);

    // Cycle the read clock twice to synchronize the write pointer
    // so that empty goes 0 and popEnable goes 1
    for (unsigned int i = 0; i < 2U; ++i)
    {
        EXPECT_EQ(1U, _uut.empty);
        EXPECT_EQ(0U, _uut.full);
    
        _uut.readClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        _uut.readClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    EXPECT_EQ(0U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    _uut.readClock = 0;
    _uut.readEnable = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.readClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    EXPECT_EQ(0xA9, _uut.readData);
    EXPECT_EQ(1U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    vcd_trace.close();
}

TEST_F(AsyncFifoTests, CircularBuffer)
{
    _uut.asyncReset = 0;
    _uut.readClock = 0;
    _uut.readEnable = 0;
    _uut.writeEnable = 0;
    _uut.writeClock = 0;
    _uut.eval();
    EXPECT_EQ(1U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    for (unsigned int i = 0; i < 1000; ++i)
    {
        _uut.writeEnable = 1;
        _uut.eval();
        _uut.writeData = (i ^ 0xAA) % 0x100;
        _uut.writeClock = 1;
        _uut.eval();
        _uut.writeEnable = 0;
        _uut.writeClock = 0;
        _uut.readClock = 1;
        _uut.eval();
        _uut.readClock = 0;
        _uut.eval();
        _uut.readClock = 1;
        _uut.eval();
        _uut.readClock = 0;
        _uut.eval();
        _uut.readClock = 1;
        _uut.eval();
        EXPECT_EQ(0U, _uut.empty);
        EXPECT_EQ(0U, _uut.full);

        _uut.readClock = 0;
        _uut.readEnable = 1;
        _uut.eval();
        _uut.readClock = 1;
        _uut.eval();
        EXPECT_EQ((i ^ 0xAA) % 0x100, _uut.readData);
        EXPECT_EQ(1U, _uut.empty);
        EXPECT_EQ(0U, _uut.full);
        _uut.readEnable = 0;
        _uut.readClock = 0;
        _uut.eval();
    }

}

TEST_F(AsyncFifoTests, TwoWritesTwoReads)
{
    _uut.asyncReset = 0;
    _uut.readClock = 0;
    _uut.readEnable = 0;
    _uut.writeClock = 0;
    _uut.writeEnable = 1;
    _uut.writeData = 0xA9;
    _uut.eval();
    EXPECT_EQ(1U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    _uut.writeClock = 1;
    _uut.eval();
    _uut.writeClock = 0;
    _uut.writeData = 0x56;
    _uut.eval();
    _uut.writeClock = 1;
    _uut.eval();
    _uut.writeEnable = 0;
    
    _uut.readClock = 1;
    _uut.eval();
    _uut.readClock = 0;
    _uut.eval();
    _uut.readClock = 1;
    _uut.eval();
    _uut.readClock = 0;
    _uut.eval();
    _uut.readClock = 1;
    _uut.eval();
    EXPECT_EQ(0U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    _uut.readClock = 0;
    _uut.readEnable = 1;
    _uut.eval();
    _uut.readClock = 1;
    _uut.eval();
    EXPECT_EQ(0xA9, _uut.readData);
    EXPECT_EQ(0U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    _uut.readClock = 0;
    _uut.eval();
    _uut.readClock = 1;
    _uut.eval();
    EXPECT_EQ(0x56, _uut.readData);
    EXPECT_EQ(1U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
}


TEST_F(AsyncFifoTests, AttemptReadWhenEmpty)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("AsyncFifoReadWhenEmpty.vcd");
    
    _uut.asyncReset = 0;
    _uut.readClock = 0;
    _uut.readEnable = 0;
    _uut.writeClock = 0;
    _uut.writeEnable = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    EXPECT_EQ(1U, _uut.empty);
    EXPECT_EQ(0U, _uut.full);
    
    _uut.readEnable = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    for (unsigned int i = 0; i < 1000; ++i)
    {
        _uut.writeClock = 1;
        _uut.readClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        EXPECT_EQ(1U, _uut.empty);
        EXPECT_EQ(0U, _uut.full);
        
        _uut.writeClock = 0;
        _uut.readClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        EXPECT_EQ(1U, _uut.empty);
        EXPECT_EQ(0U, _uut.full);
    }
    
    vcd_trace.close();
}


TEST_F(AsyncFifoTests, AttemptWriteWhenFull)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("AsyncFifoWriteWhenFull.vcd");
    
    _uut.asyncReset = 0;
    _uut.readClock = 0;
    _uut.readEnable = 0;
    _uut.writeClock = 0;
    _uut.writeEnable = 1;
    _uut.writeData = 0x5B;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    for (unsigned int i = 0; i < 7U; ++i)
    {
        EXPECT_EQ(0U, _uut.full) << i;
        EXPECT_EQ(1U, _uut.empty);
        
        _uut.writeClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        _uut.writeClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
    }
    
    EXPECT_EQ(1U, _uut.full);
    EXPECT_EQ(1U, _uut.empty);
    _uut.writeEnable = 0;
    
    // Cycle read clock a few times to synchronize write pointer
    _uut.readClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.readClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.readClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.readClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.readClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    
    EXPECT_EQ(0U, _uut.empty);
    EXPECT_EQ(1U, _uut.full);
    
    _uut.readClock = 0;
    _uut.readEnable = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.readClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    EXPECT_EQ(0x5B, _uut.readData);
    EXPECT_EQ(0U, _uut.empty);
    // Still full
    EXPECT_EQ(1U, _uut.full);
    
    _uut.readEnable = 0;
    
    // Cycle write clock a few times to synchronize read pointer
    _uut.writeClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.writeClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.writeClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.writeClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.writeClock = 1;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    _uut.writeEnable = 1;
    _uut.writeClock = 0;
    _uut.eval();
    vcd_trace.dump(_tickCount++);
    EXPECT_EQ(0U, _uut.empty);
    // No longer full
    EXPECT_EQ(0U, _uut.full);
    
    for (unsigned int i = 0; i < 1000U; ++i)
    {
        _uut.writeClock = 1;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        _uut.writeClock = 0;
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        EXPECT_EQ(1U, _uut.full) << i;
        EXPECT_EQ(0U, _uut.empty) << i;
    }
    
    vcd_trace.close();
}



