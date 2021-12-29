add_library (VTextScreenRam STATIC)

target_compile_options(VTextScreenRam PUBLIC ${VERILATOR_CFLAGS})

verilate (VTextScreenRam TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        TextScreenRam.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
