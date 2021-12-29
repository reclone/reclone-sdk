add_library (VBlockRamDualPort8and16 STATIC)

target_compile_options(VBlockRamDualPort8and16 PUBLIC ${VERILATOR_CFLAGS})

verilate (VBlockRamDualPort8and16 TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    BlockRamDualPort8and16.v
)
