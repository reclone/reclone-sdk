
add_library (bmp2pipelinesrc STATIC
    BmpPipelineSource.cpp
)

target_compile_options(bmp2pipelinesrc PRIVATE ${VK_CPPFLAGS})

target_include_directories(bmp2pipelinesrc PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(bmp2pipelinesrc VVideoGeneratorSource bmp2generator)
