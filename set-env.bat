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
if /i "%1" == "msvc16" goto :msvc16
if /i "%1" == "msvc17" goto :msvc17
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
set CMAKE_ARCH_OPTIONS=-A Win32
shift
goto :loop

:amd64
set TARGET_CPU=amd64
set CMAKE_GENERATOR_SUFFIX= Win64
set CMAKE_ARCH_OPTIONS=-A x64
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

:msvc16
set TOOLCHAIN=msvc16
set CMAKE_GENERATOR=Visual Studio 16 2019
set CMAKE_USE_ARCH_OPTIONS=true
shift
goto :loop

:msvc17
set TOOLCHAIN=msvc17
set CMAKE_GENERATOR=Visual Studio 17 2022
set CMAKE_USE_ARCH_OPTIONS=true
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: CRT

:libcmt
set CRT=libcmt
set LLVM_CRT=MT
set CMAKE_CRT="MultiThreaded$<$<CONFIG:Debug>:Debug>"
shift
goto :loop

:msvcrt
set CRT=msvcrt
set LLVM_CRT=MD
set CMAKE_CRT="MultiThreaded$<$<CONFIG:Debug>:Debug>DLL"
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Configuration

:release
set CONFIGURATION=Release
set DEBUG_SUFFIX=
set LLVM_TARGETS=X86;NVPTX;AMDGPU
set LLVM_CMAKE_CONFIGURE_EXTRA_FLAGS=
set CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS=
shift
goto :loop

:: don't try to build Debug tools -- executables will be huge and not really
:: essential (whoever needs tools, can just download a Release build)

:dbg
set CONFIGURATION=Debug
set DEBUG_SUFFIX=-dbg
set LLVM_TARGETS=X86
set LLVM_CMAKE_CONFIGURE_EXTRA_FLAGS=-DLLVM_BUILD_TOOLS=OFF
set CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS=-DCLANG_BUILD_TOOLS=OFF
shift
goto :loop

::..............................................................................

:finalize

set WORKING_DRIVE=%HOMEDRIVE%
set WORKING_DIR=%HOMEDRIVE%%HOMEPATH%

set LLVM_RELEASE_TAG=llvm-%LLVM_VERSION%
set LLVM_CMAKELISTS_URL=https://raw.githubusercontent.com/llvm/llvm-project/main/llvm/CMakeLists.txt

if /i "%BUILD_MASTER%" == "true" (
	powershell "Invoke-WebRequest -Uri %LLVM_CMAKELISTS_URL% -OutFile CMakeLists.txt"
	for /f %%i in ('perl print-llvm-version.pl CMakeLists.txt') do set LLVM_VERSION=%%i
	set LLVM_RELEASE_TAG=llvm-master
)

if "%TARGET_CPU%" == "" goto :amd64
if "%TOOLCHAIN%" == "" goto :msvc14
if "%CRT%" == "" goto :libcmt
if "%CONFIGURATION%" == "" goto :release
if "%CMAKE_USE_ARCH_OPTIONS%" == "" (set CMAKE_GENERATOR=%CMAKE_GENERATOR%%CMAKE_ARCH_SUFFIX%)
if not "%CMAKE_USE_ARCH_OPTIONS%" == "" (set CMAKE_OPTIONS=%CMAKE_OPTIONS%%CMAKE_ARCH_OPTIONS%)

set TAR_SUFFIX=.tar.xz
perl compare-versions.pl %LLVM_VERSION% 3.5.0
if %errorlevel% == -1 set TAR_SUFFIX=.tar.gz

set BASE_DOWNLOAD_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-%LLVM_VERSION%
set BASE_DOWNLOAD_URL_LEGACY=http://releases.llvm.org/%LLVM_VERSION%
perl compare-versions.pl %LLVM_VERSION% 7.1.0
if %errorlevel% == -1 set BASE_DOWNLOAD_URL=%BASE_DOWNLOAD_URL_LEGACY%

:: exceptions: 8.0.0, 9.0.0 are still hosted on llvm.org

if %LLVM_VERSION% == 8.0.0 set BASE_DOWNLOAD_URL=%BASE_DOWNLOAD_URL_LEGACY%
if %LLVM_VERSION% == 9.0.0 set BASE_DOWNLOAD_URL=%BASE_DOWNLOAD_URL_LEGACY%

set CLANG_DOWNLOAD_FILE_PREFIX=clang-
perl compare-versions.pl %LLVM_VERSION% 9.0.0
if %errorlevel% == -1 set CLANG_DOWNLOAD_FILE_PREFIX=cfe-

set LLVM_MASTER_URL=https://github.com/llvm/llvm-project
set LLVM_DOWNLOAD_FILE=llvm-%LLVM_VERSION%.src%TAR_SUFFIX%
set LLVM_DOWNLOAD_URL=%BASE_DOWNLOAD_URL%/%LLVM_DOWNLOAD_FILE%
set LLVM_CMAKE_DOWNLOAD_FILE=cmake-%LLVM_VERSION%.src%TAR_SUFFIX%
set LLVM_CMAKE_DOWNLOAD_URL=%BASE_DOWNLOAD_URL%/%LLVM_CMAKE_DOWNLOAD_FILE%
set LLVM_THIRD_PARTY_DOWNLOAD_FILE=third-party-%LLVM_VERSION%.src%TAR_SUFFIX%
set LLVM_THIRD_PARTY_DOWNLOAD_URL=%BASE_DOWNLOAD_URL%/%LLVM_THIRD_PARTY_DOWNLOAD_FILE%
set LLVM_RELEASE_NAME=llvm-%LLVM_VERSION%-windows-%TARGET_CPU%-%TOOLCHAIN%-%CRT%%DEBUG_SUFFIX%
set LLVM_RELEASE_FILE=%LLVM_RELEASE_NAME%.7z
set LLVM_RELEASE_DIR=%WORKING_DIR%\%LLVM_RELEASE_NAME%
set LLVM_RELEASE_DIR=%LLVM_RELEASE_DIR:\=/%
set LLVM_RELEASE_URL=https://github.com/vovkos/llvm-package-windows/releases/download/%LLVM_RELEASE_TAG%/%LLVM_RELEASE_FILE%

perl compare-versions.pl %LLVM_VERSION% 15.0.0
if %errorlevel% == -1 set LLVM_CMAKE_DOWNLOAD_URL=

perl compare-versions.pl %LLVM_VERSION% 16.0.0
if %errorlevel% == -1 set LLVM_THIRD_PARTY_DOWNLOAD_URL=

set LLVM_CMAKE_CRT_FLAGS= -DCMAKE_MSVC_RUNTIME_LIBRARY=%CMAKE_CRT%

perl compare-versions.pl %LLVM_VERSION% 17.0.0
if %errorlevel% == -1 set LLVM_CMAKE_CRT_FLAGS= ^
	-DLLVM_USE_CRT_DEBUG=%LLVM_CRT%d ^
	-DLLVM_USE_CRT_RELEASE=%LLVM_CRT% ^
	-DLLVM_USE_CRT_MINSIZEREL=%LLVM_CRT% ^
	-DLLVM_USE_CRT_RELWITHDEBINFO=%LLVM_CRT%

set LLVM_CMAKE_CONFIGURE_FLAGS= ^
	-G "%CMAKE_GENERATOR%" ^
	%CMAKE_OPTIONS% ^
	-Thost=x64 ^
	-DCMAKE_INSTALL_PREFIX=%LLVM_RELEASE_DIR% ^
	-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=TRUE ^
	-DLLVM_TARGETS_TO_BUILD=%LLVM_TARGETS% ^
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
	%LLVM_CMAKE_CRT_FLAGS% ^
	%LLVM_CMAKE_CONFIGURE_EXTRA_FLAGS%

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

set CLANG_MASTER_URL=https://github.com/llvm-mirror/clang
set CLANG_DOWNLOAD_FILE=%CLANG_DOWNLOAD_FILE_PREFIX%%LLVM_VERSION%.src%TAR_SUFFIX%
set CLANG_DOWNLOAD_URL=%BASE_DOWNLOAD_URL%/%CLANG_DOWNLOAD_FILE%
set CLANG_RELEASE_NAME=clang-%LLVM_VERSION%-windows-%TARGET_CPU%-%TOOLCHAIN%-%CRT%%DEBUG_SUFFIX%
set CLANG_RELEASE_FILE=%CLANG_RELEASE_NAME%.7z
set CLANG_RELEASE_DIR=%WORKING_DIR%\%CLANG_RELEASE_NAME%
set CLANG_RELEASE_DIR=%CLANG_RELEASE_DIR:\=/%

set CLANG_CMAKE_CONFIGURE_FLAGS= ^
	-G "%CMAKE_GENERATOR%" ^
	%CMAKE_OPTIONS% ^
	-DCMAKE_INSTALL_PREFIX=%CLANG_RELEASE_DIR% ^
	-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=TRUE ^
	-DLLVM_INCLUDE_TESTS=OFF ^
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON ^
	-DCLANG_INCLUDE_DOCS=OFF ^
	-DCLANG_INCLUDE_TESTS=OFF ^
	-DLLVM_DIR=%LLVM_RELEASE_DIR%/lib/cmake/llvm ^
	%LLVM_CMAKE_CRT_FLAGS% ^
	%CLANG_CMAKE_CONFIGURE_EXTRA_FLAGS%

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

perl compare-versions.pl %LLVM_VERSION% 8.0.0
if %errorlevel% == -1 set CLANG_CMAKE_CONFIGURE_FLAGS= ^
	%CLANG_CMAKE_CONFIGURE_FLAGS% ^
	-DCLANG_PATH_TO_LLVM_BUILD=%LLVM_RELEASE_DIR% ^
	-DLLVM_MAIN_SRC_DIR=%LLVM_RELEASE_DIR%

perl compare-versions.pl %LLVM_VERSION% 3.5.0
if %errorlevel% == -1 set CLANG_CMAKE_CONFIGURE_FLAGS= ^
	%CLANG_CMAKE_CONFIGURE_FLAGS% ^
	-DLLVM_CONFIG=%LLVM_RELEASE_DIR%/bin/llvm-config

set CMAKE_BUILD_FLAGS= ^
	--config %CONFIGURATION% ^
	-- ^
	/nologo ^
	/verbosity:minimal ^
	/maxcpucount ^
	/consoleloggerparameters:Summary

if /i "%BUILD_PROJECT%" == "llvm" set DEPLOY_FILE=%LLVM_RELEASE_FILE%
if /i "%BUILD_PROJECT%" == "clang" set DEPLOY_FILE=%CLANG_RELEASE_FILE%

echo ---------------------------------------------------------------------------
echo LLVM_VERSION:                  %LLVM_VERSION%
echo LLVM_MASTER_URL:               %LLVM_MASTER_URL%
echo LLVM_DOWNLOAD_URL:             %LLVM_DOWNLOAD_URL%
echo LLVM_CMAKE_DOWNLOAD_URL:       %LLVM_CMAKE_DOWNLOAD_URL%
echo LLVM_THIRD_PARTY_DOWNLOAD_URL: %LLVM_THIRD_PARTY_DOWNLOAD_URL%
echo LLVM_RELEASE_FILE:             %LLVM_RELEASE_FILE%
echo LLVM_RELEASE_URL:              %LLVM_RELEASE_URL%
echo LLVM_CMAKE_CONFIGURE_FLAGS:    %LLVM_CMAKE_CONFIGURE_FLAGS%
echo ---------------------------------------------------------------------------
echo CLANG_DOWNLOAD_URL:            %CLANG_DOWNLOAD_URL%
echo CLANG_RELEASE_FILE:            %CLANG_RELEASE_FILE%
echo CLANG_CMAKE_CONFIGURE_FLAGS:   %CLANG_CMAKE_CONFIGURE_FLAGS%
echo ---------------------------------------------------------------------------
echo DEPLOY_FILE: %DEPLOY_FILE%
echo ---------------------------------------------------------------------------
