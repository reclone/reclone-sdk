add_library (VGeneralControlPacket STATIC)

target_compile_options(VGeneralControlPacket PUBLIC ${VERILATOR_CFLAGS})

verilate (VGeneralControlPacket TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        GeneralControlPacket.v
)
