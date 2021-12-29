add_library (VSyncFifo STATIC)

target_compile_options(VSyncFifo PUBLIC ${VERILATOR_CFLAGS})

verilate (VSyncFifo TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
