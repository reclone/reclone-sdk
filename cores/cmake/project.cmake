project (RecloneCores)

# Set default VERILATOR_ROOT (at least works in Ubuntu)
set(VERILATOR_ROOT /usr/share/verilator)

# Verilated code compile flags normally in verilated.mk
set(VK_CPPFLAGS -MMD -I${VERILATOR_ROOT}/include -I${VERILATOR_ROOT}/include/vltstd -DVL_PRINTF=printf)

# Overall C++ compile flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -Wall -Wextra -Wfloat-conversion -Wlogical-op -Werror")