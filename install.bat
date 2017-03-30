@echo off

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Download LLVM

appveyor DownloadFile %LLVM_DOWNLOAD_URL% -FileName %APPVEYOR_BUILD_FOLDER%\%LLVM_DOWNLOAD_FILE%
7z x -y %APPVEYOR_BUILD_FOLDER%\%LLVM_DOWNLOAD_FILE% -o%APPVEYOR_BUILD_FOLDER%
7z x -y %APPVEYOR_BUILD_FOLDER%\llvm-%LLVM_VERSION%.src.tar -o%APPVEYOR_BUILD_FOLDER%
ren %APPVEYOR_BUILD_FOLDER%\llvm-%LLVM_VERSION%.src llvm

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Get rid of Xamarin annoying build warnings

del "c:\Program Files (x86)\MSBuild\14.0\Microsoft.Common.targets\ImportAfter\Xamarin.Common.targets"
del "c:\Program Files (x86)\MSBuild\4.0\Microsoft.Common.Targets\ImportAfter\Xamarin.Common.targets"
