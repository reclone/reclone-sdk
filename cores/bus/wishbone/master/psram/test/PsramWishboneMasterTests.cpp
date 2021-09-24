//
// PsramWishboneMasterTests - Unit tests for verilated PsramWishboneMaster module
//
//
// Copyright 2021 Reclone Labs <reclonelabs.com>
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

#include <utility>
#include <vector>
#include <math.h>
#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VPsramWishboneMaster.h"

class PsramWishboneMasterTests : public ::testing::Test
{
    public:
        PsramWishboneMasterTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~PsramWishboneMasterTests()
        {
            _uut.final();
        }
        
    protected:
        VPsramWishboneMaster _uut;
        unsigned int _tickCount;
        
        struct testInputs
        {
            uint32_t psramA;
            uint16_t psramAD;
            bool psramNE;
            bool psramNOE;
            bool psramNWE;
            bool psramNADV;
            bool psramNUB;
            bool psramNLB;
            bool RST_I;
            bool CLK_I;
            bool STALL_I;
            bool ACK_I;
            bool ERR_I;
            uint16_t DAT_I;
        };
        
        struct testOutputs
        {
            uint16_t psramAD;
            bool psramNWAIT;
            bool CYC_O;
            bool STB_O;
            uint32_t ADR_O;
            bool DAT_O;
            bool WE_O;
            uint8_t SEL_O;
        };
        
        void runTestVector(VerilatedVcdC & vcd_trace, std::vector<std::pair<struct testInputs, struct testOutputs>> tv);
};

void PsramWishboneMasterTests::runTestVector(VerilatedVcdC & vcd_trace, std::vector<std::pair<struct testInputs, struct testOutputs>> tv)
{
    SCOPED_TRACE("PsramWishboneMasterTests::runTestVector");
    for (std::size_t i = 0; i < tv.size(); ++i)
    {
        SCOPED_TRACE(i);
        
        _uut.psramA = tv[i].first.psramA;
        _uut.psramAD = tv[i].first.psramAD;
        _uut.psramNE = tv[i].first.psramNE;
        _uut.psramNOE = tv[i].first.psramNOE;
        _uut.psramNWE = tv[i].first.psramNWE;
        _uut.psramNADV = tv[i].first.psramNADV;
        _uut.psramNUB = tv[i].first.psramNUB;
        _uut.psramNLB = tv[i].first.psramNLB;
        _uut.RST_I = tv[i].first.RST_I;
        _uut.CLK_I = tv[i].first.CLK_I;
        _uut.STALL_I = tv[i].first.STALL_I;
        _uut.ACK_I = tv[i].first.ACK_I;
        _uut.ERR_I = tv[i].first.ERR_I;
        _uut.DAT_I = tv[i].first.DAT_I;
        
        _uut.eval();
        vcd_trace.dump(_tickCount++);
        
        EXPECT_EQ(tv[i].second.psramAD, _uut.psramAD);
        EXPECT_EQ(tv[i].second.psramNWAIT, _uut.psramNWAIT);
        EXPECT_EQ(tv[i].second.CYC_O, _uut.CYC_O);
        EXPECT_EQ(tv[i].second.STB_O, _uut.STB_O);
        EXPECT_EQ(tv[i].second.ADR_O, _uut.ADR_O);
        EXPECT_EQ(tv[i].second.DAT_O, _uut.DAT_O);
        EXPECT_EQ(tv[i].second.WE_O, _uut.WE_O);
        EXPECT_EQ(tv[i].second.SEL_O, _uut.SEL_O);
    }
}

TEST_F(PsramWishboneMasterTests, ReadAsync16bit)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PsramWishboneMaster_ReadAsync16bit.vcd");

    runTestVector
    (
        vcd_trace,
        {
            // Initial
            {{0,0,1,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            // Assert NE and ADV
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // De-assert NADV
            {{0,0,0,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // Assert NOE
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,1,1,1,0x2E6006,0,0,3}},
            // Async Read Ack
            {{0,0,0,0,1,1,0,0,0,0,0,1,0,0xCAB1},{0,1,1,1,0x2E6006,0,0,3}},
            {{0,0,0,0,1,1,0,0,0,1,0,1,0,0xCAB1},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            // De-assert NOE and NE
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
        }
    );

    vcd_trace.close();
}

TEST_F(PsramWishboneMasterTests, ReadSync16bit)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PsramWishboneMaster_ReadSync16bit.vcd");

    runTestVector
    (
        vcd_trace,
        {
            // Initial
            {{0,0,1,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            // Assert NE and ADV
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // De-assert NADV
            {{0,0,0,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // Assert NOE
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // CYC and STB
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,1,1,1,0x2E6006,0,0,3}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,1,1,1,0x2E6006,0,0,3}},
            // NWAIT asserts
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            // Sync Read Ack, NWAIT de-asserts
            {{0,0,0,0,1,1,0,0,0,0,0,1,0,0xCAB1},{0,1,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,1,0,0xCAB1},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            // De-assert NOE and NE
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
        }
    );

    vcd_trace.close();
}

TEST_F(PsramWishboneMasterTests, ReadSync16bitDelayedAck)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PsramWishboneMaster_ReadSync16bitDelayedAck.vcd");

    runTestVector
    (
        vcd_trace,
        {
            // Initial
            {{0,0,1,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            // Assert NE and ADV
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // De-assert NADV
            {{0,0,0,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // Assert NOE
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // CYC and STB
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,1,1,1,0x2E6006,0,0,3}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,1,1,1,0x2E6006,0,0,3}},
            // NWAIT asserts, ACK is delayed
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            // Sync Read Ack
            {{0,0,0,0,1,1,0,0,0,0,0,1,0,0xCAB1},{0,1,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,1,0,0xCAB1},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xCAB1,1,0,0,0x2E6006,0,0,0}},
            // De-assert NOE and NE
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
        }
    );

    vcd_trace.close();
}

TEST_F(PsramWishboneMasterTests, ReadSync16bitDelayedErr)
{
    VerilatedVcdC vcd_trace;
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("PsramWishboneMaster_ReadSync16bitDelayedErr.vcd");

    runTestVector
    (
        vcd_trace,
        {
            // Initial
            {{0,0,1,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            // Assert NE and ADV
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0x2E,0x6006,0,1,1,0,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // De-assert NADV
            {{0,0,0,1,1,1,1,1,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,1,1,1,1,1,0,1,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // Assert NOE
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            // CYC and STB
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,1,1,1,0x2E6006,0,0,3}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,1,1,1,0x2E6006,0,0,3}},
            // NWAIT asserts, ACK is delayed
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0,0,1,0,0x2E6006,0,0,0}},
            // Sync Read Ack
            {{0,0,0,0,1,1,0,0,0,0,0,0,1,0xCAB1},{0,1,1,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,1,0xCAB1},{0xDEAD,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xDEAD,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xDEAD,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,0,0,0,0,0},{0xDEAD,1,0,0,0x2E6006,0,0,0}},
            {{0,0,0,0,1,1,0,0,0,1,0,0,0,0},{0xDEAD,1,0,0,0x2E6006,0,0,0}},
            // De-assert NOE and NE
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0x2E6006,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0}},
            {{0,0,1,1,1,1,0,0,0,1,0,0,0,0},{0,1,0,0,0,0,0,0}},
        }
    );

    vcd_trace.close();
}


