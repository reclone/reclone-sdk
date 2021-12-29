add_library (VPalTiming STATIC)

target_compile_options(VPalTiming PUBLIC ${VERILATOR_CFLAGS})

verilate (VPalTiming TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        PalTiming.v
)
