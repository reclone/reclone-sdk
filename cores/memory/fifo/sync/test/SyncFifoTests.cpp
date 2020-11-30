//
// SyncFifoTests - Unit tests for verilated SyncFifo module
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

#include "gtest/gtest.h"
#include "VSyncFifo.h"

class SyncFifoTests : public ::testing::Test
{
    public:
        SyncFifoTests() { }
        virtual ~SyncFifoTests()
        {
            _uut.final();
        }
        
    protected:
        VSyncFifo _uut;
};

TEST_F(SyncFifoTests, InitialDefaults)
{
    _uut.asyncReset = 0;
    _uut.clock = 0;
    _uut.readEnable = 0;
    _uut.writeEnable = 0;
    _uut.eval();
    
    ASSERT_EQ(1U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
}

TEST_F(SyncFifoTests, OneWriteOneRead)
{
    _uut.asyncReset = 0;
    _uut.clock = 0;
    _uut.readEnable = 0;
    _uut.writeEnable = 1;
    _uut.writeData = 0xA9;
    _uut.eval();
    ASSERT_EQ(1U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
    
    _uut.clock = 1;
    _uut.eval();
    _uut.writeEnable = 0;
    ASSERT_EQ(0U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
    
    _uut.clock = 0;
    _uut.readEnable = 1;
    _uut.eval();
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xA9, _uut.readData);
    ASSERT_EQ(1U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
}

TEST_F(SyncFifoTests, CircularBuffer)
{
    _uut.asyncReset = 0;
    _uut.clock = 0;
    _uut.readEnable = 0;
    _uut.writeEnable = 0;
    _uut.eval();
    ASSERT_EQ(1U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
    
    for (unsigned int i = 0; i < 1000; ++i)
    {
        _uut.writeEnable = 1;
        _uut.writeData = (i ^ 0xAA) % 0x100;
        _uut.eval();
        _uut.clock = 1;
        _uut.eval();
        _uut.writeEnable = 0;
        _uut.clock = 0;
        _uut.eval();
        ASSERT_EQ(0U, _uut.empty);
        ASSERT_EQ(0U, _uut.full);

        _uut.readEnable = 1;
        _uut.eval();
        _uut.clock = 1;
        _uut.eval();
        ASSERT_EQ((i ^ 0xAA) % 0x100, _uut.readData);
        ASSERT_EQ(1U, _uut.empty);
        ASSERT_EQ(0U, _uut.full);
        _uut.readEnable = 0;
        _uut.clock = 0;
        _uut.eval();
    }

}

TEST_F(SyncFifoTests, TwoWritesTwoReads)
{
    _uut.asyncReset = 0;
    _uut.clock = 0;
    _uut.readEnable = 0;
    _uut.writeEnable = 1;
    _uut.writeData = 0xA9;
    _uut.eval();
    ASSERT_EQ(1U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
    
    _uut.clock = 1;
    _uut.eval();
    _uut.clock = 0;
    _uut.writeData = 0x56;
    _uut.eval();
    _uut.clock = 1;
    _uut.eval();
    _uut.writeEnable = 0;
    
    ASSERT_EQ(0U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
    
    _uut.clock = 0;
    _uut.readEnable = 1;
    _uut.eval();
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0xA9, _uut.readData);
    ASSERT_EQ(0U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
    
    _uut.clock = 0;
    _uut.eval();
    _uut.clock = 1;
    _uut.eval();
    ASSERT_EQ(0x56, _uut.readData);
    ASSERT_EQ(1U, _uut.empty);
    ASSERT_EQ(0U, _uut.full);
}

/*
TEST_F(SyncFifoTests, AttemptReadWhenEmpty)
{
    
}

TEST_F(SyncFifoTests, AttemptWriteWhenFull)
{
    
}
*/

