add_library(verilated STATIC verilated_inc.cpp)
target_include_directories(verilated PUBLIC ${VERILATOR_ROOT}/include)

# Warnings in Verilator library code - gross!
target_compile_options(verilated PRIVATE -Wno-format -Wno-format-extra-args -Wno-implicit-fallthrough)