add_library (VTextGlyphRam STATIC)

target_compile_options(VTextGlyphRam PUBLIC ${VERILATOR_CFLAGS})

verilate (VTextGlyphRam TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        TextGlyphRam.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
)
