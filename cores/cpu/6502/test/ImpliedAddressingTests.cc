#include "gtest/gtest.h"

class ImpliedAddressingTests : public ::testing::Test
{
    public:
        ImpliedAddressingTests() { }
        virtual ~ImpliedAddressingTests() { }
};

TEST_F(ImpliedAddressingTests, AssertPasses)
{
    ASSERT_TRUE(true);
}