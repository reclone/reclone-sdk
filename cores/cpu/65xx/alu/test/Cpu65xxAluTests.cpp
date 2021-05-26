//
// Cpu65xxAluTests - Unit tests for verilated Cpu65xxAlu module
//
//
// Copyright 2019 - 2021 Reclone Labs <reclonelabs.com>
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
#include "gmock/gmock.h"
#include "VCpu65xxAlu.h"

using namespace ::testing;

class Cpu65xxAluTests : public Test
{
    public:
        Cpu65xxAluTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~Cpu65xxAluTests()
        {
            _uut.final();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VCpu65xxAlu _uut;
        unsigned int _tickCount;
};

TEST_F(Cpu65xxAluTests, SbcInteger)
{
    //_uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("alu.vcd");
    
    for (unsigned int a = 0; a <= 0xFF; ++a)
    {
        for (unsigned int b = 0; b <= 0xFF; ++b)
        {
            for (unsigned int carryIn = 0; carryIn <= 1; ++carryIn)
            {
                for (unsigned int overflowIn = 0; overflowIn <= 1; ++overflowIn)
                {
                    _uut.operandA = a;
                    _uut.operandB = b;
                    _uut.carryIn = carryIn;
                    _uut.overflowIn = overflowIn;
                    _uut.operation = 0x0; //ALU_OP_SBC
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    //_vcdTrace.dump(_tickCount++);
                    
                    uint8_t differenceByte = static_cast<uint8_t>(a) + static_cast<uint8_t>(~b) + static_cast<uint8_t>(carryIn);
                    int signedA = (a < 0x80) ? static_cast<int>(a) : static_cast<int>(a) - 0x100;
                    int signedB = (b < 0x80) ? static_cast<int>(b) : static_cast<int>(b) - 0x100;
                    int differenceSigned = signedA - signedB - static_cast<int>(!carryIn);
                    int differenceUnsigned = static_cast<int>(a) - static_cast<int>(b) - static_cast<int>(!carryIn);
                    ASSERT_EQ(differenceByte, _uut.result);
                    ASSERT_EQ((differenceUnsigned < 0) ? 0 : 1, _uut.carryOut)
                        << "differenceSigned=" << differenceSigned << " differenceByte=" << static_cast<unsigned int>(differenceByte)
                        << " a=" << a << " b=" << b << " carryIn=" << carryIn
                        << " signedA=" << signedA << " signedB=" << signedB << " result=" << static_cast<unsigned int>(_uut.result);
                    ASSERT_EQ((differenceSigned > 127 || differenceSigned < -128) ? 1 : 0, _uut.overflowOut)
                        << "differenceSigned=" << differenceSigned << " a=" << a << " b=" << b << " carryIn=" << carryIn
                        << " signedA=" << signedA << " signedB=" << signedB << " result=" << static_cast<unsigned int>(_uut.result);
                    ASSERT_EQ(differenceByte ? 0 : 1, _uut.zero);
                    ASSERT_EQ(((differenceByte & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
    
    //_vcdTrace.close();
}

TEST_F(Cpu65xxAluTests, AdcInteger)
{
    //_uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("alu.vcd");
    
    for (unsigned int a = 0; a <= 0xFF; ++a)
    {
        for (unsigned int b = 0; b <= 0xFF; ++b)
        {
            for (unsigned int carryIn = 0; carryIn <= 1; ++carryIn)
            {
                for (unsigned int overflowIn = 0; overflowIn <= 1; ++overflowIn)
                {
                    _uut.operandA = a;
                    _uut.operandB = b;
                    _uut.carryIn = carryIn;
                    _uut.overflowIn = overflowIn;
                    _uut.operation = 0x1; //ALU_OP_ADC
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    //_vcdTrace.dump(_tickCount++);
                    
                    uint8_t sumByte = static_cast<uint8_t>(a) + static_cast<uint8_t>(b) + static_cast<uint8_t>(carryIn);
                    int signedA = (a < 0x80) ? static_cast<int>(a) : static_cast<int>(a) - 0x100;
                    int signedB = (b < 0x80) ? static_cast<int>(b) : static_cast<int>(b) - 0x100;
                    int sumSigned = signedA + signedB + static_cast<int>(carryIn);
                    unsigned int sumUnsigned = a + b + carryIn;
                    
                    ASSERT_EQ(sumByte, _uut.result);
                    ASSERT_EQ((sumUnsigned > 0xFF) ? 1 : 0, _uut.carryOut);
                    ASSERT_EQ((sumSigned < -128 || sumSigned > 127) ? 1 : 0, _uut.overflowOut);
                    ASSERT_EQ(!sumByte, _uut.zero);
                    ASSERT_EQ(((sumByte & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
    
    //_vcdTrace.close();
}

TEST_F(Cpu65xxAluTests, Copy)
{
    for (unsigned int a = 0; a <= 0xFF; ++a)
    {
        for (unsigned int b = 0; b <= 0xFF; ++b)
        {
            for (unsigned int carryIn = 0; carryIn <= 1; ++carryIn)
            {
                for (unsigned int overflowIn = 0; overflowIn <= 1; ++overflowIn)
                {
                    _uut.operandA = a;
                    _uut.operandB = b;
                    _uut.carryIn = carryIn;
                    _uut.overflowIn = overflowIn;
                    _uut.operation = 0x9; //ALU_OP_COPY
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    ASSERT_EQ(a, _uut.result);
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!a, _uut.zero);
                    ASSERT_EQ(((a & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}


