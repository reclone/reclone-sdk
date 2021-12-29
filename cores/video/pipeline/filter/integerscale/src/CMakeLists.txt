add_library (VVideoIntegerScale STATIC)

target_compile_options(VVideoIntegerScale PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoIntegerScale TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoIntegerScale.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
