add_library(gmock STATIC src/gmock.cc)
target_link_libraries(gmock gtest)
target_include_directories(gmock PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_library(gmock_main STATIC src/gmock_main.cc)
target_include_directories(gmock_main PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_link_libraries(gmock_main gmock)