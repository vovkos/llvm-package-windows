@echo off

::..............................................................................

set THIS_DIR=%CD%

if /i "%1" == "llvm" goto :llvm
if /i "%1" == "clang" goto :clang

echo Invalid argument: '%1'
exit -1

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:llvm

mkdir llvm\build
cd llvm\build
cmake .. %LLVM_CMAKE_CONFIGURE_FLAGS%
cmake --build . %CMAKE_BUILD_FLAGS%
cmake --build . --target install %CMAKE_BUILD_FLAGS%

cd %THIS_DIR%

7z a -t7z %LLVM_RELEASE_FILE% %LLVM_RELEASE_NAME%

goto :eof

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:clang

mkdir llvm\build
cd llvm\build
cmake .. %LLVM_CMAKE_CONFIGURE_FLAGS%
cmake --build . %CMAKE_BUILD_FLAGS%
cmake --build . --target install %CMAKE_BUILD_FLAGS%

cd %THIS_DIR%

7z a -t7z %CLANG_RELEASE_FILE% %CLANG_RELEASE_NAME%

goto :eof

::..............................................................................
