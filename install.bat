@echo off

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Delete unnecessary packages

rd /S /Q "c:\cygwin"
rd /S /Q "c:\cygwin64"
rd /S /Q "c:\winddk"
rd /S /Q "c:\mingw"
rd /S /Q "c:\mingw-w64"
rd /S /Q "c:\qt"
rd /S /Q "c:\Program Files\LLVM"
rd /S /Q "c:\Program Files\Microsoft Visual Studio 9.0"
rd /S /Q "c:\Program Files\Microsoft Visual Studio 10.0"
rd /S /Q "c:\Program Files\Microsoft Visual Studio 11.0"
rd /S /Q "c:\Program Files\Microsoft Visual Studio 12.0"
rd /S /Q "c:\Program Files (x86)\Microsoft Office"
rd /S /Q "c:\Program Files (x86)\Microsoft Office365 Tools"
rd /S /Q "c:\Program Files (x86)\Microsoft Visual Studio 9.0"
rd /S /Q "c:\Program Files (x86)\Microsoft Visual Studio 10.0"
rd /S /Q "c:\Program Files (x86)\Microsoft Visual Studio 11.0"
rd /S /Q "c:\Program Files (x86)\Microsoft Visual Studio 12.0"

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Get rid of annoying Xamarin build warnings

if exist "c:\Program Files (x86)\MSBuild\14.0\Microsoft.Common.targets\ImportAfter\Xamarin.Common.targets" (
	del "c:\Program Files (x86)\MSBuild\14.0\Microsoft.Common.targets\ImportAfter\Xamarin.Common.targets"
)

if exist "c:\Program Files (x86)\MSBuild\4.0\Microsoft.Common.targets\ImportAfter\Xamarin.Common.targets" (
	del "c:\Program Files (x86)\MSBuild\4.0\Microsoft.Common.targets\ImportAfter\Xamarin.Common.targets"
)

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Download LLVM

appveyor DownloadFile %LLVM_DOWNLOAD_URL% -FileName %APPVEYOR_BUILD_FOLDER%\%LLVM_DOWNLOAD_FILE%
7z x -y %APPVEYOR_BUILD_FOLDER%\%LLVM_DOWNLOAD_FILE% -o%APPVEYOR_BUILD_FOLDER%
7z x -y %APPVEYOR_BUILD_FOLDER%\llvm-%LLVM_VERSION%.src.tar -o%APPVEYOR_BUILD_FOLDER%
ren %APPVEYOR_BUILD_FOLDER%\llvm-%LLVM_VERSION%.src llvm

:: patch AddLLVM.cmake to also install PDBs on Debug builds

:: perl patch-add-llvm.pl llvm\cmake\modules\AddLLVM.cmake

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Download Clang

:: appveyor DownloadFile %CLANG_DOWNLOAD_URL% -FileName %APPVEYOR_BUILD_FOLDER%\%CLANG_DOWNLOAD_FILE%
:: 7z x -y %APPVEYOR_BUILD_FOLDER%\%CLANG_DOWNLOAD_FILE% -o%APPVEYOR_BUILD_FOLDER%
:: 7z x -y %APPVEYOR_BUILD_FOLDER%\cfe-%LLVM_VERSION%.src.tar -o%APPVEYOR_BUILD_FOLDER%
:: ren %APPVEYOR_BUILD_FOLDER%\cfe-%LLVM_VERSION%.src clang
