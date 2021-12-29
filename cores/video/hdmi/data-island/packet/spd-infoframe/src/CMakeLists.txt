add_library (VSpdInfoFramePacket STATIC)

target_compile_options(VSpdInfoFramePacket PUBLIC ${VERILATOR_CFLAGS})

verilate (VSpdInfoFramePacket TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        SpdInfoFramePacket.v
)
