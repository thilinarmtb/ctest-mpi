enable_testing()

function(add_test_common test_w_path target)
  string(REPLACE "${CMAKE_SOURCE_DIR}/tests/" "" test_w_ext ${test_w_path})
  string(REPLACE ".c" "" test ${test_w_ext})
  add_executable(${test} ${test_w_path})
  target_compile_options(${test} PRIVATE $<$<C_COMPILER_ID:MSVC>:/W4 /WX>
    $<$<NOT:$<C_COMPILER_ID:MSVC>>:-Wall -Wextra -Wpedantic>)
  set_target_properties(${test} PROPERTIES VERSION ${PROJECT_VERSION})
  install(TARGETS ${test} RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/tests)
  set(target ${test} PARENT_SCOPE)
endfunction()

function(add_test_mpi_0001 target)
  add_test(NAME ${target} COMMAND ${CMAKE_INSTALL_PREFIX}/tests/${target})
endfunction()

function(add_test_mpi_0002_ranks target)
  add_test(NAME ${target}-mpi-0002 COMMAND
    ${MPIEXEC_EXECUTABLE} ${CTESTMPI_CUSTOM_MPIFLAGS} ${MPIEXEC_NUMPROC_FLAG} 2
    ${CMAKE_INSTALL_PREFIX}/tests/${target})
endfunction()

function(add_test_mpi_0004_ranks target)
  add_test(NAME ${target}-mpi-0004 COMMAND
    ${MPIEXEC_EXECUTABLE} ${CTESTMPI_CUSTOM_MPIFLAGS} ${MPIEXEC_NUMPROC_FLAG} 4
    ${CMAKE_INSTALL_PREFIX}/tests/${target})
endfunction()

function(add_test_variants test)
  add_test_common(${test} target)
  add_test_mpi_0001(${target})
  add_test_mpi_0002_ranks(${target})
  add_test_mpi_0004_ranks(${target})
endfunction()

file(GLOB TESTS *.c)
foreach (test ${TESTS})
  add_test_variants(${test})
endforeach()
