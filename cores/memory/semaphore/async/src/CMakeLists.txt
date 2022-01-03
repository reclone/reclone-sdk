add_library (VAsyncSemaphore STATIC)

target_compile_options(VAsyncSemaphore PUBLIC ${VERILATOR_CFLAGS})

verilate (VAsyncSemaphore TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        AsyncSemaphore.v
        ${PROJECT_SOURCE_DIR}/counter/gray/src/GrayCounter.v
)
