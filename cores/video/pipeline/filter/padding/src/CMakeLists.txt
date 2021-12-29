add_library (VVideoPaddingFilter STATIC)

target_compile_options(VVideoPaddingFilter PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoPaddingFilter TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoPaddingFilter.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
