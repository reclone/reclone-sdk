add_library (VDviEncoder STATIC)

target_compile_options(VDviEncoder PUBLIC ${VERILATOR_CFLAGS})

verilate (VDviEncoder TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        DviEncoder.v
        ${PROJECT_SOURCE_DIR}/video/tmds/ctl-encoder-2to10/src/CtlEncoder2to10.v
        ${PROJECT_SOURCE_DIR}/video/tmds/rgb-encoder-8to10/src/RgbEncoder8to10.v
)
