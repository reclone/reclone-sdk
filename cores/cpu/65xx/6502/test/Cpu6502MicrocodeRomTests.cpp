//
// Cpu6502MicrocodeRomTests - Unit tests for verilated Cpu6502 module
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

#include <iostream>
#include <iomanip>
#include <fstream>
#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "gmock/gmock.h"
#include "VCpu6502MicrocodeRom.h"

using namespace ::testing;

class Cpu6502MicrocodeRomTests : public Test
{
    public:
        Cpu6502MicrocodeRomTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~Cpu6502MicrocodeRomTests()
        {
            _uut.final();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VCpu6502MicrocodeRom _uut;
        unsigned int _tickCount;
};

TEST_F(Cpu6502MicrocodeRomTests, DumpCpu6502MicrocodeRom)
{
    std::ofstream myfile;
    myfile.open("Cpu6502MicrocodeRom.txt", std::ios::out);
    ASSERT_TRUE(myfile.is_open());
    
    _uut.clock = 1;
    _uut.enable = 1;
    _uut.address = 0;
    _uut.eval();
    
    // assign addrBusMux = d[31:30];
    // assign dataBusWriteEnable = d[29];
    // assign dataBusMux = d[28:27];
    // assign aluOperation = d[26:23];
    // assign aluOperandA = d[22:19];
    // assign aluOperandB = d[18:16];
    // assign aluResultStorage = d[15:12];
    // assign incrementAddr = d[11];
    // assign uSeqBranchCondition = d[10];
    // assign uSeqBranchAddr = d[9:0];
    
    myfile << std::hex << std::setw(8) << std::setfill('0') << std::uppercase;
    
    for (unsigned int i = 0; i <= 0x3FF; ++i)
    {
        _uut.address = i;
        _uut.clock = 0;
        _uut.eval();
        
        uint32_t microcodeWord =    _uut.addrBusMux << 30 |
                                    _uut.dataBusWriteEnable << 29 |
                                    _uut.dataBusMux << 27 |
                                    _uut.aluOperation << 23 |
                                    _uut.aluOperandA << 19 |
                                    _uut.aluOperandB << 16 |
                                    _uut.aluResultStorage << 12 |
                                    _uut.incrementAddr << 11 |
                                    _uut.uSeqBranchCondition << 10 |
                                    _uut.uSeqBranchAddr;
        myfile << microcodeWord << std::endl;
        
        _uut.clock = 1;
        _uut.eval();
    }
    
    myfile.close();
}