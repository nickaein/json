# number of parallel jobs for CTest
set(N 10)

###############################################################################
# Needed tools.
###############################################################################

# include(FindPython3)
# find_package(Python3 COMPONENTS Interpreter)

message(STATUS "🔖 CMake ${CMAKE_VERSION} (${CMAKE_COMMAND})")

find_program(ICPC_TOOL NAMES icpc)
execute_process(COMMAND ${ICPC_TOOL} --version OUTPUT_VARIABLE ICPC_TOOL_VERSION ERROR_VARIABLE ICPC_TOOL_VERSION)
string(REGEX MATCH "[0-9]+(\\.[0-9]+)+" ICPC_TOOL_VERSION "${ICPC_TOOL_VERSION}")
message(STATUS "🔖 Intel classic C++ Compiler ${ICPC_TOOL_VERSION} (${ICPC_TOOL})")

find_program(ICPX_TOOL NAMES icpx)
execute_process(COMMAND ${ICPX_TOOL} --version OUTPUT_VARIABLE ICPX_TOOL_VERSION ERROR_VARIABLE ICPX_TOOL_VERSION)
string(REGEX MATCH "[0-9]+(\\.[0-9]+)+" ICPX_TOOL_VERSION "${ICPX_TOOL_VERSION}")
message(STATUS "🔖 Intel LLVM-based C++ Compiler ${ICPX_TOOL_VERSION} (${ICPX_TOOL})")

# find_program(NINJA_TOOL NAMES ninja)
# execute_process(COMMAND ${NINJA_TOOL} --version OUTPUT_VARIABLE NINJA_TOOL_VERSION ERROR_VARIABLE NINJA_TOOL_VERSION)
# string(REGEX MATCH "[0-9]+(\\.[0-9]+)+" NINJA_TOOL_VERSION "${NINJA_TOOL_VERSION}")
# message(STATUS "🔖 Ninja ${NINJA_TOOL_VERSION} (${NINJA_TOOL})")


# the individual source files
file(GLOB_RECURSE SRC_FILES ${PROJECT_SOURCE_DIR}/include/nlohmann/*.hpp)

###############################################################################
# Thorough check with recent compilers
###############################################################################

set(ICPX_CXXFLAGS "-std=c++11                            \
    -Werror                                              \
    -Weverything                                         \
    -Wno-c++98-compat                                    \
    -Wno-c++98-compat-pedantic                           \
    -Wno-deprecated-declarations                         \
    -Wno-documentation-unknown-command                   \
    -Wno-exit-time-destructors                           \
    -Wno-extra-semi-stmt                                 \
    -Wno-padded                                          \
    -Wno-range-loop-analysis                             \
    -Wno-switch-enum -Wno-covered-switch-default         \
    -Wno-weak-vtables                                    \
")

set(ICPC_CXXFLAGS "-std=c++11                            \
    -Werror                                              \
")

add_custom_target(ci_test_intel_icpx
    COMMAND CXX=${ICPX_TOOL} CXXFLAGS=${ICPX_CXXFLAGS} ${CMAKE_COMMAND}
        -DCMAKE_BUILD_TYPE=Release #-GNinja
        -DJSON_BuildTests=ON -DJSON_MultipleHeaders=ON
        -S${PROJECT_SOURCE_DIR} -B${PROJECT_BINARY_DIR}/build_icpx
    COMMAND ${CMAKE_COMMAND} --build ${PROJECT_BINARY_DIR}/build_icpx
    # COMMAND cd ${PROJECT_BINARY_DIR}/build_icpx && ${CMAKE_CTEST_COMMAND} --parallel ${N} --output-on-failure
    COMMENT "Compile and test with Intel LLVM C++ Compiler using maximal warning flags"
)

add_custom_target(ci_test_intel_icpc
    COMMAND CXX=${ICPC_TOOL} CXXFLAGS=${ICPC_CXXFLAGS} ${CMAKE_COMMAND}
        -DCMAKE_BUILD_TYPE=Release #-GNinja
        -DJSON_BuildTests=ON -DJSON_MultipleHeaders=ON
        -S${PROJECT_SOURCE_DIR} -B${PROJECT_BINARY_DIR}/build_icpc
    COMMAND ${CMAKE_COMMAND} --build ${PROJECT_BINARY_DIR}/build_icpc
    # COMMAND cd ${PROJECT_BINARY_DIR}/build_icpc && ${CMAKE_CTEST_COMMAND} --parallel ${N} --output-on-failure
    COMMENT "Compile and test with Intel Classic C++ Compiler using maximal warning flags"
)

add_custom_target(ci_clean
    COMMAND rm -fr ${PROJECT_BINARY_DIR}/build_* ${JSON_CMAKE_FLAG_BUILD_DIRS} ${single_binaries}
    COMMENT "Clean generated directories"
)
