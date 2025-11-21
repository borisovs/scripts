@echo off
echo:
echo *****************************************************************
echo *    Before the build:                                          *
echo *                      1. Install MSYS2                         *
echo *                      2. Check the PATH to MSYS2 in script     *
echo *                      3. Check awk/cat/git                     *
echo *    https://github.com/msys2/msys2-installer/releases          *
echo *****************************************************************
echo:

set MSYS2_BIN=D:\msys64\usr\bin
set PATH=%PATH%;"%WindowsSdkVerBinPath%"\x86
set PATH=%PATH%;%MSYS2_BIN%

set KRB_INSTALL_DIR=%cd%\build
if exist %KRB_INSTALL_DIR% rmdir %KRB_INSTALL_DIR% /q /s
mkdir %KRB_INSTALL_DIR%

set OPENSSL_VERSION=3
set OPENSSL_DIR=%cd%\openssl

@echo on
cd src
@REM To skip building the graphical ticket manager
set NO_LEASH=1
nmake -f Makefile.in prep-windows
nmake NODEBUG=1
nmake install NODEBUG=1
@rem cd windows\installer\wix
@rem nmake [NODEBUG=1]
cd ..
