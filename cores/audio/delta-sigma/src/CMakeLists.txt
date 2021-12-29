add_library (VAudioDeltaSigmaDac STATIC)

target_compile_options(VAudioDeltaSigmaDac PUBLIC ${VERILATOR_CFLAGS})

verilate (VAudioDeltaSigmaDac TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    AudioDeltaSigmaDac.v
)
