add_library (VNullDataIslandPacket STATIC)

target_compile_options(VNullDataIslandPacket PUBLIC ${VERILATOR_CFLAGS})

verilate (VNullDataIslandPacket TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        NullDataIslandPacket.v
)
