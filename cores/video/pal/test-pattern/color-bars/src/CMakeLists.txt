add_library (VPalColorBars STATIC)

target_compile_options(VPalColorBars PUBLIC ${VERILATOR_CFLAGS})

verilate (VPalColorBars TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        PalColorBars.v
)
