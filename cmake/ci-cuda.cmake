# number of parallel jobs for CTest
set(N 10)

###############################################################################
# Needed tools.
###############################################################################

# include(FindPython3)
# find_package(Python3 COMPONENTS Interpreter)

message(STATUS "🔖 CMake ${CMAKE_VERSION} (${CMAKE_COMMAND})")

enable_language(CUDA)
find_package(CUDA REQUIRED)

find_program(NVCC_TOOL NAMES nvcc)
execute_process(COMMAND ${NVCC_TOOL} --version OUTPUT_VARIABLE NVCC_TOOL_VERSION ERROR_VARIABLE NVCC_TOOL_VERSION)
string(REGEX MATCH "[0-9]+(\\.[0-9]+)+" NVCC_TOOL_VERSION "${NVCC_TOOL_VERSION}")
message(STATUS "🔖 NVIDIA nvcc Compiler ${NVCC_TOOL_VERSION} (${NVCC_TOOL})")

find_program(NINJA_TOOL NAMES ninja)
execute_process(COMMAND ${NINJA_TOOL} --version OUTPUT_VARIABLE NINJA_TOOL_VERSION ERROR_VARIABLE NINJA_TOOL_VERSION)
string(REGEX MATCH "[0-9]+(\\.[0-9]+)+" NINJA_TOOL_VERSION "${NINJA_TOOL_VERSION}")
message(STATUS "🔖 Ninja ${NINJA_TOOL_VERSION} (${NINJA_TOOL})")

set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -std=c++11" )

# the individual source files
file(GLOB_RECURSE SRC_FILES ${PROJECT_SOURCE_DIR}/include/nlohmann/*.hpp)

set_source_files_properties(${SRC_FILES} PROPERTIES LANGUAGE CUDA)
set(CUDA_HOST_COMPILATION_CPP ON)

###############################################################################
# Thorough check with recent compilers
###############################################################################

set(NVCC_CXXFLAGS "")

add_custom_target(ci_test_nvcc
    COMMAND CXX=${NVCC_TOOL} CXXFLAGS=${NVCC_CXXFLAGS} ${CMAKE_COMMAND}
    # COMMAND ${CMAKE_COMMAND}
        -DCMAKE_BUILD_TYPE=Release -GNinja
        -DCMAKE_ENABLE_EXPORTS=OFF
        -DJSON_BuildTests=ON -DJSON_MultipleHeaders=ON
        -S${PROJECT_SOURCE_DIR} -B${PROJECT_BINARY_DIR}/build_nvcc
    COMMAND ${CMAKE_COMMAND} --build ${PROJECT_BINARY_DIR}/build_nvcc
    # COMMAND cd ${PROJECT_BINARY_DIR}/build_nvcc && ${CMAKE_CTEST_COMMAND} --parallel ${N} --output-on-failure
    COMMENT "Compile and test with NVIDIA nvcc Compiler using maximal warning flags"
)

set_property(TARGET ci_test_nvcc PROPERTY CUDA_STANDARD 11)

add_custom_target(ci_clean
    COMMAND rm -fr ${PROJECT_BINARY_DIR}/build_* ${JSON_CMAKE_FLAG_BUILD_DIRS} ${single_binaries}
    COMMENT "Clean generated directories"
)
