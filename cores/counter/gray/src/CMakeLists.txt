add_library (VGrayCounter STATIC)

target_compile_options(VGrayCounter PUBLIC ${VERILATOR_CFLAGS})

verilate (VGrayCounter TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    GrayCounter.v
)
