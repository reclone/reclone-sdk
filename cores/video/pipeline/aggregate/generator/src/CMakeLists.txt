add_library (VVideoGeneratorPipeline STATIC)

target_compile_options(VVideoGeneratorPipeline PUBLIC ${VERILATOR_CFLAGS})

verilate (VVideoGeneratorPipeline TRACE VERILATOR_ARGS ${VERILATOR_OPTS}
    SOURCES
        VideoGeneratorPipeline.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/sync/src/SyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/fifo/async/src/AsyncFifo.v
        ${PROJECT_SOURCE_DIR}/memory/blockram/dual-port/symmetric/src/BlockRamDualPort.v
        ${PROJECT_SOURCE_DIR}/counter/gray/src/GrayCounter.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/cropping/src/VideoCroppingFilter.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/padding/src/VideoPaddingFilter.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/integerscale/src/VideoIntegerScale.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/vstretch/src/VideoVerticalStretch.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/filter/hstretch/src/VideoHorizontalStretch.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/source/generator/src/VideoGeneratorSource.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/aggregate/scaler/src/VideoAggregateScaler.v
        ${PROJECT_SOURCE_DIR}/video/pipeline/sink/timing/src/VideoTimingSink.v
        ${PROJECT_SOURCE_DIR}/video/timing/src/VideoFormatTiming.v
)
