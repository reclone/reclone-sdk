add_library (VNtscGenerator STATIC)

target_compile_options(VNtscGenerator PUBLIC ${VERILATOR_CFLAGS})

verilate (VNtscGenerator TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        NtscGenerator.v
)
