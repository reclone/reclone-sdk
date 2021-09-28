add_subdirectory(bmp2generator)

configure_file(greenscreen.bmp ${CMAKE_CURRENT_BINARY_DIR}/greenscreen.bmp COPYONLY)
configure_file(greenscreen.bmp ${CMAKE_BINARY_DIR}/greenscreen.bmp COPYONLY)
configure_file(redbluepattern.bmp ${CMAKE_CURRENT_BINARY_DIR}/redbluepattern.bmp COPYONLY)
configure_file(redbluepattern.bmp ${CMAKE_BINARY_DIR}/redbluepattern.bmp COPYONLY)
configure_file(rainbowswirls.bmp ${CMAKE_CURRENT_BINARY_DIR}/rainbowswirls.bmp COPYONLY)
configure_file(rainbowswirls.bmp ${CMAKE_BINARY_DIR}/rainbowswirls.bmp COPYONLY)

add_executable(testVideoGeneratorSource VideoGeneratorSourceTests.cpp)

target_link_libraries(testVideoGeneratorSource VVideoGeneratorSource VVideoTimingSink bmp2generator scanlines2bmp gtest gtest_main)

add_test(NAME testVideoGeneratorSource COMMAND testVideoGeneratorSource)