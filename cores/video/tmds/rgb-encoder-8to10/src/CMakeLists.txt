add_library (VRgbEncoder8to10 STATIC)

target_compile_options(VRgbEncoder8to10 PUBLIC ${VERILATOR_CFLAGS})

verilate (VRgbEncoder8to10 TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        RgbEncoder8to10.v
)
