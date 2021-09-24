cmake_minimum_required (VERSION 3.8.0)

include(cmake/project.cmake)

add_subdirectory (audio)
add_subdirectory (bus)
add_subdirectory (counter)
add_subdirectory (cpu)
add_subdirectory (memory)
add_subdirectory (soc)
add_subdirectory (verilator)
add_subdirectory (video)