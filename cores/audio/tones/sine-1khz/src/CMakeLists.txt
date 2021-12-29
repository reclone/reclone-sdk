add_library (VSine1kHzTone STATIC)

target_compile_options(VSine1kHzTone PUBLIC ${VERILATOR_CFLAGS})

verilate (VSine1kHzTone TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    Sine1kHzTone.v
)
