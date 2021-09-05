configure_file(../src/Text16ColorPallette.mem ${CMAKE_BINARY_DIR}/Text16ColorPallette.mem COPYONLY)
configure_file(../src/Text16ColorPallette.mem ${CMAKE_CURRENT_BINARY_DIR}/Text16ColorPallette.mem COPYONLY)
configure_file(../../glyphram/src/CP437_8x16.mem ${CMAKE_BINARY_DIR}/CP437_8x16.mem COPYONLY)
configure_file(../../glyphram/src/CP437_8x16.mem ${CMAKE_CURRENT_BINARY_DIR}/CP437_8x16.mem COPYONLY)
configure_file(../../screenram/src/CharSet_ColorSet.mem ${CMAKE_BINARY_DIR}/CharSet_ColorSet.mem COPYONLY)
configure_file(../../screenram/src/CharSet_ColorSet.mem ${CMAKE_CURRENT_BINARY_DIR}/CharSet_ColorSet.mem COPYONLY)

add_executable(testTextOverlayGenerator TextOverlayGeneratorTests.cpp)

target_link_libraries(testTextOverlayGenerator VTextOverlayGenerator VVideoFormatTiming scanlines2bmp gtest gtest_main)

add_test(NAME testTextOverlayGenerator COMMAND testTextOverlayGenerator)