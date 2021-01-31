
add_library (pipelinesink2bmp STATIC
    BmpPipelineSink.cpp
)

target_compile_options(pipelinesink2bmp PRIVATE ${VK_CPPFLAGS})

target_include_directories(pipelinesink2bmp PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(pipelinesink2bmp VVideoTimingSink)
