add_library (VVBlankDataIsland STATIC)

target_compile_options(VVBlankDataIsland PUBLIC ${VERILATOR_CFLAGS})

verilate (VVBlankDataIsland TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VBlankDataIsland.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/general-control/src/GeneralControlPacket.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/avi-infoframe/src/AviInfoFramePacket.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/audio-infoframe/src/AudioInfoFramePacket.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/spd-infoframe/src/SpdInfoFramePacket.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/audio-cntnt-prtctn/src/AudioCntntPrtctnPckt.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/serializer/src/DataIslandPacketSerializer.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccStep.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccSingleBitEncoder.v
        ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccDualBitEncoder.v
        ${PROJECT_SOURCE_DIR}/video/tmds/terc4-encoder-4to10/src/Terc4Encoder4to10.v
        ${PROJECT_SOURCE_DIR}/video/tmds/ctl-encoder-2to10/src/CtlEncoder2to10.v
)
