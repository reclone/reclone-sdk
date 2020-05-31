configure_file(../src/sine1khz.mem ${CMAKE_BINARY_DIR}/sine1khz.mem COPYONLY)

add_executable(testSine1kHzTone Sine1kHzToneTests.cpp)

target_link_libraries(testSine1kHzTone VSine1kHzTone gtest gtest_main)

add_test(NAME testSine1kHzTone COMMAND testSine1kHzTone)