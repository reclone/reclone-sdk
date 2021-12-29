add_library (VCpu65xxMicroArchitecture STATIC)

target_compile_options(VCpu65xxMicroArchitecture PUBLIC ${VERILATOR_CFLAGS})

verilate (VCpu65xxMicroArchitecture TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    INCLUDE_DIRS
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${PROJECT_SOURCE_DIR}/cpu/65xx/6502/src
    SOURCES
        Cpu65xxMicroArchitecture.v
        ${PROJECT_SOURCE_DIR}/cpu/65xx/alu/src/Cpu65xxAlu.v
)
