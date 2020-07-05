add_executable(testAsyncFifo AsyncFifoTests.cpp)

target_link_libraries(testAsyncFifo VAsyncFifo gtest gtest_main)

add_test(NAME testAsyncFifo COMMAND testAsyncFifo)
