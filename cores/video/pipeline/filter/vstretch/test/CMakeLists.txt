configure_file(pexels-pixabay-163822.bmp ${CMAKE_BINARY_DIR}/pexels-pixabay-163822.bmp COPYONLY)
configure_file(pexels-pixabay-163822.bmp ${CMAKE_CURRENT_BINARY_DIR}/pexels-pixabay-163822.bmp COPYONLY)

add_executable(testVideoVerticalStretch VideoVerticalStretchTests.cpp)

target_link_libraries(testVideoVerticalStretch VVideoVerticalStretch gtest gmock gmock_main pipelinesink2bmp bmp2pipelinesrc)

add_test(NAME testVideoVerticalStretch COMMAND testVideoVerticalStretch)