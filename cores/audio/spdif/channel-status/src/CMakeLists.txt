add_library (VSpdifChannelStatus STATIC)

target_compile_options(VSpdifChannelStatus PUBLIC ${VERILATOR_CFLAGS})

verilate (VSpdifChannelStatus TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    SpdifChannelStatus.v
)
