add_executable(testPalTiming PalTimingTests.cpp)

target_link_libraries(testPalTiming VPalTiming gtest gtest_main)

add_test(NAME testPalTiming COMMAND testPalTiming)