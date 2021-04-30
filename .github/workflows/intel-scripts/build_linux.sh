#!/bin/bash

# SPDX-FileCopyrightText: 2020 Intel Corporation
#
# SPDX-License-Identifier: MIT

LANGUAGE=$1

#git clone --depth 1 https://github.com/oneapi-src/oneAPI-samples.git

#shellcheck disable=SC2010
LATEST_VERSION=$(ls -1 /opt/intel/oneapi/compiler/ | grep -v latest | sort | tail -1)
# shellcheck source=/dev/null
# source /opt/intel/oneapi/compiler/"$LATEST_VERSION"/env/vars.sh
source /opt/intel/oneapi/setvars.sh

case $LANGUAGE in
build_linux_icpx)
  cmake -S . -B build_icpx -DJSON_CI=ci-intel
  cmake --build build_icpx --target ci_test_intel_icpx
  ;;
build_linux_icpc)
  cmake -S . -B build_icpc -DJSON_CI=ci-intel
  cmake --build build_icpc --target ci_test_intel_icpc
  # cd oneAPI-samples/DirectProgramming/C++/CompilerInfrastructure/Intrinsics
  # make && make run && make clean && make CC='icx -msse3' && make run
  ;;
fortran)
  cd oneAPI-samples/DirectProgramming/Fortran/CombinationalLogic/openmp-primes
  make && make run && make clean && make FC=ifx && make run
  ;;
dpc++)
#shellcheck disable=SC2010
  LATEST_VERSION=$(ls -1 /opt/intel/oneapi/tbb/ | grep -v latest | sort | tail -1)
# shellcheck source=/dev/null
  source /opt/intel/oneapi/tbb/"$LATEST_VERSION"/env/vars.sh
  cd oneAPI-samples/DirectProgramming/DPC++/DenseLinearAlgebra/vector-add
  make all && make run
  ;;
esac
