add_library (VAudioCntntPrtctnPckt STATIC)

target_compile_options(VAudioCntntPrtctnPckt PUBLIC ${VERILATOR_CFLAGS})

verilate (VAudioCntntPrtctnPckt TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        AudioCntntPrtctnPckt.v
)
