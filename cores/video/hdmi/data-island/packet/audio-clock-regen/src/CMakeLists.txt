add_library (VAudioClockRegenPacket STATIC)

target_compile_options(VAudioClockRegenPacket PUBLIC ${VERILATOR_CFLAGS})

verilate (VAudioClockRegenPacket TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        AudioClockRegenPacket.v
)
