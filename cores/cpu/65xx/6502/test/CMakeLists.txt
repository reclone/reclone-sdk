include(perfect6502.cmake)

add_executable(testCpu6502 Cpu6502Tests.cpp)

target_link_libraries(testCpu6502 perfect6502 VCpu6502 gtest gmock_main gmock)

add_test(NAME testCpu6502 COMMAND testCpu6502)

