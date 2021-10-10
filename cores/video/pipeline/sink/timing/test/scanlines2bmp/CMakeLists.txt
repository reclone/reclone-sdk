
add_library (scanlines2bmp STATIC
    ScanlineBuffer.cpp
)

target_compile_options(scanlines2bmp PRIVATE ${VK_CPPFLAGS})

target_include_directories(scanlines2bmp PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# zlib is used for its crc32 routine
target_link_libraries(scanlines2bmp z)
