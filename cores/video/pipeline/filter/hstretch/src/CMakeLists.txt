add_library (VVideoHorizontalStretch STATIC)

target_compile_options(VVideoHorizontalStretch PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoHorizontalStretch TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoHorizontalStretch.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
