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

set SRC_DIR=%cd%\krb5-src\
if exist %SRC_DIR% rmdir %SRC_DIR% /q /s
git clone --recursive --depth 1 --single-branch --branch krb5-1.22.1-final https://github.com/krb5/krb5.git %SRC_DIR%

set KRB_INSTALL_DIR=%cd%\krb5
if exist %KRB_INSTALL_DIR% rmdir %KRB_INSTALL_DIR% /q /s
mkdir %KRB_INSTALL_DIR%

set OPENSSL_VERSION=3
set OPENSSL_DIR=%cd%\openssl

@echo on
cd %SRC_DIR%\src
@REM To skip building the graphical ticket manager
set NO_LEASH=1
nmake -f Makefile.in prep-windows
nmake NODEBUG=1
nmake install NODEBUG=1
@rem cd windows\installer\wix
@rem nmake [NODEBUG=1]
cd ..
