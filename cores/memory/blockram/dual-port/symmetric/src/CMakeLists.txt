add_library (VBlockRamDualPort STATIC)

target_compile_options(VBlockRamDualPort PUBLIC ${VERILATOR_CFLAGS})

verilate (VBlockRamDualPort TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    BlockRamDualPort.v
)
