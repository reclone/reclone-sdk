add_library (VTerc4Encoder4to10 STATIC)

target_compile_options(VTerc4Encoder4to10 PUBLIC ${VERILATOR_CFLAGS})

verilate (VTerc4Encoder4to10 TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        Terc4Encoder4to10.v
)
