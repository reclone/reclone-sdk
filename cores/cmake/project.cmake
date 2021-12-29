cmake_minimum_required(VERSION 3.0)

include(cmake/gtest.cmake)
include(cmake/zlib.cmake)

find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

# Global verilator options
set(VERILATOR_OPTS -Wall -Wno-PINCONNECTEMPTY --default-language 1364-2005 --bin "${VERILATOR_BIN}")

# Overall C++ compile flags
if (MSVC)
  set(CMAKE_CXX_FLAGS "/W3 /GR /EHsc /WX")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
  add_definitions(/DWIN32 /D_WINDOWS)
else()
  set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wfloat-conversion -Wlogical-op -Werror -faligned-new")
endif(MSVC)
set(CMAKE_CXX_COMPILE_FEATURES cxx_std_11)
set(CMAKE_C_COMPILE_FEATURES c_std_99)

# Find ISE binaries
find_program(XST xst PATHS C:\\Xilinx\\14.7\\ISE_DS\\ISE\\bin\\nt64 NO_DEFAULT_PATH)
find_program(NGDBUILD ngdbuild PATHS C:\\Xilinx\\14.7\\ISE_DS\\ISE\\bin\\nt64 NO_DEFAULT_PATH)
find_program(MAP map PATHS C:\\Xilinx\\14.7\\ISE_DS\\ISE\\bin\\nt64 NO_DEFAULT_PATH)
find_program(PAR par PATHS C:\\Xilinx\\14.7\\ISE_DS\\ISE\\bin\\nt64 NO_DEFAULT_PATH)
find_program(BITGEN bitgen PATHS C:\\Xilinx\\14.7\\ISE_DS\\ISE\\bin\\nt64 NO_DEFAULT_PATH)
find_program(TRCE trce PATHS C:\\Xilinx\\14.7\\ISE_DS\\ISE\\bin\\nt64 NO_DEFAULT_PATH)

# Common ISE options
set(ISE_COMMON_OPTS -intstyle ise)

# Allow use of add_test in subdirs
enable_testing()