add_library (VNtscColorBars STATIC)

target_compile_options(VNtscColorBars PUBLIC ${VERILATOR_CFLAGS})

verilate (VNtscColorBars TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        NtscColorBars.v
)
