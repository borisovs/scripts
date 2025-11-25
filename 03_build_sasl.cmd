@echo off
echo:
echo *****************************************************************
echo *    Build the cyrus-sasl library                               *
echo *    https://github.com/borisovs/cyrus-sasl.git                 *
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

set KRB5_DIR=%cd%\krb5
set KRB5_LIBS=comerr64.lib;gssapi64.lib;k5sprt64.lib;krb5_64.lib;leashw64.lib;xpprof64.lib;

set SASL_DIR=%cd%\cyrus-sasl\
if exist %SASL_DIR% rmdir %SASL_DIR% /q /s
mkdir %SASL_DIR%

set OPENSSL_DIR=%cd%\openssl
set OPENSSL_INCLUDE=%OPENSSL_DIR%\include
set OPENSSL_LIBPATH=%OPENSSL_DIR%\lib

powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace '\(AdditionalIncludeDirectories\)', '(AdditionalIncludeDirectories);%OPENSSL_DIR%\include' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace '\(AdditionalLibraryDirectories\)', '(AdditionalLibraryDirectories);%OPENSSL_DIR%\lib' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\openssl.props') -replace 'libeay32', 'libcrypto' | Set-Content -Path '%SRC_DIR%\win32\openssl.props'"

powershell -command "(Get-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props') -replace 'KRB5_DIR', '%KRB5_DIR%' | Set-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props') -replace 'KRB5_LIB_DIR', '%KRB5_DIR%\lib' | Set-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props') -replace 'SASL_DIR', '%SASL_DIR%' | Set-Content -Path '%SRC_DIR%\win32\cyrus-sasl.props'"

@REM Enable static build of plugin_gssapiv2
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\plugin_gssapiv2.vcxproj') -replace 'KRB5_DIR', '%KRB5_DIR%' | Set-Content -Path '%SRC_DIR%\win32\plugin_gssapiv2.vcxproj'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\include\config.h') -replace '\/\* \#define STATIC_GSSAPIV2 1 \*\/', '#define STATIC_GSSAPIV2 1' | Set-Content -Path '%SRC_DIR%\win32\include\config.h'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\sasl2.vcxproj') -replace 'KRB5_DIR', '%KRB5_DIR%' | Set-Content -Path '%SRC_DIR%\win32\sasl2.vcxproj'"
powershell -command "(Get-Content -Path '%SRC_DIR%\win32\sasl2.vcxproj') -replace 'KRB5_LIBS', '%KRB5_LIBS%' | Set-Content -Path '%SRC_DIR%\win32\sasl2.vcxproj'"

@REM Start building
cd %SRC_DIR%\win32
msbuild cyrus-sasl-all-in-one.sln /p:PlatformToolset=%PlatformToolset% /p:WindowsTargetPlatformVersion=%WindowsTargetPlatformVersion% /p:Configuration=%Configuration%
cd ..\..
