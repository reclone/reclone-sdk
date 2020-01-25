//
// RgbToYiqTests - Unit tests for verilated RgbToYiq module
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
#include "VRgbToYiq.h"

class RgbToYiqTests : public ::testing::Test
{
    public:
        RgbToYiqTests() { }
        virtual ~RgbToYiqTests()
        {
            _uut.final();
        }
        
    protected:
        VRgbToYiq _uut;
};

TEST_F(RgbToYiqTests, CheckAllOutputValues)
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
                
                double expected_y_float = 0.299 * r + 0.587 * g + 0.114 * b;
                unsigned int expected_y = static_cast<unsigned int>(round(expected_y_float));
                ASSERT_NEAR(expected_y, _uut.y, 1) << r << " " << g << " " << b << " " << (expected_y_float)
                    << (((9848226U * g + 0x800000) >> 24) + ((1912603U * b + 0x800000) >> 24));
            }
        }
    }
}