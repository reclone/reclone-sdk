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

TEST_F(Cpu65xxAluTests, And)
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
                    _uut.operation = 0x2; //ALU_OP_AND
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    ASSERT_EQ(a & b, _uut.result);
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!(a & b), _uut.zero);
                    ASSERT_EQ(((a & b & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Bit)
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
                    _uut.operation = 0x3; //ALU_OP_BIT
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    ASSERT_EQ(a & b, _uut.result);
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(((b & 0x40) >> 6), _uut.overflowOut);
                    ASSERT_EQ(!(a & b), _uut.zero);
                    ASSERT_EQ(((b & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Radd)
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
                    _uut.operation = 0x4; //ALU_OP_RADD
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t sumByte = static_cast<uint8_t>(a) + static_cast<uint8_t>(b);
                    unsigned int sumUnsigned = a + b;

                    ASSERT_EQ(sumByte, _uut.result);
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!sumByte, _uut.zero);
                    ASSERT_EQ(((sumByte & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(((sumUnsigned > 0xFF) ^ ((b & 0x80) >> 7)) ? 1 : 0, _uut.branchCondition)
                        << "sumUnsigned=" << sumUnsigned << " a=" << a << " b=" << b
                        << " result=" << static_cast<unsigned int>(_uut.result);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Cmp)
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
                    _uut.operation = 0x5; //ALU_OP_CMP
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t differenceByte = static_cast<uint8_t>(a) - static_cast<uint8_t>(b);

                    ASSERT_EQ(differenceByte, _uut.result);
                    ASSERT_EQ((a >= b) ? 1 : 0, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!differenceByte, _uut.zero);
                    ASSERT_EQ(((differenceByte & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Iadd)
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
                    _uut.operation = 0x6; //ALU_OP_IADD
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t sumByte = static_cast<uint8_t>(a) + static_cast<uint8_t>(b);
                    unsigned int sumUnsigned = a + b;

                    ASSERT_EQ(sumByte, _uut.result);
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!sumByte, _uut.zero);
                    ASSERT_EQ(((sumByte & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(((sumUnsigned > 0xFF)) ? 1 : 0, _uut.branchCondition)
                        << "sumUnsigned=" << sumUnsigned << " a=" << a << " b=" << b
                        << " result=" << static_cast<unsigned int>(_uut.result);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Or)
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
                    _uut.operation = 0x7; //ALU_OP_OR
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    ASSERT_EQ(a | b, _uut.result);
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!(a | b), _uut.zero);
                    ASSERT_EQ((((a | b) & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Eor)
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
                    _uut.operation = 0x8; //ALU_OP_EOR
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    ASSERT_EQ(a ^ b, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!(a ^ b), _uut.zero);
                    ASSERT_EQ((((a ^ b) & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
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

TEST_F(Cpu65xxAluTests, Inc)
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
                    _uut.operation = 0xA; //ALU_OP_INC
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t incA = static_cast<uint8_t>(a + 1);
                    ASSERT_EQ(incA, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!incA, _uut.zero);
                    ASSERT_EQ(((incA & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Dec)
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
                    _uut.operation = 0xB; //ALU_OP_DEC
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t decA = static_cast<uint8_t>(a - 1);
                    ASSERT_EQ(decA, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!decA, _uut.zero);
                    ASSERT_EQ(((decA & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Fixup)
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
                    _uut.operation = 0xC; //ALU_OP_FIXUP
                    _uut.opExtension = 0;
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    bool dec = ((b & 0x80) >> 7);
                    uint8_t fixupA = dec ? static_cast<uint8_t>(a - 1) : static_cast<uint8_t>(a + 1);
                    ASSERT_EQ(fixupA, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!fixupA, _uut.zero);
                    ASSERT_EQ(((fixupA & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, SetBit)
{
    for (unsigned int a = 0; a <= 0xFF; ++a)
    {
        for (unsigned int b = 0; b <= 0xFF; ++b)
        {
            for (unsigned int carryIn = 0; carryIn <= 1; ++carryIn)
            {
                for (unsigned int overflowIn = 0; overflowIn <= 1; ++overflowIn)
                {
                    for (unsigned int bitNum = 0; bitNum <= 7; ++bitNum)
                    {
                        _uut.operandA = a;
                        _uut.operandB = b;
                        _uut.carryIn = carryIn;
                        _uut.overflowIn = overflowIn;
                        _uut.operation = 0xE; //ALU_OP_SETBIT
                        _uut.opExtension = bitNum;
                        _uut.decimalMode = 0;
                        
                        _uut.eval();
                        
                        uint8_t setbitA = static_cast<uint8_t>(a | (1U << bitNum));
                        ASSERT_EQ(setbitA, _uut.result) << "a=" << a << " b=" << b;
                        ASSERT_EQ(carryIn, _uut.carryOut);
                        ASSERT_EQ(overflowIn, _uut.overflowOut);
                        ASSERT_EQ(!setbitA, _uut.zero);
                        ASSERT_EQ(((setbitA & 0x80) >> 7), _uut.negative);
                        ASSERT_EQ(0, _uut.branchCondition);
                    }
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, ClrBit)
{
    for (unsigned int a = 0; a <= 0xFF; ++a)
    {
        for (unsigned int b = 0; b <= 0xFF; ++b)
        {
            for (unsigned int carryIn = 0; carryIn <= 1; ++carryIn)
            {
                for (unsigned int overflowIn = 0; overflowIn <= 1; ++overflowIn)
                {
                    for (unsigned int bitNum = 0; bitNum <= 7; ++bitNum)
                    {
                        _uut.operandA = a;
                        _uut.operandB = b;
                        _uut.carryIn = carryIn;
                        _uut.overflowIn = overflowIn;
                        _uut.operation = 0xF; //ALU_OP_CLRBIT
                        _uut.opExtension = bitNum;
                        _uut.decimalMode = 0;
                        
                        _uut.eval();
                        
                        uint8_t clrbitA = static_cast<uint8_t>(a & ~(1U << bitNum));
                        ASSERT_EQ(clrbitA, _uut.result) << "a=" << a << " b=" << b;
                        ASSERT_EQ(carryIn, _uut.carryOut);
                        ASSERT_EQ(overflowIn, _uut.overflowOut);
                        ASSERT_EQ(!clrbitA, _uut.zero);
                        ASSERT_EQ(((clrbitA & 0x80) >> 7), _uut.negative);
                        ASSERT_EQ(0, _uut.branchCondition);
                    }
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Asl)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 1; //ALU_SOP_ASL
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t carryOut = (a & 0x80) >> 7;
                    uint8_t aslA = static_cast<uint8_t>((a << 1) & 0xFF);
                    ASSERT_EQ(aslA, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryOut, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!aslA, _uut.zero);
                    ASSERT_EQ(((aslA & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Lsr)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 3; //ALU_SOP_LSR
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t carryOut = a & 0x01;
                    uint8_t lsrA = static_cast<uint8_t>((a >> 1) & 0x7F);
                    ASSERT_EQ(lsrA, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryOut, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!lsrA, _uut.zero);
                    ASSERT_EQ(0, _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Rol)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 5; //ALU_SOP_ROL
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t carryOut = (a & 0x80) >> 7;
                    uint8_t rolA = static_cast<uint8_t>(((a << 1) & 0xFF) | carryIn);
                    ASSERT_EQ(rolA, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryOut, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!rolA, _uut.zero);
                    ASSERT_EQ(((rolA & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, Ror)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 7; //ALU_SOP_ROR
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    uint8_t carryOut = a & 0x01;
                    uint8_t rorA = static_cast<uint8_t>(((a >> 1) & 0x7F) | (carryIn << 7));
                    ASSERT_EQ(rorA, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryOut, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!rorA, _uut.zero);
                    ASSERT_EQ(carryIn, _uut.negative);
                    ASSERT_EQ(0, _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, TestN)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 0; //ALU_SOP_TEST_N
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    ASSERT_EQ(a, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!a, _uut.zero);
                    ASSERT_EQ(((a & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(((a & 0x80) >> 7), _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, TestC)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 2; //ALU_SOP_TEST_C
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    ASSERT_EQ(a, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!a, _uut.zero);
                    ASSERT_EQ(((a & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(((a & 0x01) >> 0), _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, TestV)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 4; //ALU_SOP_TEST_V
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    ASSERT_EQ(a, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!a, _uut.zero);
                    ASSERT_EQ(((a & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(((a & 0x40) >> 6), _uut.branchCondition);
                }
            }
        }
    }
}

TEST_F(Cpu65xxAluTests, TestZ)
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
                    _uut.operation = 0xD; //ALU_OP_SGL
                    _uut.opExtension = 6; //ALU_SOP_TEST_Z
                    _uut.decimalMode = 0;
                    
                    _uut.eval();
                    
                    ASSERT_EQ(a, _uut.result) << "a=" << a << " b=" << b;
                    ASSERT_EQ(carryIn, _uut.carryOut);
                    ASSERT_EQ(overflowIn, _uut.overflowOut);
                    ASSERT_EQ(!a, _uut.zero);
                    ASSERT_EQ(((a & 0x80) >> 7), _uut.negative);
                    ASSERT_EQ(((a & 0x02) >> 1), _uut.branchCondition);
                }
            }
        }
    }
}

