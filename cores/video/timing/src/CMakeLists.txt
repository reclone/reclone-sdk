add_library (VVideoFormatTiming STATIC)

target_compile_options(VVideoFormatTiming PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoFormatTiming TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoFormatTiming.v
)

