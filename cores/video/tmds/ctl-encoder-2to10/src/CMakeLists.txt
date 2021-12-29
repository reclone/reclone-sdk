add_library (VCtlEncoder2to10 STATIC)

target_compile_options(VCtlEncoder2to10 PUBLIC ${VERILATOR_CFLAGS})

verilate (VCtlEncoder2to10 TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        CtlEncoder2to10.v
)
