add_executable(testSyncFifo SyncFifoTests.cpp)

target_link_libraries(testSyncFifo VSyncFifo gtest gtest_main)

add_test(NAME testSyncFifo COMMAND testSyncFifo)
