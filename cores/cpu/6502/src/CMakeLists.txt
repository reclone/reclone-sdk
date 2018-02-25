
add_custom_command (
  OUTPUT  VCpu6502.cpp
          VCpu6502.h
          VCpu6502__Syms.cpp
          VCpu6502__Syms.h
  DEPENDS Cpu6502.v
          ${PROJECT_SOURCE_DIR}/memory/register/src/RegisterFile2Read1Write.v
          ${PROJECT_SOURCE_DIR}/memory/register/src/Register.v
  COMMAND perl ${VERILATOR} -Wall -Mdir ${CMAKE_CURRENT_BINARY_DIR} -cc
    ${CMAKE_CURRENT_SOURCE_DIR}/Cpu6502.v
    ${PROJECT_SOURCE_DIR}/memory/register/src/RegisterFile2Read1Write.v
    ${PROJECT_SOURCE_DIR}/memory/register/src/Register.v
)

add_library (cpu6502 STATIC
    Cpu6502.v VCpu6502.cpp VCpu6502__Syms.cpp
    ${PROJECT_SOURCE_DIR}/memory/register/src/RegisterFile2Read1Write.v
    ${PROJECT_SOURCE_DIR}/memory/register/src/Register.v
)

target_compile_options(cpu6502 PRIVATE ${VK_CPPFLAGS})

target_include_directories(cpu6502 PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(cpu6502 verilated)
