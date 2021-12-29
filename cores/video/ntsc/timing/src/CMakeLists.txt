add_library (VNtscTiming STATIC)

target_compile_options(VNtscTiming PUBLIC ${VERILATOR_CFLAGS})

verilate (VNtscTiming TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        NtscTiming.v
)
