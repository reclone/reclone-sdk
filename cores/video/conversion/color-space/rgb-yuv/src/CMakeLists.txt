add_library (VRgbToYuv STATIC)

target_compile_options(VRgbToYuv PUBLIC ${VERILATOR_CFLAGS})

verilate (VRgbToYuv TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        RgbToYuv.v
)
