@echo off
echo:
echo *****************************************************************
echo *    Copy all libraries for deployment                          *
echo *                                                               *
echo *****************************************************************
echo:

set OPENSSL_DIR=%cd%\openssl
set KRB5_DIR=%cd%\krb5
set SASL_DIR=%cd%\cyrus-sasl
set FOLDER_LIST=%OPENSSL_DIR% %KRB5_DIR% %SASL_DIR%
set "EXEC_LIST=ccapiserver.exe klist.exe kinit.exe"

for /D %%D in (%FOLDER_LIST%) do (
    if not exist %%%D (
        echo "Folder %%D doesn't exist"
        exit /b 1
    )
)

set PACKAGE_DIR=%cd%\package
if exist %PACKAGE_DIR% rmdir %PACKAGE_DIR% /q /s
mkdir %PACKAGE_DIR%

for /D %%D in (%FOLDER_LIST%) do (
    call :copy_files %%D
)

ren %PACKAGE_DIR%\sasl2.dll libsasl2-3.dll

goto :eof

:copy_files
    for /r "%1" %%f in (*.*) do (
        if /I "%%~xf"==".dll" (
            xcopy /d /y %%f %PACKAGE_DIR%
        ) else (
            for %%a in (%EXEC_LIST%) do (
                if /I "%%a"=="%%~nxf" (
                    xcopy /d /y %%f %PACKAGE_DIR%
                )
            )
        )
    )
    goto :eof
