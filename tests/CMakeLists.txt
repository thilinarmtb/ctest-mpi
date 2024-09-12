enable_testing()

function(add_test_common test_with_path target)
  string(REPLACE "${CMAKE_SOURCE_DIR}/tests/" "" test_with_ext ${test_with_path})
  string(REPLACE ".c" "" test ${test_with_ext})
  add_executable(${test} ${test_with_path})
  target_compile_options(${test} PRIVATE $<$<C_COMPILER_ID:MSVC>:/W4 /WX>
    $<$<NOT:$<C_COMPILER_ID:MSVC>>:-Wall -Wextra -Wpedantic>)
  set_target_properties(${test} PROPERTIES VERSION ${PROJECT_VERSION})
  install(TARGETS ${test} RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/tests)
  set(${target} ${test} PARENT_SCOPE)
endfunction()

function(add_test_serial test)
  add_test_common(${test} target)
  add_test(NAME ${target} COMMAND ${CMAKE_INSTALL_PREFIX}/tests/${target})
endfunction()

file(GLOB TESTS *.c)
foreach (test ${TESTS})
  add_test_serial(${test})
endforeach()
