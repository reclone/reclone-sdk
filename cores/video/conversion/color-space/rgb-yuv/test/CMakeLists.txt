add_executable(testRgbToYuv RgbToYuvTests.cpp)

target_link_libraries(testRgbToYuv VRgbToYuv gtest gtest_main)

add_test(NAME testRgbToYuv COMMAND testRgbToYuv)