add_library (VAudioSamplePacket STATIC)

target_compile_options(VAudioSamplePacket PUBLIC ${VERILATOR_CFLAGS})

verilate (VAudioSamplePacket TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        AudioSamplePacket.v
)
