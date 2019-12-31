//
// CtlEncoder2to10Tests - Unit tests for verilated CtlEncoder2to10 module
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
#include "VCtlEncoder2to10.h"

class CtlEncoder2to10Tests : public ::testing::Test
{
    public:
        CtlEncoder2to10Tests() { }
        virtual ~CtlEncoder2to10Tests()
        {
            _uut.final();
        }
        
    protected:
        VCtlEncoder2to10 _uut;
};

TEST_F(CtlEncoder2to10Tests, CheckAllOutputValues)
{
    _uut.d = 0;
    _uut.eval();
    ASSERT_EQ(0x354, _uut.q);

    _uut.d = 1;
    _uut.eval();
    ASSERT_EQ(0x0ab, _uut.q);

    _uut.d = 2;
    _uut.eval();
    ASSERT_EQ(0x154, _uut.q);

    _uut.d = 3;
    _uut.eval();
    ASSERT_EQ(0x2ab, _uut.q);
}