configure_file(../src/integerScaleReciprocalFactors.mem ${CMAKE_BINARY_DIR}/integerScaleReciprocalFactors.mem COPYONLY)
configure_file(../src/integerScaleReciprocalFactors.mem ${CMAKE_CURRENT_BINARY_DIR}/integerScaleReciprocalFactors.mem COPYONLY)

add_executable(testVideoIntegerScale VideoIntegerScaleTests.cpp)

target_link_libraries(testVideoIntegerScale VVideoIntegerScale gtest gtest_main)

add_test(NAME testVideoIntegerScale COMMAND testVideoIntegerScale)