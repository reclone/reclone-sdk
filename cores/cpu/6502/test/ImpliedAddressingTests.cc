#include "gtest/gtest.h"
#include "Vcpu_6502.h"

class ImpliedAddressingTests : public ::testing::Test
{
    public:
        ImpliedAddressingTests() { }
        virtual ~ImpliedAddressingTests()
        {
            _uut.final();
        }
        
    protected:
        Vcpu_6502 _uut;
};

TEST_F(ImpliedAddressingTests, AssertPasses)
{
    ASSERT_TRUE(true);
}

// TEST_F(ImpliedAddressingTests, AssertFails)
// {
    // ASSERT_TRUE(false);
// }

// TEST_F(ImpliedAddressingTests, CountUp)
// {
    // _uut.clk = 0;
    // _uut.reset = 1;
    // _uut.enable = 1;
    // _uut.eval();
    // _uut.eval();
    
    // _uut.clk = 1;
    // _uut.eval();
    // EXPECT_EQ(0, _uut.out);
    
    // _uut.reset = 0;
    // _uut.clk = 0;
    // _uut.eval();
    // _uut.clk = 1;
    // _uut.eval();
    // EXPECT_EQ(1, _uut.out);
    
    // _uut.clk = 0;
    // _uut.eval();
    // _uut.clk = 1;
    // _uut.eval();
    // EXPECT_EQ(2, _uut.out);

// }