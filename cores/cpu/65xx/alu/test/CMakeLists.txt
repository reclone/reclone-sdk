add_executable(testCpu65xxAlu Cpu65xxAluTests.cpp)

target_link_libraries(testCpu65xxAlu VCpu65xxAlu gtest gmock_main gmock)

add_test(NAME testCpu65xxAlu COMMAND testCpu65xxAlu)
