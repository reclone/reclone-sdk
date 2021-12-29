add_library (VColorBars720p STATIC)

target_compile_options(VColorBars720p PUBLIC ${VERILATOR_CFLAGS})

verilate (VColorBars720p TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        ColorBars720p.v
)
