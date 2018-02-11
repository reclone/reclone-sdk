
add_library(gtest STATIC src/gtest.cc)
target_include_directories(gtest PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(gtest PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

add_library(gtest_main STATIC src/gtest_main.cc)
target_include_directories(gtest_main PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
