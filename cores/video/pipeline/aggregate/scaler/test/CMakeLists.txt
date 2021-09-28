add_subdirectory(bmp2pipelinesrc)
add_subdirectory(pipelinesink2bmp)

configure_file(310314-Chagall77-mobygames-castlevania-nes-screenshot.bmp ${CMAKE_BINARY_DIR}/310314-Chagall77-mobygames-castlevania-nes-screenshot.bmp COPYONLY)
configure_file(310314-Chagall77-mobygames-castlevania-nes-screenshot.bmp ${CMAKE_CURRENT_BINARY_DIR}/310314-Chagall77-mobygames-castlevania-nes-screenshot.bmp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/video/pipeline/filter/integerscale/src/integerScaleReciprocalFactors.mem ${CMAKE_BINARY_DIR}/integerScaleReciprocalFactors.mem COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/video/pipeline/filter/integerscale/src/integerScaleReciprocalFactors.mem ${CMAKE_CURRENT_BINARY_DIR}/integerScaleReciprocalFactors.mem COPYONLY)


add_executable(testVideoAggregateScaler VideoAggregateScalerTests.cpp)

target_link_libraries(testVideoAggregateScaler VVideoAggregateScaler gtest gmock gmock_main pipelinesink2bmp bmp2pipelinesrc)

add_test(NAME testVideoAggregateScaler COMMAND testVideoAggregateScaler)
