add_executable(testRgbToYiq RgbToYiqTests.cpp)

target_link_libraries(testRgbToYiq VRgbToYiq gtest gtest_main)

add_test(NAME testRgbToYiq COMMAND testRgbToYiq)