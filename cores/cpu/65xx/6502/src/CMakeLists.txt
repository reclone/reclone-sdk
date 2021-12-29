add_library (VCpu6502 STATIC)

target_compile_options(VCpu6502 PUBLIC ${VERILATOR_CFLAGS})

verilate (VCpu6502 TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    INCLUDE_DIRS
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${PROJECT_SOURCE_DIR}/cpu/65xx/uarch/src
    SOURCES
        Cpu6502.v
        Cpu6502MicrocodeRom.v
        ${PROJECT_SOURCE_DIR}/cpu/65xx/alu/src/Cpu65xxAlu.v
        ${PROJECT_SOURCE_DIR}/cpu/65xx/uarch/src/Cpu65xxMicroArchitecture.v
)


# Individual target for the microcode ROM, to allow producing a hex dump
add_library (VCpu6502MicrocodeRom STATIC)

target_compile_options(VCpu6502MicrocodeRom PUBLIC ${VERILATOR_CFLAGS})

verilate (VCpu6502MicrocodeRom TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    INCLUDE_DIRS
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${PROJECT_SOURCE_DIR}/cpu/65xx/uarch/src
    SOURCES
        Cpu6502MicrocodeRom.v
)
