add_library (VVideoVerticalStretch STATIC)

target_compile_options(VVideoVerticalStretch PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoVerticalStretch TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoVerticalStretch.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
