//
// NullDataIslandPacketTests - Unit tests for verilated NullDataIslandPacket module
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
#include "VNullDataIslandPacket.h"

class NullDataIslandPacketTests : public ::testing::Test
{
    public:
        NullDataIslandPacketTests() { }
        virtual ~NullDataIslandPacketTests()
        {
            _uut.final();
        }
        
    protected:
        VNullDataIslandPacket _uut;
};

TEST_F(NullDataIslandPacketTests, ExpectZeros)
{
    _uut.eval();
    ASSERT_EQ(0U, _uut.header);
    ASSERT_EQ(0LLU, _uut.subpacket0);
    ASSERT_EQ(0LLU, _uut.subpacket1);
    ASSERT_EQ(0LLU, _uut.subpacket2);
    ASSERT_EQ(0LLU, _uut.subpacket3);
}
