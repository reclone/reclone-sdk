add_executable(testDviEncoder DviEncoderTests.cpp)

target_link_libraries(testDviEncoder VDviEncoder gtest gtest_main)

add_test(NAME testDviEncoder COMMAND testDviEncoder)