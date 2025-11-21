@echo off
echo:
echo *****************************************************************
echo *    Build the cyrus-sasl library                               *
echo *    https://github.com/cyrusimap/cyrus-sasl                    *
echo *****************************************************************
echo:

set SRC_DIR=%cd%\cyrus-sasl-src\
if exist %SRC_DIR% rmdir %SRC_DIR% /q /s
git clone --recursive --depth 1 --single-branch --branch cyrus-sasl-2.1.28 https://github.com/cyrusimap/cyrus-sasl.git %SRC_DIR%

set SASL_DIR=%cd%\cyrus-sasl\
if exist %SASL_DIR% rmdir %SASL_DIR% /q /s
mkdir %SASL_DIR%

cd %SRC_DIR%
cd ..
