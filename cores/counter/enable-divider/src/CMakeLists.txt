add_library (VClockEnableDivider STATIC)

target_compile_options(VClockEnableDivider PUBLIC ${VERILATOR_CFLAGS})

verilate (VClockEnableDivider TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    ClockEnableDivider.v
)
