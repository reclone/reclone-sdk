add_executable(testCpu6502 ImpliedAddressingTests.cc)

target_link_libraries(testCpu6502 cpu6502 gtest gtest_main pthread)