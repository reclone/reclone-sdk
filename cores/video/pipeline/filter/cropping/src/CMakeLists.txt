add_library (VVideoCroppingFilter STATIC)

target_compile_options(VVideoCroppingFilter PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoCroppingFilter TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoCroppingFilter.v
)
