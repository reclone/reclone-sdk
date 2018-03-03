
add_custom_command (
  OUTPUT  VCpu6502.cpp
          VCpu6502.h
          VCpu6502__Syms.cpp
          VCpu6502__Syms.h
  DEPENDS Cpu6502.v
          Cpu6502Decode.v
          Cpu6502DecodeRom.v
          ${PROJECT_SOURCE_DIR}/memory/register/src/RegisterFile2Read1Write.v
          ${PROJECT_SOURCE_DIR}/memory/register/src/Register.v
          ${PROJECT_SOURCE_DIR}/counter/one-hot/src/OneHotCounter.v
  COMMAND perl ${VERILATOR} -Wall -Mdir ${CMAKE_CURRENT_BINARY_DIR} -cc
    ${CMAKE_CURRENT_SOURCE_DIR}/Cpu6502.v
    ${CMAKE_CURRENT_SOURCE_DIR}/Cpu6502Decode.v
    ${CMAKE_CURRENT_SOURCE_DIR}/Cpu6502DecodeRom.v
    ${PROJECT_SOURCE_DIR}/memory/register/src/RegisterFile2Read1Write.v
    ${PROJECT_SOURCE_DIR}/memory/register/src/Register.v
    ${PROJECT_SOURCE_DIR}/counter/one-hot/src/OneHotCounter.v
)

add_library (cpu6502 STATIC VCpu6502.cpp VCpu6502__Syms.cpp)

target_compile_options(cpu6502 PRIVATE ${VK_CPPFLAGS})

target_include_directories(cpu6502 PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(cpu6502 verilated)
