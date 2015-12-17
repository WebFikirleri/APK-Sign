@ECHO OFF
COLOR 0A

SET file=%1

IF EXIST %file% GOTO BEGIN
IF NOT EXIST %file% GOTO FNF

:BEGIN
ECHO.
ECHO Welcome to APK Sign Tool
ECHO.
ECHO APL Sign Tool is created by Web Fikirleri ^& One Piece Soft
ECHO.
ECHO Let's begin to sign your APK
ECHO.
ECHO ====================================================================================
ECHO.
SET /P nfile="Please Enter New File Name: "
CLS
SET /P alias="Alias Name: "
GOTO CHECKKEY

:CHECKKEY
IF EXIST "%~dp0keys\%nfile%.keystore" GOTO ASKFORNEWKEY
IF NOT EXIST "%~dp0keys\%nfile%.keystore" GOTO GENKEY

:ASKFORNEWKEY
CLS
COLOR 0C
ECHO.
ECHO ====================================================================================
ECHO Keystore file already exists!
ECHO If you do not use your exists keystore file, existing keystore file will be deleted!
ECHO ====================================================================================
ECHO.
SET /P nkgen="Do you want to use exists keystore file? [y/n]"
COLOR 0A

:GENKEY
CLS
keytool -genkey -v -keystore "%~dp0keys\%nfile%.keystore" -alias %alias% -keyalg RSA -keysize 2048 -validity 999999

CLS
ECHO.
ECHO Your keystore file has been generated!
ECHO.
SET /P sign="Do you want to sign your APK file with this generated keystore file? [y/n]"
IF %sign%==y GOTO SIGN
IF %sign%==n GOTO EXIT

:SIGN
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore "%~dp0keys\%nfile%.keystore" -signedjar "%~dp0signed-apk\%nfile%-unaligned.apk" %file% "%alias%"
GOTO ALIGN

:ALIGN
"%~dp0bin\zipalign.exe" -f -v 4 "%~dp0signed-apk\%nfile%-unaligned.apk" "%~dp0signed-apk\%nfile%.apk"

CLS
SET /p delunalignedapk="Do you want to remove unaligned APK file? [y/n] :"
IF %delunalignedapk%==y GOTO REMUNALIGNED
IF %delunalignedapk%==n GOTO EXIT

:REMUNALIGNED
del "%~dp0signed-apk\%nfile%-unaligned.apk"
GOTO EXIT

:COLOR
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
GOTO EOF

:FNF
COLOR 0C
CLS
ECHO.
ECHO You have to drag and drop your APK file to the batch file... Exiting!
ECHO.
GOTO EXIT

:EXIT
ECHO All done!
pause

:EOF