add_executable(testGrayCounter GrayCounterTests.cpp)

target_link_libraries(testGrayCounter VGrayCounter gtest gtest_main)

add_test(NAME testGrayCounter COMMAND testGrayCounter)