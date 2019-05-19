@echo off

::..............................................................................

:: delete unnecessary big directories

::	set DEL_DIR_LIST= ^
::		"c:\cygwin" ^
::		"c:\cygwin64" ^
::		"c:\winddk" ^
::		"c:\mingw" ^
::		"c:\mingw-64" ^
::		"c:\qt" ^
::		"c:\libraries" ^
::		"c:\Program Files\LLVM"
::
::	for %%f in (%DEL_DIR_LIST%) do (
::		if exist %%f (
::			echo Deleting: %%f
::			rd /S /Q %%f
::		)
::	)

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: get rid of annoying Xamarin build warnings

set DEL_FILE_LIST= ^
	"c:\Program Files (x86)\MSBuild\14.0\Microsoft.Common.targets\ImportAfter\Xamarin.Common.targets" ^
	"c:\Program Files (x86)\MSBuild\4.0\Microsoft.Common.targets\ImportAfter\Xamarin.Common.targets"

for %%f in (%DEL_FILE_LIST%) do (
	if exist %%f (
		echo Deleting: %%f
		del /F %%f
	)
)

if /i "%1" == "llvm" goto :llvm
if /i "%1" == "clang" goto :clang

echo Invalid argument: '%1'
exit -1

::..............................................................................

:llvm

:: download LLVM sources

appveyor DownloadFile %LLVM_DOWNLOAD_URL% -FileName %APPVEYOR_BUILD_FOLDER%\%LLVM_DOWNLOAD_FILE%
7z x -y %APPVEYOR_BUILD_FOLDER%\%LLVM_DOWNLOAD_FILE% -o%APPVEYOR_BUILD_FOLDER%
7z x -y %APPVEYOR_BUILD_FOLDER%\llvm-%LLVM_VERSION%.src.tar -o%APPVEYOR_BUILD_FOLDER%
ren %APPVEYOR_BUILD_FOLDER%\llvm-%LLVM_VERSION%.src llvm

if "%CONFIGURATION%" == "Debug" goto dbg
goto :eof

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: on Debug builds:
:: - patch llvm-config/CMakeLists.txt to always build and install llvm-config
:: - patch AddLLVM.cmake to also install PDBs on Debug builds

:dbg

echo set_target_properties(llvm-config PROPERTIES EXCLUDE_FROM_ALL FALSE) >> llvm/tools/llvm-config/CMakeLists.txt
echo install(TARGETS llvm-config RUNTIME DESTINATION bin) >> llvm/tools/llvm-config/CMakeLists.txt

perl pdb-patch.pl llvm\cmake\modules\AddLLVM.cmake

goto :eof

::..............................................................................

:clang

:: download Clang sources

appveyor DownloadFile %CLANG_DOWNLOAD_URL% -FileName %APPVEYOR_BUILD_FOLDER%\%CLANG_DOWNLOAD_FILE%
7z x -y %APPVEYOR_BUILD_FOLDER%\%CLANG_DOWNLOAD_FILE% -o%APPVEYOR_BUILD_FOLDER%
7z x -y %APPVEYOR_BUILD_FOLDER%\cfe-%LLVM_VERSION%.src.tar -o%APPVEYOR_BUILD_FOLDER%
ren %APPVEYOR_BUILD_FOLDER%\cfe-%LLVM_VERSION%.src clang

:: download and unpack LLVM release package from llvm-package-windows

appveyor DownloadFile %LLVM_RELEASE_URL% -FileName %APPVEYOR_BUILD_FOLDER%\%LLVM_RELEASE_FILE%
7z x -y %APPVEYOR_BUILD_FOLDER%\%LLVM_RELEASE_FILE% -o%APPVEYOR_BUILD_FOLDER%
;;

goto :eof

::..............................................................................
