add_library (VAsyncFifo STATIC)

target_compile_options(VAsyncFifo PUBLIC ${VERILATOR_CFLAGS})

verilate (VAsyncFifo TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        AsyncFifo.v
        ${PROJECT_SOURCE_DIR}/counter/gray/src/GrayCounter.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
