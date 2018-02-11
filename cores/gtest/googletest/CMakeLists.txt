
add_library(gtest STATIC src/gtest-all.cc)
target_include_directories(gtest PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(gtest PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(gtest pthread)

add_library(gtest_main STATIC src/gtest_main.cc)
target_include_directories(gtest_main PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_link_libraries(gtest_main gtest)
