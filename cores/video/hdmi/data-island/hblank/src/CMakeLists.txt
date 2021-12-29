add_library (VHBlankDataIsland STATIC)

target_compile_options(VHBlankDataIsland PUBLIC ${VERILATOR_CFLAGS})

verilate (VHBlankDataIsland TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        HBlankDataIsland.v
        ${PROJECT_SOURCE_DIR}/audio/spdif/channel-status/src/SpdifChannelStatus.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/audio-sample/src/AudioSamplePacket.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/audio-clock-regen/src/AudioClockRegenPacket.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/null/src/NullDataIslandPacket.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/serializer/src/DataIslandPacketSerializer.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccStep.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccSingleBitEncoder.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccDualBitEncoder.v
        ${PROJECT_SOURCE_DIR}/video/tmds/terc4-encoder-4to10/src/Terc4Encoder4to10.v
        ${PROJECT_SOURCE_DIR}/video/tmds/ctl-encoder-2to10/src/CtlEncoder2to10.v
)
