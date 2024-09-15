cmake_minimum_required(VERSION 3.24)
project(CTESTMPI VERSION 0.0.1 DESCRIPTION "" LANGUAGES C)

option(ENABLE_TESTS "Enable unit tests" ON)

set(CTESTMPI_CUSTOM_MPIFLAGS "" CACHE STRING "Pass custom MPI flags to CTest")

# https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
# Use, i.e. don't skip the full RPATH for the build tree.
set(CMAKE_SKIP_BUILD_RPATH FALSE)
# When building, don't use the install RPATH.
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
# Set the library location.
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
# Add the automatically determined parts of the RPATH which point to directories
# outside the build tree to the install RPATH.
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

set(CMAKE_COMPILE_WARNING_AS_ERROR ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(MPI REQUIRED)
if (NOT MPI_FOUND)
  message(FATAL_ERROR "Unable to find MPI.")
endif()

if (ENABLE_TESTS)
  add_subdirectory(tests)
endif()

# Add clang-format as a custom target if available.
find_program(CLANG_FORMAT NAMES clang-format)
if (CLANG_FORMAT)
  add_custom_target(format
    COMMAND ${CLANG_FORMAT} -i ${CMAKE_CURRENT_SOURCE_DIR}/*/*.[ch]
    COMMENT "Running clang-format ...")
  add_custom_target(format-check
    COMMAND ${CLANG_FORMAT} --dry-run -Werror -i ${CMAKE_CURRENT_SOURCE_DIR}/*/*.[ch]
    COMMENT "Running clang-format check ...")
endif()
