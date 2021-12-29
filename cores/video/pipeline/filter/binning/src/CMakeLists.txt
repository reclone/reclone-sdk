add_library (VVideoBinningFilter STATIC)

target_compile_options(VVideoBinningFilter PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoBinningFilter TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoBinningFilter.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
