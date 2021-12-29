add_library (VTextOverlayGenerator STATIC)

target_compile_options(VTextOverlayGenerator PUBLIC ${VERILATOR_CFLAGS})

verilate (VTextOverlayGenerator TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        TextOverlayGenerator.v
)
