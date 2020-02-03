add_executable(testNtscTiming NtscTimingTests.cpp)

target_link_libraries(testNtscTiming VNtscTiming gtest gtest_main)

add_test(NAME testNtscTiming COMMAND testNtscTiming)