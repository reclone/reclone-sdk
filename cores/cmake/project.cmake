project (RecloneCores)

# Dirty hack to set default VERILATOR_ROOT
set(VERILATOR_ROOT /usr/share/verilator)

# This is a copy of stuff normally in verilated.mk
set(CFG_CXXFLAGS_STD_NEWEST -std=gnu++17)
set(CFG_CXXFLAGS_NO_UNUSED -faligned-new -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow)
set(CFG_CXXFLAGS_WEXTRA -Wextra -Wfloat-conversion -Wlogical-op)
set(VK_CPPFLAGS_ALWAYS -MMD -I${VERILATOR_ROOT}/include -I${VERILATOR_ROOT}/include/vltstd -DVL_PRINTF=printf ${CFG_CXXFLAGS_NO_UNUSED} )
set(VK_CPPFLAGS_WALL -Wall ${CFG_CXXFLAGS_WEXTRA} -Werror)
set(VK_CPPFLAGS -I. ${VK_CPPFLAGS_WALL} ${VK_CPPFLAGS_ALWAYS})