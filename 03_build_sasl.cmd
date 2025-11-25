@echo off
echo:
echo *****************************************************************
echo *    Build the cyrus-sasl library                               *
echo *    https://github.com/cyrusimap/cyrus-sasl                    *
echo *****************************************************************
echo:

set PlatformToolset=v143
set WindowsTargetPlatformVersion=10.0.26100.0
set Configuration=Release

set GIT_BIN=D:\msys64\usr\bin
set PATH=%PATH%;%GIT_BIN%

set SRC_DIR=%cd%\cyrus-sasl-src\
if exist %SRC_DIR% rmdir %SRC_DIR% /q /s
git clone --recursive --depth 1 --single-branch --branch cyrus-sasl-2.1.28 https://github.com/borisovs/cyrus-sasl.git %SRC_DIR%

set OPENSSL_DIR=%cd%\openssl
set KRB5_DIR=%cd%\krb5
set SASL_DIR=%cd%\cyrus-sasl\
if exist %SASL_DIR% rmdir %SASL_DIR% /q /s
mkdir %SASL_DIR%
set OPENSSL_INCLUDE=%OPENSSL_DIR%\include
set OPENSSL_LIBPATH=%OPENSSL_DIR%\lib

powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace '\(AdditionalIncludeDirectories\)', '(AdditionalIncludeDirectories);%OPENSSL_DIR%\include' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace '\(AdditionalLibraryDirectories\)', '(AdditionalLibraryDirectories);%OPENSSL_DIR%\lib' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace 'libeay32', 'libcrypto' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"

powershell -command "(Get-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props') -replace 'KRB5_DIR', '%KRB5_DIR%' | Set-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props') -replace 'KRB5_LIB_DIR', '%KRB5_DIR%\lib' | Set-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props') -replace 'SASL_DIR', '%SASL_DIR%' | Set-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props'"



cd %SRC_DIR%\win32
msbuild cyrus-sasl-all-in-one.sln /p:PlatformToolset=%PlatformToolset% /p:WindowsTargetPlatformVersion=%WindowsTargetPlatformVersion% /p:Configuration=%Configuration%
cd ..\..
