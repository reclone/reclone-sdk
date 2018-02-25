
add_custom_command (
  OUTPUT  Vcpu_6502.cpp
          Vcpu_6502.h
          Vcpu_6502__Syms.cpp
          Vcpu_6502__Syms.h
          VRegister.cpp
          VRegister.h
          VRegister__Syms.cpp
          VRegister__Syms.h
  COMMAND perl ${VERILATOR} -Wall -Mdir ${CMAKE_CURRENT_BINARY_DIR} -cc
    ${CMAKE_CURRENT_SOURCE_DIR}/cpu_6502.v
    ${PROJECT_SOURCE_DIR}/memory/register/src/Register.v
)

add_library (cpu6502 STATIC
    cpu_6502.v Vcpu_6502.cpp Vcpu_6502__Syms.cpp
    ${PROJECT_SOURCE_DIR}/memory/register/src/Register.v VRegister.cpp VRegister__Syms.cpp
)

target_compile_options(cpu6502 PRIVATE ${VK_CPPFLAGS})

target_include_directories(cpu6502 PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(cpu6502 verilated)
