//
// Cpu6502Tests - Unit tests for verilated Cpu6502 module
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
#include <array>
#include <vector>
#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "gmock/gmock.h"
#include "VCpu6502.h"

// From perfect6502
extern "C"
{
#include "types.h"
#include "perfect6502.h"
#include "netlist_sim.h"
}

using namespace ::testing;

class Cpu6502Tests : public Test
{
    public:
        Cpu6502Tests() : _tickCount(1), _perfect6502state(nullptr)
        {
            Verilated::traceEverOn(true);
            _perfect6502state = initAndResetChip();
        }
        
        virtual ~Cpu6502Tests()
        {
            destroyChip(_perfect6502state);
            _uut.final();
        }
        
        // Run a small 6502 program on both Cpu6502 and perfect6502 in lock-step,
        // verifying that address and data busses behave the same
        void lockStepExec(const std::vector<uint8_t>& program, uint16_t org)
        {
            _uut.trace(&_vcdTrace, 99);
            _vcdTrace.open("6502.vcd");
            
            // Initialize memory to zeros (BRK)
            for (unsigned int i = 0; i < _uutMem.size(); ++i)
            {
                memory[i] = 0;
                _uutMem[i] = 0;
            }
            
            // Load program to org address
            for (unsigned int i = 0; i < program.size(); ++i)
            {
                memory[i + org] = program[i];
                _uutMem[i + org] = program[i];
            }
            
            // Set reset vector to org address
            memory[0xFFFC] = org & 0xFF;
            _uutMem[0xFFFC] = org & 0xFF;
            memory[0xFFFD] = (org >> 8) & 0xFF;
            _uutMem[0xFFFD] = (org >> 8) & 0xFF;
            
            // Initialize _uut inputs
            _uut.reset = 0;
            _uut.nRESET = 1;
            _uut.nNMI = 1;
            _uut.nIRQ = 1;
            _uut.dataIn = 0;
            _uut.enable = 1;
            _uut.clock = 1;
            _uut.eval();
            _vcdTrace.dump(_tickCount++);
            
            //uint16_t pc = 0xFFFF;
            uint16_t addr = 0xFFFF;
            int rw = 1;
            const uint16_t IRQ_VECTOR = 0xFFFE;
            
            for (int i = 0; i < 120000000 && addr != IRQ_VECTOR; ++i)
            {
                step(_perfect6502state);
                _uut.clock = !_uut.clock;
                _uut.eval();
                
                //pc = readPC(_perfect6502state);
                addr = readAddressBus(_perfect6502state);
                rw = readRW(_perfect6502state);
                ASSERT_EQ(addr, _uut.address);
                ASSERT_EQ(rw, _uut.nWrite);
                
                // Supply data from memory
                _uut.dataIn = _uutMem[_uut.address];
                
                _vcdTrace.dump(_tickCount++);
                chipStatus(_perfect6502state);
                
                if (rw == 0)
                {
                    // Write on clock rising edge
                    if (_uut.clock == 1)
                    {
                        // Write
                        _uutMem[_uut.address] = _uut.dataOut;
                        
                        // Validate written data on clock rising edge only
                        ASSERT_EQ(readDataBus(_perfect6502state), _uut.dataOut);
                    }
                }
            }

            EXPECT_TRUE(IRQ_VECTOR == addr);
            EXPECT_EQ(0x00, readA(_perfect6502state));

            //_vcdTrace.close();
        }
        
    protected:
        VerilatedVcdC _vcdTrace;
        VCpu6502 _uut;
        unsigned int _tickCount;
        state_t * _perfect6502state;
        std::array<uint8_t, 0x10000> _uutMem;
        

};

TEST_F(Cpu6502Tests, Startup)
{
    //_uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("6502.vcd");
    
    _uut.reset = 0;
    _uut.nRESET = 1;
    _uut.nNMI = 1;
    _uut.nIRQ = 1;
    _uut.dataIn = 0;
    _uut.enable = 1;
    _uut.clock = 1;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        step(_perfect6502state);
        //chipStatus(_perfect6502state);
        _uut.clock = !_uut.clock;
        _uut.eval();
        //_vcdTrace.dump(_tickCount++);
    }
    
    // Load the first byte of the reset vector

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0xAA);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    _uut.dataIn = 0xAA;
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0xAA);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);
    
    // Load the second byte of the reset vector
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x55);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    _uut.dataIn = 0x55;
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x55);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    
    // Fetch the first opcode
    
    step(_perfect6502state);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0x55AA, readAddressBus(_perfect6502state));
    ASSERT_EQ(0x55AA, _uut.address);
    
    step(_perfect6502state);
    //chipStatus(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    ASSERT_EQ(0x55AA, readAddressBus(_perfect6502state));
    ASSERT_EQ(0x55AA, _uut.address);
    
    //_vcdTrace.close();
}

// WARNING: This test will take >3 hours and 192482763 half-cycles, therefore
// it is disabled by default.
TEST_F(Cpu6502Tests, DISABLED_FunctionalSelfTest_Perfect6502Only)
{
    // Load the functional test program into 6502 memory
    std::ifstream fin;
    fin.open ("6502_functional_test.bin", std::ios::in | std::ios::binary);
    fin.read(reinterpret_cast<char*>(memory),65536);
    ASSERT_TRUE(fin.good());
    fin.close();
    
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        step(_perfect6502state);
    }
    
    // Load the first byte of the reset vector

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    
    // Load the second byte of the reset vector
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x04);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x04);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    
    uint16_t pc = 0xFFFF;
    uint16_t addr = 0xFFFF;
    int rw = 1;
    const uint16_t SUCCESS = 0x3469;
    //const uint16_t BINARY_ADD_INC_AD1 = 0x3345;
    //const uint16_t BINARY_ADD_INC_AD2 = 0x3350;
    //const uint16_t AD1 = 0x000D;
    const uint16_t AD2 = 0x000E;
    for (int i = 0; i < 200000000 && pc != SUCCESS; ++i)
    {
        step(_perfect6502state);
        pc = readPC(_perfect6502state);
        addr = readAddressBus(_perfect6502state);
        rw = readRW(_perfect6502state);
        if (rw == 0 && addr == AD2)
        {
            // This is printed as a progress indicator for the ADC/SBC tests
            // that cover every possible combination of operands and carry flag
            chipStatus(_perfect6502state);
        }
    }
    
    EXPECT_EQ(SUCCESS, pc);
    
    for (int i = 0; i < 20; ++i)
    {
        step(_perfect6502state);
        chipStatus(_perfect6502state);
    }
}

// WARNING: This test will take >3 hours and 192482763 half-cycles, therefore
// it is disabled by default.
TEST_F(Cpu6502Tests, DISABLED_FunctionalSelfTest_LockStep)
{
    //_uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("6502.vcd");
    
    // Load the functional test program into 6502 memory
    std::ifstream fin;
    fin.open ("6502_functional_test.bin", std::ios::in | std::ios::binary);
    fin.read(reinterpret_cast<char*>(memory),65536);
    ASSERT_TRUE(fin.good());
    fin.close();
    std::copy(std::begin(memory), std::end(memory), _uutMem.begin());
    
    // Initialize _uut inputs
    _uut.reset = 0;
    _uut.nRESET = 1;
    _uut.nNMI = 1;
    _uut.nIRQ = 1;
    _uut.dataIn = 0;
    _uut.enable = 1;
    _uut.clock = 1;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        step(_perfect6502state);
        _uut.clock = !_uut.clock;
        _uut.eval();
        //_vcdTrace.dump(_tickCount++);
    }
    
    // Load the first byte of the reset vector

    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);

    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);
    _uut.dataIn = 0x00;
    
    // Load the second byte of the reset vector
    
    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x04);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    
    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x04);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    _uut.dataIn = 0x04;
    
    uint16_t pc = 0xFFFF;
    uint16_t addr = 0xFFFF;
    int rw = 1;
    const uint16_t SUCCESS = 0x3469;
    //const uint16_t BINARY_ADD_INC_AD1 = 0x3345;
    //const uint16_t BINARY_ADD_INC_AD2 = 0x3350;
    //const uint16_t AD1 = 0x000D;
    const uint16_t AD2 = 0x000E;
    for (int i = 0; i < 200000000 && pc != SUCCESS; ++i)
    {
        // Run the half cycles
        step(_perfect6502state);
        _uut.clock = !_uut.clock;
        _uut.eval();
        //_vcdTrace.dump(_tickCount++);
        
        //chipStatus(_perfect6502state);
/*         std::cout   << std::hex << std::setw(2) << std::setfill('0') << std::uppercase
                    << "A:" << static_cast<unsigned int>(_uut.Cpu6502__DOT__uArch__DOT__regA)
                    << " X:" << static_cast<unsigned int>(_uut.Cpu6502__DOT__uArch__DOT__regX)
                    << " Y:" << static_cast<unsigned int>(_uut.Cpu6502__DOT__uArch__DOT__regY)
                    << " SP:" << static_cast<unsigned int>(_uut.Cpu6502__DOT__uArch__DOT__regS)
                    << " P:" << static_cast<unsigned int>(_uut.Cpu6502__DOT__uArch__DOT__regP)
                    << "\n"; */
        
        // Grab register values from perfect6502
        pc = readPC(_perfect6502state);
        addr = readAddressBus(_perfect6502state);
        rw = readRW(_perfect6502state);
        ASSERT_EQ(addr, _uut.address) << "uCodeAddress=" << _uut.Cpu6502__DOT__uCodeAddress;
        ASSERT_EQ(rw, _uut.nWrite);
        // Supply data from memory
        _uut.dataIn = _uutMem[_uut.address];
        
        if (rw == 0)
        {
            // Write on clock rising edge
            if (_uut.clock == 1)
            {
                // Write
                _uutMem[_uut.address] = _uut.dataOut;
                
                // Validate written data on clock rising edge only
                ASSERT_EQ(readDataBus(_perfect6502state), _uut.dataOut)
                    << "uCodeAddress=" << _uut.Cpu6502__DOT__uCodeAddress
                    << " clock=" << _uut.clock;
            }
            
            if (addr == AD2)
            {
                // This is printed as a progress indicator for the ADC/SBC tests
                // that cover every possible combination of operands and carry flag
                chipStatus(_perfect6502state);
            }
        }
    }
    
    EXPECT_EQ(SUCCESS, pc);
    chipStatus(_perfect6502state);
    
    //_vcdTrace.close();
}

TEST_F(Cpu6502Tests, FunctionalSelfTest_Cpu6502Only)
{
    // Load the functional test program into 6502 memory
    std::ifstream fin;
    fin.open ("6502_functional_test.bin", std::ios::in | std::ios::binary);
    fin.read(reinterpret_cast<char*>(memory),65536);
    ASSERT_TRUE(fin.good());
    fin.close();
    std::copy(std::begin(memory), std::end(memory), _uutMem.begin());
    
    // Initialize _uut inputs
    _uut.reset = 0;
    _uut.nRESET = 1;
    _uut.nNMI = 1;
    _uut.nIRQ = 1;
    _uut.dataIn = 0;
    _uut.enable = 1;
    _uut.clock = 1;
    _uut.eval();
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        _uut.clock = !_uut.clock;
        _uut.eval();
    }
    
    // Load the first byte of the reset vector

    _uut.clock = !_uut.clock;
    _uut.eval();
    ASSERT_EQ(0xFFFC, _uut.address);

    _uut.clock = !_uut.clock;
    _uut.eval();
    ASSERT_EQ(0xFFFC, _uut.address);
    _uut.dataIn = 0x00;
    
    // Load the second byte of the reset vector
    
    _uut.clock = !_uut.clock;
    _uut.eval();
    ASSERT_EQ(0xFFFD, _uut.address);
    
    _uut.clock = !_uut.clock;
    _uut.eval();
    ASSERT_EQ(0xFFFD, _uut.address);
    _uut.dataIn = 0x04;
    
    uint16_t pc = 0xFFFF;
    uint16_t addr = 0xFFFF;
    int rw = 1;
    const uint16_t SUCCESS = 0x3469;
    const uint16_t AD2 = 0x000E;
    for (int i = 0; i < 200000000 && pc != SUCCESS; ++i)
    {
        // Run the half cycles
        _uut.clock = !_uut.clock;
        _uut.eval();
        
        pc = _uut.Cpu6502__DOT__uArch__DOT__regPC;
        addr = _uut.address;
        rw = _uut.nWrite;
        
        // Supply data from memory
        _uut.dataIn = _uutMem[_uut.address];
        
        if (rw == 0)
        {
            // Write on clock rising edge
            if (_uut.clock == 1)
            {
                // Write
                _uutMem[_uut.address] = _uut.dataOut;
            }
            
            if (addr == AD2)
            {
                // This can be printed as a progress indicator for the ADC/SBC tests
                // that cover every possible combination of operands and carry flag
                //std::cout << std::hex << std::setw(2) << std::setfill('0') << std::uppercase
                //          << static_cast<unsigned int>(_uut.dataOut) << " ";
            }
        }
    }
    
    EXPECT_EQ(SUCCESS, pc);
}

// WARNING: This test will take >1.5 hours and 107907644 half-cycles, therefore
// it is disabled by default.
TEST_F(Cpu6502Tests, DISABLED_DecimalModeTest_Perfect6502Only)
{
    // Load the decimal mode test program into 6502 memory
    std::ifstream fin;
    fin.open ("6502_decimal_test.bin", std::ios::in | std::ios::binary);
    fin.read(reinterpret_cast<char*>(memory),65536);
    ASSERT_TRUE(fin.good());
    fin.close();
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        step(_perfect6502state);
    }
    
    // Load the first byte of the reset vector

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));

    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    
    // Load the second byte of the reset vector
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x02);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    
    step(_perfect6502state);
    writeDataBus(_perfect6502state, 0x02);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    
    uint16_t pc = 0xFFFF;
    uint16_t addr = 0xFFFF;
    int rw = 1;
    const uint16_t DONE = 0x024B;
    const uint16_t N2 = 0x0001;

    for (int i = 0; i < 120000000 && pc != DONE; ++i)
    {
        step(_perfect6502state);
        pc = readPC(_perfect6502state);
        addr = readAddressBus(_perfect6502state);
        rw = readRW(_perfect6502state);
        //chipStatus(_perfect6502state);
        if (rw == 0 && addr == N2)
        {
            // This is printed as a progress indicator for the decimal tests
            // that cover every possible combination of operands and carry flag
            chipStatus(_perfect6502state);
        }
    }
    
    EXPECT_EQ(DONE, pc);
    EXPECT_EQ(0x00, readA(_perfect6502state));
}

// WARNING: This test will take >1.5 hours and 107907644 half-cycles, therefore
// it is disabled by default.
TEST_F(Cpu6502Tests, DISABLED_DecimalModeTest_LockStep)
{
    //_uut.trace(&_vcdTrace, 99);
    //_vcdTrace.open("6502.vcd");
    
    // Load the functional test program into 6502 memory
    std::ifstream fin;
    fin.open ("6502_decimal_test.bin", std::ios::in | std::ios::binary);
    fin.read(reinterpret_cast<char*>(memory),65536);
    ASSERT_TRUE(fin.good());
    fin.close();
    std::copy(std::begin(memory), std::end(memory), _uutMem.begin());
    
    // Initialize _uut inputs
    _uut.reset = 0;
    _uut.nRESET = 1;
    _uut.nNMI = 1;
    _uut.nIRQ = 1;
    _uut.dataIn = 0;
    _uut.enable = 1;
    _uut.clock = 1;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        step(_perfect6502state);
        _uut.clock = !_uut.clock;
        _uut.eval();
        //_vcdTrace.dump(_tickCount++);
    }
    
    // Load the first byte of the reset vector

    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);

    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFC, _uut.address);
    _uut.dataIn = 0x00;
    
    // Load the second byte of the reset vector
    
    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x02);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    
    step(_perfect6502state);
    _uut.clock = !_uut.clock;
    _uut.eval();
    //_vcdTrace.dump(_tickCount++);
    writeDataBus(_perfect6502state, 0x02);
    ASSERT_EQ(0xFFFD, readAddressBus(_perfect6502state));
    ASSERT_EQ(0xFFFD, _uut.address);
    _uut.dataIn = 0x02;
    
    // Sync the stack pointer
    _uut.Cpu6502__DOT__uArch__DOT__regS = readSP(_perfect6502state);
    
    uint16_t pc = 0xFFFF;
    uint16_t addr = 0xFFFF;
    int rw = 1;
    const uint16_t DONE = 0x024B;
    const uint16_t N2 = 0x0001;
    
    for (int i = 0; i < 120000000 && pc != DONE; ++i)
    {
        step(_perfect6502state);
        _uut.clock = !_uut.clock;
        _uut.eval();
        
        pc = readPC(_perfect6502state);
        addr = readAddressBus(_perfect6502state);
        rw = readRW(_perfect6502state);
        ASSERT_EQ(addr, _uut.address) << "uCodeAddress=" << _uut.Cpu6502__DOT__uCodeAddress;
        ASSERT_EQ(rw, _uut.nWrite);
        // Supply data from memory
        _uut.dataIn = _uutMem[_uut.address];
        
        //_vcdTrace.dump(_tickCount++);
        //chipStatus(_perfect6502state);
        
        if (rw == 0)
        {
            // Write on clock rising edge
            if (_uut.clock == 1)
            {
                // Write
                _uutMem[_uut.address] = _uut.dataOut;
                
                // Validate written data on clock rising edge only
                ASSERT_EQ(readDataBus(_perfect6502state), _uut.dataOut)
                    << "uCodeAddress=" << _uut.Cpu6502__DOT__uCodeAddress
                    << " clock=" << _uut.clock;
            }
            
            if (addr == N2)
            {
                // This is printed as a progress indicator for the decimal tests
                // that cover every possible combination of operands and carry flag
                chipStatus(_perfect6502state);
            }
        }
    }
    
    EXPECT_EQ(DONE, pc);
    EXPECT_EQ(0x00, readA(_perfect6502state));
    
    //_vcdTrace.close();
}

TEST_F(Cpu6502Tests, DecimalModeTest_Cpu6502Only)
{
    // Load the functional test program into 6502 memory
    std::ifstream fin;
    fin.open ("6502_decimal_test.bin", std::ios::in | std::ios::binary);
    fin.read(reinterpret_cast<char*>(memory),65536);
    ASSERT_TRUE(fin.good());
    fin.close();
    std::copy(std::begin(memory), std::end(memory), _uutMem.begin());
    
    // Initialize _uut inputs
    _uut.reset = 0;
    _uut.nRESET = 1;
    _uut.nNMI = 1;
    _uut.nIRQ = 1;
    _uut.dataIn = 0;
    _uut.enable = 1;
    _uut.clock = 1;
    _uut.eval();
    
    // Check nothing first 6 cycles
    for (unsigned int i = 0; i < 12; ++i)
    {
        _uut.clock = !_uut.clock;
        _uut.eval();
    }
    
    // Load the first byte of the reset vector

    _uut.clock = !_uut.clock;
    _uut.eval();
    writeDataBus(_perfect6502state, 0x00);
    ASSERT_EQ(0xFFFC, _uut.address);

    _uut.clock = !_uut.clock;
    _uut.eval();
    ASSERT_EQ(0xFFFC, _uut.address);
    _uut.dataIn = 0x00;
    
    // Load the second byte of the reset vector
    
    _uut.clock = !_uut.clock;
    _uut.eval();
    ASSERT_EQ(0xFFFD, _uut.address);
    
    _uut.clock = !_uut.clock;
    _uut.eval();
    ASSERT_EQ(0xFFFD, _uut.address);
    _uut.dataIn = 0x02;
    
    uint16_t pc = 0xFFFF;
    uint16_t addr = 0xFFFF;
    int rw = 1;
    const uint16_t DONE = 0x024B;
    const uint16_t N2 = 0x0001;
    
    for (int i = 0; i < 120000000 && pc != DONE; ++i)
    {
        _uut.clock = !_uut.clock;
        _uut.eval();
        
        pc = _uut.Cpu6502__DOT__uArch__DOT__regPC;
        addr = _uut.address;
        rw = _uut.nWrite;
        
        // Supply data from memory
        _uut.dataIn = _uutMem[_uut.address];
        
        if (rw == 0)
        {
            // Write on clock rising edge
            if (_uut.clock == 1)
            {
                // Write
                _uutMem[_uut.address] = _uut.dataOut;
            }
            
            if (addr == N2)
            {
                // This can be printed as a progress indicator for the ADC/SBC tests
                // that cover every possible combination of operands and carry flag
                //std::cout << std::hex << std::setw(2) << std::setfill('0') << std::uppercase
                //          << static_cast<unsigned int>(_uut.dataOut) << " ";
            }
        }
    }
    
    EXPECT_EQ(DONE, pc);
    EXPECT_EQ(0x00, readA(_perfect6502state));
    
    //_vcdTrace.close();
}

TEST_F(Cpu6502Tests, Opcode_NOP)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xEA                // NOP
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_1A)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x1A                // NOP_1A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_3A)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x3A                // NOP_3A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_5A)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x5A                // NOP_5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_7A)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x7A                // NOP_7A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_DA)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xDA                // NOP_DA
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_FA)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xFA                // NOP_FA
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_80)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x80, 0x5A          // NOP_80 #$5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_82)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x82, 0x5A          // NOP_82 #$5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_C2)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xC2, 0x5A          // NOP_C2 #$5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_E2)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xE2, 0x5A          // NOP_E2 #$5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_89)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x89, 0x5A          // NOP_89 #$5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_04)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x04, 0x5A          // NOP_04 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_44)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x44, 0x5A          // NOP_44 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_64)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x64, 0x5A          // NOP_64 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_14)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x14, 0x5A          // NOP_14 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_34)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x34, 0x5A          // NOP_34 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_54)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x54, 0x5A          // NOP_54 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_74)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x74, 0x5A          // NOP_74 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_D4)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0xD4, 0x5A          // NOP_D4 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_F4)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0xF4, 0x5A          // NOP_F4 $5A
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_0C)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0x0C, 0x0D, 0xDC    // NOP_0C $DC0D
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_1C)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x1C, 0xA0, 0x0A,   // NOP_1C $0AA0
        0x1C, 0x0B, 0xB0    // NOP_1C $B00B
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_3C)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x3C, 0xA0, 0x0A,   // NOP_3C $0AA0
        0x3C, 0x0B, 0xB0    // NOP_3C $B00B
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_5C)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x5C, 0xA0, 0x0A,   // NOP_5C $0AA0
        0x5C, 0x0B, 0xB0    // NOP_5C $B00B
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_7C)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0x7C, 0xA0, 0x0A,   // NOP_7C $0AA0
        0x7C, 0x0B, 0xB0    // NOP_7C $B00B
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_DC)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0xDC, 0xA0, 0x0A,   // NOP_DC $0AA0
        0xDC, 0x0B, 0xB0    // NOP_DC $B00B
    };
    
    lockStepExec(testProgram, org);
}

TEST_F(Cpu6502Tests, Opcode_NOP_FC)
{
    const uint16_t org = 0x0400;
    const std::vector<uint8_t> testProgram
    {
        0xA2, 0x83,         // LDX #$83
        0xFC, 0xA0, 0x0A,   // NOP_FC $0AA0
        0xFC, 0x0B, 0xB0    // NOP_FC $B00B
    };
    
    lockStepExec(testProgram, org);
}

