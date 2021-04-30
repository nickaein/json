REM SPDX-FileCopyrightText: 2020 Intel Corporation
REM
REM SPDX-License-Identifier: MIT

set BUILD_TYPE=%1
set VS_VER=%2

IF "%VS_VER%"=="2017_build_tools" (
@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
)

IF "%VS_VER%"=="2019_build_tools" (
@call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
)
for /f "tokens=* usebackq" %%f in (`dir /b "C:\Program Files (x86)\Intel\oneAPI\compiler\" ^| findstr /V latest ^| sort`) do @set "LATEST_VERSION=%%f"
@call "C:\Program Files (x86)\Intel\oneAPI\compiler\%LATEST_VERSION%\env\vars.bat"


if "%BUILD_TYPE%" == "build_win_icx" goto build_win_icx
if "%BUILD_TYPE%" == "build_win_icl" goto build_win_icl
@REM if "%LANGUAGE%" == "dpc++" goto dpcpp
goto exit

:build_win_icx
@REM  -DJSON_FastTests=ON
cmake -S . -B build_icx -G "NMake Makefiles" -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icx -DJSON_BuildTests=On -DCMAKE_BUILD_TYPE=Release
cmake --build build_icx --parallel 10
@REM cd build ; ctest -j 10 --output-on-failure
set RESULT=%ERRORLEVEL%
goto exit

:build_win_icl
cmake -S . -B build_icl -G "NMake Makefiles" -DCMAKE_C_COMPILER=icl -DCMAKE_CXX_COMPILER=icl -DJSON_BuildTests=On -DCMAKE_BUILD_TYPE=Release
cmake --build build_icl --parallel 10
@REM cd build ; ctest -j 10 --output-on-failure
set RESULT=%ERRORLEVEL%
goto exit

@REM icl -O2 src\intrin_dot_sample.cpp
@REM icl -O2 src\intrin_double_sample.cpp
@REM icl -O2 src\intrin_ftz_sample.cpp
@REM intrin_dot_sample.exe && intrin_double_sample.exe && intrin_ftz_sample.exe
@REM set RESULT=%ERRORLEVEL%
@REM del intrin_dot_sample.exe intrin_double_sample.exe intrin_ftz_sample.exe
@REM icx -O2 -msse3 src\intrin_dot_sample.cpp
@REM icx -O2 -msse3 src\intrin_double_sample.cpp
@REM icx -O2 -msse3 src\intrin_ftz_sample.cpp
@REM intrin_dot_sample.exe && intrin_double_sample.exe && intrin_ftz_sample.exe
@REM set /a RESULT=%RESULT%+%ERRORLEVEL%
@REM goto exit

@REM :fortran
@REM cd oneAPI-samples\DirectProgramming\Fortran\CombinationalLogic\openmp-primes
@REM ifort -O2 -fpp -qopenmp src\openmp_sample.f90
@REM openmp_sample.exe
@REM set RESULT=%ERRORLEVEL%
@REM ifx -O2 -fpp -qopenmp src\openmp_sample.f90
@REM openmp_sample.exe
@REM set /a RESULT=%RESULT%+%ERRORLEVEL%
@REM goto exit

@REM :dpcpp
@REM for /f "tokens=* usebackq" %%f in (`dir /b "C:\Program Files (x86)\Intel\oneAPI\tbb\" ^| findstr /V latest ^| sort`) do @set "LATEST_VERSION=%%f"
@REM @call "C:\Program Files (x86)\Intel\oneAPI\tbb\%LATEST_VERSION%\env\vars.bat"
@REM cd oneAPI-samples\DirectProgramming\DPC++\DenseLinearAlgebra\vector-add
@REM nmake -f Makefile.win
@REM nmake -f Makefile.win run
@REM set RESULT=%ERRORLEVEL%
@REM goto exit

:exit
exit /b %RESULT%
