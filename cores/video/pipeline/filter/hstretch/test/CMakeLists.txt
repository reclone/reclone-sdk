configure_file(openclipart_330518.bmp ${CMAKE_BINARY_DIR}/openclipart_330518.bmp COPYONLY)
configure_file(openclipart_330518.bmp ${CMAKE_CURRENT_BINARY_DIR}/openclipart_330518.bmp COPYONLY)
configure_file(tetiana-bykovets-z-kkcidqW_U-unsplash.bmp ${CMAKE_BINARY_DIR}/tetiana-bykovets-z-kkcidqW_U-unsplash.bmp COPYONLY)
configure_file(tetiana-bykovets-z-kkcidqW_U-unsplash.bmp ${CMAKE_CURRENT_BINARY_DIR}/tetiana-bykovets-z-kkcidqW_U-unsplash.bmp COPYONLY)

add_executable(testVideoHorizontalStretch VideoHorizontalStretchTests.cpp)

target_link_libraries(testVideoHorizontalStretch VVideoHorizontalStretch gtest gmock gmock_main pipelinesink2bmp bmp2pipelinesrc)

add_test(NAME testVideoHorizontalStretch COMMAND testVideoHorizontalStretch)