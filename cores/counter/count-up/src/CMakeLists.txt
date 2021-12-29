add_library (VCountUp STATIC)

target_compile_options(VCountUp PUBLIC ${VERILATOR_CFLAGS})

verilate (VCountUp TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    CountUp.v
)
