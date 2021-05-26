# Enable ExternalProject CMake module
include(ExternalProject)

# Download perfect6502
ExternalProject_Add(
    perfect6502_external
    URL https://github.com/reclone/perfect6502/archive/master.zip
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/perfect6502_external
    # Disable install step
    INSTALL_COMMAND ""
)

# Create a perfect6502 target to be used as a dependency by test programs
add_library(perfect6502 IMPORTED STATIC GLOBAL)
add_dependencies(perfect6502 perfect6502_external)

# Set perfect6502 properties
if (MSVC)
  set_target_properties(perfect6502 PROPERTIES
      "IMPORTED_LOCATION" "${CMAKE_CURRENT_BINARY_DIR}/perfect6502_external/src/perfect6502_external-build/Debug/perfect6502.lib"
  )
else()
  set_target_properties(perfect6502 PROPERTIES
      "IMPORTED_LOCATION" "${CMAKE_CURRENT_BINARY_DIR}/perfect6502_external/src/perfect6502_external-build/libperfect6502.a"
  )
endif(MSVC)
