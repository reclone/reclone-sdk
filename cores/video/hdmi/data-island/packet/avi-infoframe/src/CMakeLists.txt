add_library (VAviInfoFramePacket STATIC)

target_compile_options(VAviInfoFramePacket PUBLIC ${VERILATOR_CFLAGS})

verilate (VAviInfoFramePacket TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        AviInfoFramePacket.v
)
