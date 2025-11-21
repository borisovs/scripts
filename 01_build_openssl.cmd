@echo off
echo:
echo *****************************************************************
echo *    Build the openssl library                                  *
echo *    https://github.com/openssl/openssl                         *
echo *****************************************************************
echo:

set SRC_DIR=%cd%\openssl-src\
@REM if exist %SRC_DIR% rmdir %SRC_DIR% /q /s
@REM git clone --recursive --depth 1 --single-branch --branch openssl-3.6.0 https://github.com/openssl/openssl.git %SRC_DIR%

set PATH=%PATH%;"C:\Program Files\NASM"
set PATH=%PATH%;"C:\Strawberry\perl\bin"
@REM cpan install Text::Template

set OPENSSL_DIR=%cd%\openssl\
if exist %OPENSSL_DIR% rmdir %OPENSSL_DIR% /q /s
mkdir %OPENSSL_DIR%

cd %SRC_DIR%
@REM perl Configure --prefix=%OPENSSL_DIR% --openssldir=%OPENSSL_DIR% VC-WIN64A no-shared enable-capieng
perl Configure --prefix=%OPENSSL_DIR% --openssldir=%OPENSSL_DIR% VC-WIN64A enable-capieng
nmake -f makefile
nmake install_sw
cd ..
