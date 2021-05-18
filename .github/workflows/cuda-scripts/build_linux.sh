#!/bin/bash

BUILD_TYPE=$1

case $BUILD_TYPE in
nvcc)
  cmake -S . -B build_nvcc -DJSON_CI=ci-cuda
  cmake --build build_nvcc --target ci_test_nvcc
  ;;
icpc)
  cmake -S . -B build_icpc -DJSON_CI=ci-intel
  cmake --build build_icpc --target ci_test_intel_icpc
  ;;
# dpc++)
# #shellcheck disable=SC2010
#   LATEST_VERSION=$(ls -1 /opt/intel/oneapi/tbb/ | grep -v latest | sort | tail -1)
# # shellcheck source=/dev/null
#   source /opt/intel/oneapi/tbb/"$LATEST_VERSION"/env/vars.sh
#   cd oneAPI-samples/DirectProgramming/DPC++/DenseLinearAlgebra/vector-add
#   make all && make run
#   ;;
esac
