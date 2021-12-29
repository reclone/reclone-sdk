add_library (VDataIslandPacketSerializer STATIC)

target_compile_options(VDataIslandPacketSerializer PUBLIC ${VERILATOR_CFLAGS})

verilate (VDataIslandPacketSerializer TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        DataIslandPacketSerializer.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccSingleBitEncoder.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccDualBitEncoder.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccStep.v
)
