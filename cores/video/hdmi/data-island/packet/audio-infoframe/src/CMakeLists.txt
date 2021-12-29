add_library (VAudioInfoFramePacket STATIC)

target_compile_options(VAudioInfoFramePacket PUBLIC ${VERILATOR_CFLAGS})

verilate (VAudioInfoFramePacket TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        AudioInfoFramePacket.v
)
