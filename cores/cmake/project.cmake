cmake_minimum_required(VERSION 3.0)

project (RecloneCores)

include(cmake/gtest.cmake)

# Set default VERILATOR_ROOT (at least works in Ubuntu)
if (MSVC)
  set(VERILATOR_ROOT C:\\msys64\\usr\\share\\verilator)
else()
  set(VERILATOR_ROOT /usr/share/verilator)
endif()

# Verilated code compile flags normally in verilated.mk
set(VK_CPPFLAGS -MMD -I${VERILATOR_ROOT}/include -I${VERILATOR_ROOT}/include/vltstd -DVL_PRINTF=printf)

find_file(VERILATOR verilator PATHS C:\\msys64\\usr\\bin C:\\msys32\\usr\\bin /usr/bin NO_DEFAULT_PATH)

# Global verilator options
set(VERILATOR_OPTS -Wall --trace --default-language 1364-2005)


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

# Common ISE options
set(ISE_COMMON_OPTS -intstyle ise)

# Allow use of add_test in subdirs
enable_testing()