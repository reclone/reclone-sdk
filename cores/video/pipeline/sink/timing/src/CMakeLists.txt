add_library (VVideoTimingSink STATIC)

target_compile_options(VVideoTimingSink PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoTimingSink TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoTimingSink.v
        ${PROJECT_SOURCE_DIR}/video/timing/src/VideoFormatTiming.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/async/src/AsyncFifo.v
        ${PROJECT_SOURCE_DIR}/counter/gray/src/GrayCounter.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
