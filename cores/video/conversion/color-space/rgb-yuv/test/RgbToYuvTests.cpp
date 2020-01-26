//
// RgbToYuvTests - Unit tests for verilated RgbToYuv module
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
#include "VRgbToYuv.h"

class RgbToYuvTests : public ::testing::Test
{
    public:
        RgbToYuvTests() { }
        virtual ~RgbToYuvTests()
        {
            _uut.final();
        }
        
    protected:
        VRgbToYuv _uut;
};

TEST_F(RgbToYuvTests, CheckAllOutputValues)
{
    for (unsigned int r = 0; r <= 255; ++r)
    {
        for (unsigned int g = 0; g <= 255; ++g)
        {
            for (unsigned int b = 0; b <= 255; ++b)
            {
                _uut.r = r;
                _uut.g = g;
                _uut.b = b;
                
                _uut.eval();
                
                // Y =  0.299R + 0.587G + 0.114B
                double expected_y_float = 0.299 * r + 0.587 * g + 0.114 * b;
                unsigned int expected_y = static_cast<unsigned int>(round(expected_y_float));
                
                // U = -0.147R - 0.289G + 0.436B
                double expected_u_float = -0.147 * r - 0.289 * g + 0.436 * b;
                int expected_u = static_cast<int>(round(expected_u_float));
                int signed_u = (_uut.u & 0x100) ? _uut.u - 512 : _uut.u;
                
                // V =  0.615R - 0.515G - 0.100B
                double expected_v_float = 0.615 * r - 0.515 * g - 0.100 * b;
                int expected_v = static_cast<int>(round(expected_v_float));
                int signed_v = (_uut.v & 0x100) ? _uut.v - 512 : _uut.v;
                
                ASSERT_NEAR(expected_y, _uut.y, 1) << r << " " << g << " " << b << " " << (expected_y_float) << " " << static_cast<unsigned int>(_uut.y);
                ASSERT_NEAR(expected_u, signed_u, 1) << r << " " << g << " " << b << " " << (expected_u_float) << " " << _uut.u;
                ASSERT_NEAR(expected_v, signed_v, 1) << r << " " << g << " " << b << " " << (expected_v_float) << " " << _uut.v;
            }
        }
    }
}