add_library (VPsramWishboneMaster STATIC)

target_compile_options(VPsramWishboneMaster PUBLIC ${VERILATOR_CFLAGS})

verilate (VPsramWishboneMaster TRACE VERILATOR_ARGS ${VERILATOR_OPTS} SOURCES
    PsramWishboneMaster.v
)
