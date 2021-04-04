configure_file(pexels-pawel-fijalkowski-1253748.bmp ${CMAKE_BINARY_DIR}/pexels-pawel-fijalkowski-1253748.bmp COPYONLY)
configure_file(pexels-pawel-fijalkowski-1253748.bmp ${CMAKE_CURRENT_BINARY_DIR}/pexels-pawel-fijalkowski-1253748.bmp COPYONLY)

add_executable(testVideoBinningFilter VideoBinningFilterTests.cpp)

target_link_libraries(testVideoBinningFilter VVideoBinningFilter pipelinesink2bmp bmp2pipelinesrc gtest gmock_main gmock)

add_test(NAME testVideoBinningFilter COMMAND testVideoBinningFilter)