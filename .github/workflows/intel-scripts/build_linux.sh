#!/bin/bash

# SPDX-FileCopyrightText: 2020 Intel Corporation
#
# SPDX-License-Identifier: MIT

BUILD_TYPE=$1

#shellcheck disable=SC2010
LATEST_VERSION=$(ls -1 /opt/intel/oneapi/compiler/ | grep -v latest | sort | tail -1)
# shellcheck source=/dev/null
source /opt/intel/oneapi/compiler/"$LATEST_VERSION"/env/vars.sh

case $BUILD_TYPE in
icpx)
  cmake -S . -B build_icpx -DJSON_CI=ci-intel
  cmake --build build_icpx --target ci_test_intel_icpx
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
