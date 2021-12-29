add_library (VRgbToYiq STATIC)

target_compile_options(VRgbToYiq PUBLIC ${VERILATOR_CFLAGS})

verilate (VRgbToYiq TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        RgbToYiq.v
)
