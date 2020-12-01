# Google Test cmake example from http://www.kaizou.org/2014/11/gtest-cmake/

# We need thread support
find_package(Threads REQUIRED)

# Enable ExternalProject CMake module
include(ExternalProject)

# Download and install GoogleTest
ExternalProject_Add(
    gtest_external
    URL https://github.com/google/googletest/archive/release-1.10.0.zip
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/gtest_external
    URL_HASH SHA256=94c634d499558a76fa649edb13721dce6e98fb1e7018dfaeba3cd7a083945e91
    # Disable install step
    INSTALL_COMMAND ""
)

# Get GTest source and binary directories from CMake project
ExternalProject_Get_Property(gtest_external source_dir binary_dir)

# Create a gtest target to be used as a dependency by test programs
add_library(gtest IMPORTED STATIC GLOBAL)
add_dependencies(gtest gtest_external)

# Set gtest properties
if (MSVC)
  set_target_properties(gtest PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/Debug/gtestd.lib"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
else()
  set_target_properties(gtest PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/libgtest.a"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
endif (MSVC)

# Create a gtest_main target to be used as a dependency by test programs
add_library(gtest_main IMPORTED STATIC GLOBAL)
add_dependencies(gtest_main gtest_external)

# Set gtest_main properties
if (MSVC)
  set_target_properties(gtest_main PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/Debug/gtest_maind.lib"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
else()
  set_target_properties(gtest_main PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/libgtest_main.a"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
endif (MSVC)

# Create a gmock target to be used as a dependency by test programs
add_library(gmock IMPORTED STATIC GLOBAL)
add_dependencies(gmock gtest_external)

# Set gmock properties
if (MSVC)
  set_target_properties(gmock PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/Debug/gmockd.lib"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
else()
  set_target_properties(gmock PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/libgmock.a"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
endif (MSVC)

# Create a gmock_main target to be used as a dependency by test programs
add_library(gmock_main IMPORTED STATIC GLOBAL)
add_dependencies(gmock_main gtest_external)

# Set gmock_main properties
if (MSVC)
  set_target_properties(gmock_main PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/Debug/gmock_maind.lib"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
else()
  set_target_properties(gmock_main PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/lib/libgmock_main.a"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
  )
endif (MSVC)

# Add public include directories
include_directories("${source_dir}/googletest/include"
                    "${source_dir}/googlemock/include")

