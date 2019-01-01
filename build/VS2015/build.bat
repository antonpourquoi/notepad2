@ECHO OFF
@rem ******************************************************************************
@rem *
@rem * Notepad2-mod
@rem *
@rem * build_vs2015.bat
@rem *   Batch file used to build Notepad2 with MSVC2015
@rem *
@rem * See License.txt for details about distribution and modification.
@rem *
@rem *                                     (c) XhmikosR 2010-2015
@rem *                                     https://github.com/XhmikosR/Notepad2-mod
@rem *
@rem ******************************************************************************

SETLOCAL ENABLEEXTENSIONS
CD /D %~dp0

SET "EXIT_ON_ERROR=%~4"

@rem Check the building environment
IF NOT DEFINED VS140COMNTOOLS CALL :SUBMSG "ERROR" "Visual Studio 2015 wasn't found!"


@rem Check for the help switches
IF /I "%~1" == "help"   GOTO SHOWHELP
IF /I "%~1" == "/help"  GOTO SHOWHELP
IF /I "%~1" == "-help"  GOTO SHOWHELP
IF /I "%~1" == "--help" GOTO SHOWHELP
IF /I "%~1" == "/?"     GOTO SHOWHELP


@rem Check for the first switch
IF "%~1" == "" (
  SET "BUILDTYPE=Build"
) ELSE (
  IF /I "%~1" == "Build"     SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Build"    SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Build"    SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Build"   SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "Clean"     SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Clean"    SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Clean"    SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Clean"   SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "Rebuild"   SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Rebuild"  SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Rebuild"  SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Rebuild" SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:CHECKSECONDARG
@rem Check for the second switch
IF "%~2" == "" (
  SET "ARCH=all"
) ELSE (
  IF /I "%~2" == "x86"   SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "/x86"  SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "-x86"  SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "--x86" SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "Win32"   SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "/Win32"  SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "-Win32"  SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "--Win32" SET "ARCH=Win32" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "x64"   SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "/x64"  SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "-x64"  SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "--x64" SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "all"   SET "ARCH=all" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "/all"  SET "ARCH=all" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "-all"  SET "ARCH=all" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "--all" SET "ARCH=all" & GOTO CHECKTHIRDARG

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:CHECKTHIRDARG
@rem Check for the third switch
IF "%~3" == "" (
  SET "CONFIG=Release"
) ELSE (
  IF /I "%~3" == "Debug"     SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "/Debug"    SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "-Debug"    SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "--Debug"   SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "Release"   SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "/Release"  SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "-Release"  SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "--Release" SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "all"       SET "CONFIG=all"     & GOTO START
  IF /I "%~3" == "/all"      SET "CONFIG=all"     & GOTO START
  IF /I "%~3" == "-all"      SET "CONFIG=all"     & GOTO START
  IF /I "%~3" == "--all"     SET "CONFIG=all"     & GOTO START

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:START
IF /I "%ARCH%" == "x64" GOTO x64
IF /I "%ARCH%" == "Win32" GOTO Win32


:Win32
CALL "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x86

IF /I "%CONFIG%" == "all" (CALL :SUBMSVC %BUILDTYPE% Debug Win32 && CALL :SUBMSVC %BUILDTYPE% Release Win32) ELSE (CALL :SUBMSVC %BUILDTYPE% %CONFIG% Win32)

IF /I "%ARCH%" == "Win32" GOTO END


:x64
CALL "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x86_amd64

IF /I "%CONFIG%" == "all" (CALL :SUBMSVC %BUILDTYPE% Debug x64 && CALL :SUBMSVC %BUILDTYPE% Release x64) ELSE (CALL :SUBMSVC %BUILDTYPE% %CONFIG% x64)


:END
TITLE Building Notepad2 with MSVC2015 - Finished!
ENDLOCAL
EXIT /B


:SUBMSVC
ECHO.
TITLE Building Notepad2 with MSVC2015 - %~1 "%~2|%~3"...
CD /D %~dp0
"MSBuild.exe" /nologo Notepad2.sln /target:Notepad2;%~1 /property:Configuration=%~2;Platform=%~3^ /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true
IF %ERRORLEVEL% NEQ 0 CALL :SUBMSG "ERROR" "Compilation failed!"
EXIT /B


:SHOWHELP
TITLE %~nx0 %1
ECHO. & ECHO.
ECHO Usage: %~nx0 [Clean^|Build^|Rebuild] [Win32^|x64^|all] [Debug^|Release^|all]
ECHO.
ECHO Notes: You can also prefix the commands with "-", "--" or "/".
ECHO        The arguments are not case sensitive.
ECHO. & ECHO.
ECHO Executing %~nx0 without any arguments is equivalent to "%~nx0 build all release"
ECHO.
ECHO If you skip the second argument the default one will be used.
ECHO The same goes for the third argument. Examples:
ECHO "%~nx0 rebuild" is the same as "%~nx0 rebuild all release"
ECHO "%~nx0 rebuild Win32" is the same as "%~nx0 rebuild Win32 release"
ECHO.
ECHO WARNING: "%~nx0 Win32" or "%~nx0 debug" won't work.
ECHO.
ENDLOCAL
EXIT /B


:SUBMSG
ECHO. & ECHO ______________________________
ECHO [%~1] %~2
ECHO ______________________________ & ECHO.
IF /I "%~1" == "ERROR" (
  IF "%EXIT_ON_ERROR%" == "" PAUSE
  EXIT /B
) ELSE (
  EXIT /B
)
