add_library (VVideoAggregateScaler STATIC)

target_compile_options(VVideoAggregateScaler PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoAggregateScaler TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoAggregateScaler.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/cropping/src/VideoCroppingFilter.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/padding/src/VideoPaddingFilter.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/integerscale/src/VideoIntegerScale.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/vstretch/src/VideoVerticalStretch.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/hstretch/src/VideoHorizontalStretch.v
)
