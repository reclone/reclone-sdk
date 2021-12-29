add_library (VCpu65xxAlu STATIC)

target_compile_options(VCpu65xxAlu PUBLIC ${VERILATOR_CFLAGS})

verilate (VCpu65xxAlu TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    INCLUDE_DIRS
        ${PROJECT_SOURCE_DIR}/cpu/65xx/uarch/src
    SOURCES
        Cpu65xxAlu.v
)
