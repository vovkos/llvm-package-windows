@echo off

:: Reset and loop over arguments

set TARGET_CPU=
set TOOLCHAIN=
set CRT=
set CONFIGURATION=

:loop

if "%1" == "" goto :finalize
if /i "%1" == "x86" goto :x86
if /i "%1" == "i386" goto :x86
if /i "%1" == "amd64" goto :amd64
if /i "%1" == "x86_64" goto :amd64
if /i "%1" == "x64" goto :amd64
if /i "%1" == "msvc10" goto :msvc10
if /i "%1" == "msvc12" goto :msvc12
if /i "%1" == "msvc14" goto :msvc14
if /i "%1" == "libcmt" goto :libcmt
if /i "%1" == "msvcrt" goto :msvcrt
if /i "%1" == "dbg" goto :dbg
if /i "%1" == "debug" goto :dbg
if /i "%1" == "rel" goto :release
if /i "%1" == "release" goto :release

echo Invalid argument: '%1'
exit -1

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Platform

:x86
set TARGET_CPU=x86
set CMAKE_GENERATOR_SUFFIX=
shift
goto :loop

:amd64
set TARGET_CPU=amd64
set CMAKE_GENERATOR_SUFFIX= Win64
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Toolchain

:msvc10
set TOOLCHAIN=msvc10
set CMAKE_GENERATOR=Visual Studio 10 2010
shift
goto :loop

:msvc12
set TOOLCHAIN=msvc12
set CMAKE_GENERATOR=Visual Studio 12 2013
shift
goto :loop

:msvc14
set TOOLCHAIN=msvc14
set CMAKE_GENERATOR=Visual Studio 14 2015
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: CRT

:libcmt
set CRT=libcmt
set LLVM_CRT=MT
shift
goto :loop

:msvcrt
set CRT=msvcrt
set LLVM_CRT=MD
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Configuration

:release
set CONFIGURATION=Release
set DEBUG_SUFFIX=
set LLVM_CMAKE_CONFIGURE_EXTRA_FLAGS=
set CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS=
shift
goto :loop

:: don't try to build Debug tools -- executables will be huge and not really
:: essential (whoever needs tools, can just download a Release build)

:dbg
set CONFIGURATION=Debug
set DEBUG_SUFFIX=-dbg
set CMAKE_CONFIGURE_EXTRA_FLAGS=-DLLVM_INCLUDE_TOOLS=OFF
set CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS=-DCLANG_BUILD_TOOLS=OFF
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:finalize

if "%TARGET_CPU%" == "" goto :amd64
if "%TOOLCHAIN%" == "" goto :msvc14
if "%CRT%" == "" goto :libcmt
if "%CONFIGURATION%" == "" goto :release

set LLVM_VERSION=8.0.0
set LLVM_DOWNLOAD_FILE=llvm-%LLVM_VERSION%.src.tar.xz
set LLVM_DOWNLOAD_URL=http://releases.llvm.org/%LLVM_VERSION%/%LLVM_DOWNLOAD_FILE%
set LLVM_RELEASE_NAME=llvm-%LLVM_VERSION%-windows-%TARGET_CPU%-%TOOLCHAIN%-%CRT%%DEBUG_SUFFIX%
set LLVM_RELEASE_FILE=%LLVM_RELEASE_NAME%.7z
set LLVM_RELEASE_DIR=%APPVEYOR_BUILD_FOLDER%\%LLVM_RELEASE_NAME%
set LLVM_INSTALL_PREFIX=%LLVM_RELEASE_DIR:\=/%

set LLVM_CMAKE_CONFIGURE_FLAGS= ^
	-G "%CMAKE_GENERATOR%%CMAKE_GENERATOR_SUFFIX%" ^
	-DCMAKE_INSTALL_PREFIX=%LLVM_INSTALL_PREFIX% ^
	-DLLVM_USE_CRT_DEBUG=%LLVM_CRT%d ^
	-DLLVM_USE_CRT_RELEASE=%LLVM_CRT% ^
	-DLLVM_USE_CRT_MINSIZEREL=%LLVM_CRT% ^
	-DLLVM_USE_CRT_RELWITHDEBINFO=%LLVM_CRT% ^
	-DLLVM_TARGETS_TO_BUILD=X86 ^
	-DLLVM_ENABLE_TERMINFO=OFF ^
	-DLLVM_ENABLE_ZLIB=OFF ^
	-DLLVM_INCLUDE_BENCHMARKS=OFF ^
	-DLLVM_INCLUDE_DOCS=OFF ^
	-DLLVM_INCLUDE_EXAMPLES=OFF ^
	-DLLVM_INCLUDE_GO_TESTS=OFF ^
	-DLLVM_INCLUDE_RUNTIMES=OFF ^
	-DLLVM_INCLUDE_TESTS=OFF ^
	-DLLVM_INCLUDE_UTILS=OFF ^
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON ^
	%LLVM_CMAKE_CONFIGURE_EXTRA_FLAGS%

set CLANG_DOWNLOAD_FILE=cfe-%LLVM_VERSION%.src.tar.xz
set CLANG_DOWNLOAD_URL=http://releases.llvm.org/%LLVM_VERSION%/%LLVM_DOWNLOAD_FILE%
set CLANG_RELEASE_NAME=clang-%LLVM_VERSION%-windows-%TARGET_CPU%-%TOOLCHAIN%-%CRT%%DEBUG_SUFFIX%
set CLANG_RELEASE_FILE=%CLANG_RELEASE_NAME%.7z
set CLANG_RELEASE_DIR=%APPVEYOR_BUILD_FOLDER%\%CLANG_RELEASE_NAME%
set CLANG_INSTALL_PREFIX=%CLANG_RELEASE_DIR:\=/%

set CLANG_CMAKE_CONFIGURE_FLAGS= ^
	-G "%CMAKE_GENERATOR%%CMAKE_GENERATOR_SUFFIX%" ^
	-DCMAKE_INSTALL_PREFIX=$CLANG_RELEASE_DIR ^
	-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION ^
	-DLLVM_DIR=%CD%/llvm/build/lib/cmake/llvm ^
	-DLLVM_TABLEGEN_EXE=%CD%/llvm/build/%CONFIGURATION%/bin/llvm-tblgen.exe ^
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON ^
	-DCLANG_INCLUDE_DOCS=OFF ^
	-DCLANG_INCLUDE_TESTS=OFF ^
	%CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS%

set CMAKE_BUILD_FLAGS= ^
	--config %CONFIGURATION% ^
	-- ^
	/nologo ^
	/verbosity:minimal ^
	/consoleloggerparameters:Summary

echo ---------------------------------------------------------------------------
echo LLVM_DOWNLOAD_URL:  %LLVM_DOWNLOAD_URL%
echo LLVM_RELEASE_FILE:  %LLVM_RELEASE_FILE%
echo CLANG_DOWNLOAD_URL: %CLANG_DOWNLOAD_URL%
echo CLANG_RELEASE_FILE: %CLANG_RELEASE_FILE%
echo ---------------------------------------------------------------------------
