configure_file(6502_functional_test.bin ${CMAKE_BINARY_DIR}/6502_functional_test.bin COPYONLY)
configure_file(6502_functional_test.bin ${CMAKE_CURRENT_BINARY_DIR}/6502_functional_test.bin COPYONLY)
configure_file(6502_decimal_test.bin ${CMAKE_BINARY_DIR}/6502_decimal_test.bin COPYONLY)
configure_file(6502_decimal_test.bin ${CMAKE_CURRENT_BINARY_DIR}/6502_decimal_test.bin COPYONLY)

include(perfect6502.cmake)

add_executable(testCpu6502 Cpu6502Tests.cpp Cpu6502MicrocodeRomTests.cpp)

target_link_libraries(testCpu6502 perfect6502 VCpu6502 VCpu6502MicrocodeRom gtest gmock_main gmock)

add_test(NAME testCpu6502 COMMAND testCpu6502)

