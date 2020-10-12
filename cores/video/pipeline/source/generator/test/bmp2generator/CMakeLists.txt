
add_library (bmp2generator STATIC
    GeneratorBuffer.cpp
)

target_compile_options(bmp2generator PRIVATE ${VK_CPPFLAGS})

target_include_directories(bmp2generator PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

