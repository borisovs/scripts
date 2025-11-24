@echo off
echo:
echo *****************************************************************
echo *    Build the cyrus-sasl library                               *
echo *    https://github.com/cyrusimap/cyrus-sasl                    *
echo *****************************************************************
echo:

set GIT_BIN=D:\msys64\usr\bin
set PATH=%PATH%;%GIT_BIN%

set SRC_DIR=%cd%\cyrus-sasl-src\
if exist %SRC_DIR% rmdir %SRC_DIR% /q /s
git clone --recursive --depth 1 --single-branch --branch cyrus-sasl-2.1.28 https://github.com/borisovs/cyrus-sasl.git %SRC_DIR%

set OPENSSL_DIR=%cd%\openssl
set Krb5Dir=%cd%\krb5
set SASL_DIR=%cd%\cyrus-sasl\
if exist %SASL_DIR% rmdir %SASL_DIR% /q /s
mkdir %SASL_DIR%
set OPENSSL_INCLUDE=%OPENSSL_DIR%\include
set OPENSSL_LIBPATH=%OPENSSL_DIR%\lib

powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace '\(AdditionalIncludeDirectories\)', '(AdditionalIncludeDirectories);%OPENSSL_DIR%\include' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace '\(AdditionalLibraryDirectories\)', '(AdditionalLibraryDirectories);%OPENSSL_DIR%\lib' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace 'libeay32', 'libcrypto' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"

cd %SRC_DIR%\win32
@REM msbuild cyrus-sasl-common.sln /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0.26100.0  /p:Configuration=Release

msbuild cyrus-sasl-core.sln /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0.26100.0 /p:Configuration=Release
@REM msbuild sasl2.vcxproj /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0.26100.0
@REM msbuild cyrus-sasl-all-in-one.sln /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0.26100.0
cd ../..
