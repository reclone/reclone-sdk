configure_file(../src/integerScaleReciprocalFactors.mem ${CMAKE_BINARY_DIR}/integerScaleReciprocalFactors.mem COPYONLY)
configure_file(../src/integerScaleReciprocalFactors.mem ${CMAKE_CURRENT_BINARY_DIR}/integerScaleReciprocalFactors.mem COPYONLY)
configure_file(openclipart_327413.bmp ${CMAKE_BINARY_DIR}/openclipart_327413.bmp COPYONLY)
configure_file(openclipart_327413.bmp ${CMAKE_CURRENT_BINARY_DIR}/openclipart_327413.bmp COPYONLY)

add_executable(testVideoIntegerScale VideoIntegerScaleTests.cpp)

target_link_libraries(testVideoIntegerScale VVideoIntegerScale gtest gmock gmock_main pipelinesink2bmp bmp2pipelinesrc)

add_test(NAME testVideoIntegerScale COMMAND testVideoIntegerScale)