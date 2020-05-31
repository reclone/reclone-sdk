
set(SOC_NAME AvTestPatterns)

set(VERILOG_SRCS
    ${CMAKE_CURRENT_SOURCE_DIR}/${SOC_NAME}Top.v
    ${CMAKE_CURRENT_SOURCE_DIR}/../${SOC_NAME}.v
    ${PROJECT_SOURCE_DIR}/counter/count-up/src/CountUp.v
    ${PROJECT_SOURCE_DIR}/target/reclone-rise/ClockGen.v
    ${PROJECT_SOURCE_DIR}/video/timing/src/VideoFormatTiming.v
    ${PROJECT_SOURCE_DIR}/video/dvi/src/DviEncoder.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/encoder/src/HdmiEncoder.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/vblank/src/VBlankDataIsland.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/avi-infoframe/src/AviInfoFramePacket.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/audio-infoframe/src/AudioInfoFramePacket.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/packet/serializer/src/DataIslandPacketSerializer.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccStep.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccSingleBitEncoder.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/data-island/ecc/src/BchEccDualBitEncoder.v
    ${PROJECT_SOURCE_DIR}/video/tmds/terc4-encoder-4to10/src/Terc4Encoder4to10.v
    ${PROJECT_SOURCE_DIR}/video/tmds/rgb-encoder-8to10/src/RgbEncoder8to10.v
    ${PROJECT_SOURCE_DIR}/video/tmds/ctl-encoder-2to10/src/CtlEncoder2to10.v
    ${PROJECT_SOURCE_DIR}/target/reclone-rise/LvdsOut5Bit.v
    ${PROJECT_SOURCE_DIR}/target/reclone-rise/OutputSerializerSdr5Bit.v
    ${PROJECT_SOURCE_DIR}/memory/async-fifo/src/AsyncFifo.v
    ${PROJECT_SOURCE_DIR}/counter/gray/src/GrayCounter.v
    ${PROJECT_SOURCE_DIR}/counter/enable-divider/src/ClockEnableDivider.v
    ${PROJECT_SOURCE_DIR}/video/ntsc/timing/src/NtscTiming.v
    ${PROJECT_SOURCE_DIR}/video/ntsc/generator/src/NtscGenerator.v
    ${PROJECT_SOURCE_DIR}/video/pal/timing/src/PalTiming.v
    ${PROJECT_SOURCE_DIR}/video/pal/generator/src/PalGenerator.v
    ${PROJECT_SOURCE_DIR}/video/ntsc/test-pattern/color-bars/src/NtscColorBars.v
    ${PROJECT_SOURCE_DIR}/video/pal/test-pattern/color-bars/src/PalColorBars.v
    ${PROJECT_SOURCE_DIR}/video/hdmi/test-pattern/color-bars/720p/src/ColorBars720p.v
    ${PROJECT_SOURCE_DIR}/video/conversion/color-space/rgb-yiq/src/RgbToYiq.v
    ${PROJECT_SOURCE_DIR}/audio/tones/sine-1khz/src/Sine1kHzTone.v
    ${PROJECT_SOURCE_DIR}/audio/delta-sigma/src/AudioDeltaSigmaDac.v
    )

include(${PROJECT_SOURCE_DIR}/target/reclone-rise/reclone-rise.cmake)

set(PRJ_CONTENT "")
foreach(vsrc ${VERILOG_SRCS})
    set(PRJ_CONTENT "${PRJ_CONTENT}verilog work \"${vsrc}\"\n")
endforeach(vsrc)

file(GENERATE OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${SOC_NAME}.prj CONTENT "${PRJ_CONTENT}")

file(GENERATE OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${SOC_NAME}.xst CONTENT
"run
-ifn ${SOC_NAME}.prj
-ofn ${SOC_NAME}.ngc
-ifmt mixed
-top ${SOC_NAME}Top
-ofmt NGC
-p ${TARGET_PART}
${XST_OPTS}"
)

file(GENERATE OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${SOC_NAME}.ut CONTENT "${BITGEN_OPTS}")

add_custom_command(OUTPUT ${SOC_NAME}.ngc DEPENDS ${VERILOG_SRCS} ${SOC_NAME}.prj ${SOC_NAME}.xst
    COMMAND ${XST} ${ISE_COMMON_OPTS} -ifn ${SOC_NAME}.xst
)

add_custom_command(OUTPUT ${SOC_NAME}.ngd DEPENDS ${SOC_NAME}.ngc ${USER_CONSTRAINTS_FILE}
    COMMAND ${NGDBUILD} ${ISE_COMMON_OPTS} ${NGDBUILD_OPTS} -p ${TARGET_PART} -uc ${USER_CONSTRAINTS_FILE} ${SOC_NAME}.ngc ${SOC_NAME}.ngd
)

add_custom_command(OUTPUT ${SOC_NAME}_map.ncd ${SOC_NAME}.pcf DEPENDS ${SOC_NAME}.ngd
    COMMAND ${MAP} ${ISE_COMMON_OPTS} ${MAP_OPTS} -p ${TARGET_PART} -w ${SOC_NAME}.ngd -o ${SOC_NAME}_map.ncd ${SOC_NAME}.pcf
)

add_custom_command(OUTPUT ${SOC_NAME}.ncd DEPENDS ${SOC_NAME}_map.ncd ${SOC_NAME}.pcf
    COMMAND ${PAR} ${ISE_COMMON_OPTS} ${PAR_OPTS} -w ${SOC_NAME}_map.ncd ${SOC_NAME}.ncd ${SOC_NAME}.pcf
)

string(TOLOWER "${SOC_NAME}.bit" BIT_FILE)
string(TOLOWER "${SOC_NAME}.drc" DRC_FILE)
add_custom_command(OUTPUT ${BIT_FILE} ${DRC_FILE} DEPENDS ${SOC_NAME}.ncd ${SOC_NAME}.ut
    COMMAND ${BITGEN} ${ISE_COMMON_OPTS} -w -f ${SOC_NAME}.ut ${SOC_NAME}.ncd ${BIT_FILE}
)

add_custom_target(AvTestPatternsForRecloneRise ALL DEPENDS ${BIT_FILE})

