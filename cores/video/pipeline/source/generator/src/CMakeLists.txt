add_library (VVideoGeneratorSource STATIC)

target_compile_options(VVideoGeneratorSource PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoGeneratorSource TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoGeneratorSource.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
