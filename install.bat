@echo off

if not exist %WORKING_DIR% mkdir %WORKING_DIR%

::..............................................................................

if /i "%BUILD_PROJECT%" == "llvm" goto :llvm
if /i "%BUILD_PROJECT%" == "clang" goto :clang

echo Invalid argument: '%1'
exit -1

::..............................................................................

:llvm

:: download LLVM sources

if /i "%BUILD_MASTER%" == "true" (
	git clone --depth=1 %LLVM_MASTER_URL% %WORKING_DIR%\llvm-git
	move %WORKING_DIR%\llvm-git\llvm %WORKING_DIR%
) else (
	powershell "Invoke-WebRequest -Uri %LLVM_DOWNLOAD_URL% -OutFile %WORKING_DIR%\%LLVM_DOWNLOAD_FILE%"
	7z x -y %WORKING_DIR%\%LLVM_DOWNLOAD_FILE% -o%WORKING_DIR%
	7z x -y %WORKING_DIR%\llvm-%LLVM_VERSION%.src.tar -o%WORKING_DIR%
	ren %WORKING_DIR%\llvm-%LLVM_VERSION%.src llvm

	if not "%LLVM_CMAKE_DOWNLOAD_URL%" == "" (
		powershell "Invoke-WebRequest -Uri %LLVM_CMAKE_DOWNLOAD_URL% -OutFile %WORKING_DIR%\%LLVM_CMAKE_DOWNLOAD_FILE%"
		7z x -y %WORKING_DIR%\%LLVM_CMAKE_DOWNLOAD_FILE% -o%WORKING_DIR%
		7z x -y %WORKING_DIR%\cmake-%LLVM_VERSION%.src.tar -o%WORKING_DIR%
		ren %WORKING_DIR%\cmake-%LLVM_VERSION%.src cmake
	)
)

if "%CONFIGURATION%" == "Debug" goto dbg
goto :eof

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: on Debug builds:
:: - patch llvm-config/CMakeLists.txt to always build and install llvm-config
:: - patch AddLLVM.cmake to also install PDBs on Debug builds

:dbg

echo set_target_properties(llvm-config PROPERTIES EXCLUDE_FROM_ALL FALSE) >> %WORKING_DIR%\llvm\tools\llvm-config\CMakeLists.txt
echo install(TARGETS llvm-config RUNTIME DESTINATION bin) >> %WORKING_DIR%\llvm\tools\llvm-config\CMakeLists.txt

perl pdb-patch.pl %WORKING_DIR%\llvm\cmake\modules\AddLLVM.cmake

goto :eof

::..............................................................................

:clang

:: download Clang sources

if /i "%BUILD_MASTER%" == "true" (
	git clone --depth=1 %LLVM_MASTER_URL% %WORKING_DIR%\llvm-git
	move %WORKING_DIR%\llvm-git\clang %WORKING_DIR%
) else (
	powershell "Invoke-WebRequest -Uri %CLANG_DOWNLOAD_URL% -OutFile %WORKING_DIR%\%CLANG_DOWNLOAD_FILE%"
	7z x -y %WORKING_DIR%\%CLANG_DOWNLOAD_FILE% -o%WORKING_DIR%
	7z x -y %WORKING_DIR%\%CLANG_DOWNLOAD_FILE_PREFIX%%LLVM_VERSION%.src.tar -o%WORKING_DIR%
	ren %WORKING_DIR%\%CLANG_DOWNLOAD_FILE_PREFIX%%LLVM_VERSION%.src clang
)

perl compare-versions.pl %LLVM_VERSION% 11
if %errorlevel% == -1 goto nobigobj

perl compare-versions.pl %LLVM_VERSION% 12
if not %errorlevel% == -1 goto nobigobj

:: clang-11 requires /bigobj (fixed in clang-12)

set PATCH_TARGET=%WORKING_DIR%\clang\lib\ARCMigrate\CMakeLists.txt
echo Patching %PATCH_TARGET%...

echo. >> %PATCH_TARGET%
echo if (MSVC) >> %PATCH_TARGET%
echo   set_source_files_properties(Transforms.cpp PROPERTIES COMPILE_FLAGS /bigobj) >> %PATCH_TARGET%
echo endif() >> %PATCH_TARGET%

:nobigobj

:: download and unpack LLVM release package from llvm-package-windows

powershell "Invoke-WebRequest -Uri %LLVM_RELEASE_URL% -OutFile %WORKING_DIR%\%LLVM_RELEASE_FILE%"
7z x -y %WORKING_DIR%\%LLVM_RELEASE_FILE% -o%WORKING_DIR%
;;

goto :eof

::..............................................................................
