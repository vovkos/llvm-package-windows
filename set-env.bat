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
if /i "%1" == "msvc15" goto :msvc15
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

:msvc15
set TOOLCHAIN=msvc15
set CMAKE_GENERATOR=Visual Studio 15 2017
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
set LLVM_CMAKE_CONFIGURE_EXTRA_FLAGS=-DLLVM_BUILD_TOOLS=OFF -DLLVM_OPTIMIZED_TABLEGEN=ON
set CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS=-DCLANG_BUILD_TOOLS=OFF
shift
goto :loop

::..............................................................................

:finalize

set LLVM_CMAKELISTS_URL=https://raw.githubusercontent.com/llvm-mirror/llvm/master/CMakeLists.txt

if /i "%BUILD_MASTER%" == "true" (
	appveyor DownloadFile %LLVM_CMAKELISTS_URL%
	for /f %%i in ('perl print-llvm-version.pl CMakeLists.txt') do set LLVM_VERSION=%%i
)

if "%TARGET_CPU%" == "" goto :amd64
if "%TOOLCHAIN%" == "" goto :msvc14
if "%CRT%" == "" goto :libcmt
if "%CONFIGURATION%" == "" goto :release

set TAR_SUFFIX=.tar.gz
if "%LLVM_VERSION%" geq "3.5.0" set TAR_SUFFIX=.tar.xz

set LLVM_MASTER_URL=https://github.com/llvm-mirror/llvm
set LLVM_DOWNLOAD_FILE=llvm-%LLVM_VERSION%.src%TAR_SUFFIX%
set LLVM_DOWNLOAD_URL=http://releases.llvm.org/%LLVM_VERSION%/%LLVM_DOWNLOAD_FILE%
set LLVM_RELEASE_NAME=llvm-%LLVM_VERSION%-windows-%TARGET_CPU%-%TOOLCHAIN%-%CRT%%DEBUG_SUFFIX%
set LLVM_RELEASE_FILE=%LLVM_RELEASE_NAME%.7z
set LLVM_RELEASE_DIR=%APPVEYOR_BUILD_FOLDER%\%LLVM_RELEASE_NAME%
set LLVM_RELEASE_DIR=%LLVM_RELEASE_DIR:\=/%
set LLVM_RELEASE_URL=https://github.com/vovkos/llvm-package-windows/releases/download/llvm-%LLVM_VERSION%/%LLVM_RELEASE_FILE%

set LLVM_CMAKE_CONFIGURE_FLAGS= ^
	-G "%CMAKE_GENERATOR%%CMAKE_GENERATOR_SUFFIX%" ^
	-DCMAKE_INSTALL_PREFIX=%LLVM_RELEASE_DIR% ^
	-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=TRUE ^
	-DLLVM_USE_CRT_DEBUG=%LLVM_CRT%d ^
	-DLLVM_USE_CRT_RELEASE=%LLVM_CRT% ^
	-DLLVM_USE_CRT_MINSIZEREL=%LLVM_CRT% ^
	-DLLVM_USE_CRT_RELWITHDEBINFO=%LLVM_CRT% ^
	-DLLVM_TARGETS_TO_BUILD=X86;AMDGPU;NVPTX ^
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

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

set CLANG_MASTER_URL=https://github.com/llvm-mirror/clang
set CLANG_DOWNLOAD_FILE=cfe-%LLVM_VERSION%.src%TAR_SUFFIX%
set CLANG_DOWNLOAD_URL=http://releases.llvm.org/%LLVM_VERSION%/%CLANG_DOWNLOAD_FILE%
set CLANG_RELEASE_NAME=clang-%LLVM_VERSION%-windows-%TARGET_CPU%-%TOOLCHAIN%-%CRT%%DEBUG_SUFFIX%
set CLANG_RELEASE_FILE=%CLANG_RELEASE_NAME%.7z
set CLANG_RELEASE_DIR=%APPVEYOR_BUILD_FOLDER%\%CLANG_RELEASE_NAME%
set CLANG_RELEASE_DIR=%CLANG_RELEASE_DIR:\=/%

set CLANG_CMAKE_CONFIGURE_FLAGS= ^
	-G "%CMAKE_GENERATOR%%CMAKE_GENERATOR_SUFFIX%" ^
	-DCMAKE_INSTALL_PREFIX=%CLANG_RELEASE_DIR% ^
	-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=TRUE ^
	-DLLVM_USE_CRT_DEBUG=%LLVM_CRT%d ^
	-DLLVM_USE_CRT_RELEASE=%LLVM_CRT% ^
	-DLLVM_USE_CRT_MINSIZEREL=%LLVM_CRT% ^
	-DLLVM_USE_CRT_RELWITHDEBINFO=%LLVM_CRT% ^
	-DLLVM_INCLUDE_TESTS=OFF ^
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON ^
	-DCLANG_INCLUDE_DOCS=OFF ^
	-DCLANG_INCLUDE_TESTS=OFF ^
	%CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS%

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

if "%LLVM_VERSION%" lss "3.5.0" (
	set CLANG_CMAKE_CONFIGURE_FLAGS= ^
		%CLANG_CMAKE_CONFIGURE_FLAGS% ^
		-DCLANG_PATH_TO_LLVM_BUILD=%LLVM_RELEASE_DIR% ^
		-DLLVM_MAIN_SRC_DIR=%LLVM_RELEASE_DIR%
) else if "%LLVM_VERSION%" lss "8.0.0" (
	set CLANG_CMAKE_CONFIGURE_FLAGS= ^
		%CLANG_CMAKE_CONFIGURE_FLAGS% ^
		-DLLVM_CONFIG=%LLVM_RELEASE_DIR%/bin/llvm-config
) else (
	set CLANG_CMAKE_CONFIGURE_FLAGS= ^
		%CLANG_CMAKE_CONFIGURE_FLAGS% ^
		-DLLVM_DIR=%LLVM_RELEASE_DIR%/lib/cmake/llvm
)

set CMAKE_BUILD_FLAGS= ^
	--config %CONFIGURATION% ^
	-- ^
	/nologo ^
	/verbosity:minimal ^
	/consoleloggerparameters:Summary

if /i "%BUILD_PROJECT%" == "llvm" set DEPLOY_FILE=%LLVM_RELEASE_FILE%
if /i "%BUILD_PROJECT%" == "clang" set DEPLOY_FILE=%CLANG_RELEASE_FILE%

echo ---------------------------------------------------------------------------
echo LLVM_VERSION:      %LLVM_VERSION%
echo LLVM_MASTER_URL:   %LLVM_MASTER_URL%
echo LLVM_DOWNLOAD_URL: %LLVM_DOWNLOAD_URL%
echo LLVM_RELEASE_FILE: %LLVM_RELEASE_FILE%
echo LLVM_RELEASE_URL:  %LLVM_RELEASE_URL%
echo LLVM_CMAKE_CONFIGURE_FLAGS: %LLVM_CMAKE_CONFIGURE_FLAGS%
echo ---------------------------------------------------------------------------
echo CLANG_MASTER_URL:   %CLANG_MASTER_URL%
echo CLANG_DOWNLOAD_URL: %CLANG_DOWNLOAD_URL%
echo CLANG_RELEASE_FILE: %CLANG_RELEASE_FILE%
echo CLANG_CMAKE_CONFIGURE_FLAGS: %CLANG_CMAKE_CONFIGURE_FLAGS%
echo ---------------------------------------------------------------------------
echo DEPLOY_TAR: %DEPLOY_TAR%
echo ---------------------------------------------------------------------------

set
