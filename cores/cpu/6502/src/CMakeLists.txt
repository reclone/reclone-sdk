
add_custom_command (
  OUTPUT  Vtop_6502.cpp
          Vtop_6502.h
          Vtop_6502.mk
          Vtop_6502__Syms.cpp
          Vtop_6502__Syms.h
          Vtop_6502__ver.d
          Vtop_6502__verFiles.dat
          Vtop_6502_classes.mk
  COMMAND perl ${VERILATOR} -Wall -Mdir ${CMAKE_CURRENT_BINARY_DIR} -cc ${CMAKE_CURRENT_SOURCE_DIR}/top_6502.v
)

add_library (cpu6502 STATIC Vtop_6502.cpp Vtop_6502__Syms.cpp)

target_compile_options(cpu6502 PRIVATE ${VK_CPPFLAGS})

target_include_directories(cpu6502 PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(cpu6502 verilated)
