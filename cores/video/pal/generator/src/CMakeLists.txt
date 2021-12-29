add_library (VPalGenerator STATIC)

target_compile_options(VPalGenerator PUBLIC ${VERILATOR_CFLAGS})

verilate (VPalGenerator TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        PalGenerator.v
)
