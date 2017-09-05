::
                    ::[[---  DISM Folder Creation Script  ---]]::

::================================================================
  :: Title:        DISM-Creation.cmd
  :: Description:  Creates a standalone DISM folder
  :: Author:       JW0914
  :: Created:      2017.05.13
  :: Updated:      2017.06.01
  :: Usage:        .\DISM-Creation.cmd
::================================================================


@echo off
pushd %~dp0

title DISM Custom Directory Creation
cls

    :: Custom Paramaters ::
::-------------------------------------

  :: ADK ::

    :: ADK Version:
       set ADKv=10

    :: ADK Options:
       set ADKopt=/q /ceip off /features OptionId.DeploymentTools OptionId.WindowsPreinstallationEnvironment /log "%CD%WindowsADK.log"


    :: Paramaters ::
::-------------------------------------

  :: Directories:
     set ADK="C:\Program Files (x86)\Windows Kits\%ADKv%\Assessment and Deployment Kit\Deployment Tools\%arch%"
     set DEST=%CD%DISM
     set DESTL=%CD%DISM\en-us

  :: Robocopy:
     set opt=/ETA /V /ZB
     set log=/NP /TEE /TS /LOG+:"%CD%DISM-RoboCopy_%date%_%dtime%.log"

  :: Date / Time:
     set date=%date:~0,4%%date:~5,2%%date:~8,2%
     set dtime=%time:~0,2%%time:~3,2%.%time:~6,2%



    :: Commands ::
::-------------------------------------

 :: Verify if Admin:
    %windir%\system32\reg.exe query "HKU\S-1-5-19" >nul 2>&1 || (
      cls
      color 4F

        echo.
        echo ===============================================================================
        echo   ---------------------------------------------------------------------------
        echo                             !!!  W A R N I N G  !!!
        echo   ---------------------------------------------------------------------------
        echo ===============================================================================
        echo.
        echo                          ADMIN PRIVILEGES NOT DETECTED
        echo.&echo.
        echo        -----------------------------------------------------------------
        echo.
        echo                This script requires administrator privileges!
        echo.
        echo                      ^(Select 'Run as administrator'^)
        echo.&echo.&echo.&echo.
        echo  Press any key to exit...
        echo.&echo.
        echo ===============================================================================

      pause >nul
      goto :eof
    )

 :: Create DISM Folder ::
    cls
    color 17

    echo.
    md %DESTL%

 :: Install ADK:
      echo.&echo.
      echo ===============================================================================
      echo   ---------------------------------------------------------------------------
      echo.
      echo                    Would you like to install the Windows ADK?
      echo.
      echo   ---------------------------------------------------------------------------
      echo ===============================================================================
      echo.
      echo  The ESD <-> WIM script will run fine by itself on Win ^>8.1, but not on ^<8.
      echo.
      echo.
      echo    To prevent depedence on the OS for DISM, we can create a DISM folder from
      echo.
      echo     which the ESD ^<-^> WIM script can call DISM by installing the Windows ADK
      echo.&echo.&echo.&echo.
      echo  The Windows ADK can be downloaded from:
      echo.
      echo  developer.microsoft.com/en-us/windows/hardware/windows-assessment-deployment-kit
      echo.&echo.
      echo     - Answer Yes:   Once ADKsetup.exe has been downloaded.
      echo.
      echo     - Answer No:    If the ADK Windows PE package is already installed
      echo.&echo.
      echo -------------------------------------------------------------------------------
      echo ===============================================================================
      echo.&echo.&echo.

    choice /C ynq /N /M " --->  Would you like to install the Windows ADK [Y/N or Q(uit)]?"
      IF %ERRORLEVEL% == 1 GOTO :ADKPATH
      IF %ERRORLEVEL% == 2 GOTO :ARCHITECTURE
      IF %ERRORLEVEL% == 3 GOTO :QUIT


:ADKPATH
  cls
  color 0E

    echo.
    echo ===============================================================================
    echo.
    echo                    Enter complete path to adksetup.exe file
    echo.
    echo                       ^(with quotes if contains spaces^)
    echo.
    echo ===============================================================================
    echo.&echo.

  set /p ADKsetup=

    echo.&echo.&echo.&echo.

  if "%ADKsetup%"=="" (
    color 0C

      echo.&echo.&echo.&echo.&echo.
      echo      ---------------------------------------------------------------------
      echo            !!!  P A T H    M U S T    B E    S P E C I F I E D  !!!
      echo      ---------------------------------------------------------------------
      echo.&echo.&echo.&echo.

    choice /M " --->  Would you like to re-enter path to ADKsetup.exe?"
        IF %ERRORLEVEL% == 1 GOTO :ADKPATH
        IF %ERRORLEVEL% == 2 GOTO :ARCHITECTURE
  )

  goto :ADKINSTALL


:ADKRETRY
  color 0C

    echo.&echo.&echo.&echo.
    echo      ---------------------------------------------------------------------
    echo            I N C O R R E C T    F I L E    N A M E    O R    P A T H
    echo      ---------------------------------------------------------------------
    echo.&echo.&echo.&echo.

  choice /M " --->  Would you like to re-enter path to ADKsetup.exe?"
      IF %ERRORLEVEL% == 1 GOTO :ADKPATH
      IF %ERRORLEVEL% == 2 GOTO :ARCHITECTURE


:ADKINSTALL
  cls

  call %ADKsetup% %ADKopt%
    if %ERRORLEVEL% == 0 goto :ARCHITECTURE
      goto :ADKRETRY


:ARCHITECTURE

 :: Determine Architecture:
    set p | findstr /i AMD64 > nul
      if not errorlevel 1 goto :X64
        goto :X86

:X64
  set arch=amd64
  set ADK="C:\Program Files (x86)\Windows Kits\%ADKv%\Assessment and Deployment Kit\Deployment Tools\%arch%"
  goto :LANGUAGE

:X86
  set arch=x86
  set ADK="C:\Program Files\Windows Kits\%ADKv%\Assessment and Deployment Kit\Deployment Tools\%arch%"
  goto :LANGUAGE


:LANGUAGE
  FOR /F "tokens=3" %%a IN ('reg query "HKCU\Control Panel\Desktop" /v PreferredUILanguages ^| find "PreferredUILanguages"') DO set lang=%%a

  cls
  color 0E

    echo.&echo.
    echo User Language: %lang%
    echo.&echo.

  goto :COPYDISM


:COPYDISM

 :: BCDBoot:
    echo.&echo.&echo.&echo.&echo.
    echo ===============================================================================
    echo   ---------------------------------------------------------------------------
    echo                           C O P Y I N G:  ADK\BCDBoot
    echo   ---------------------------------------------------------------------------
    echo ===============================================================================
    echo.&echo.

    robocopy %ADK%\BCDBoot\ %DEST% %opt% %log%

 :: DISM:
    echo.&echo.&echo.&echo.&echo.
    echo ===============================================================================
    echo   ---------------------------------------------------------------------------
    echo                            C O P Y I N G:  ADK\DISM
    echo   ---------------------------------------------------------------------------
    echo ===============================================================================
    echo.&echo.

    robocopy %ADK%\DISM\ %DEST% %opt% %log%

 :: Language:
    echo.&echo.&echo.&echo.&echo.
    echo ===============================================================================
    echo   ---------------------------------------------------------------------------
    echo                         C O P Y I N G:  ADK\DISM\^<lang^>
    echo   ---------------------------------------------------------------------------
    echo ===============================================================================
    echo.&echo.

    robocopy %ADK%\DISM\%lang%\ %DESTL% %opt% %log%

 :: OA30:
    echo.&echo.&echo.&echo.&echo.
    echo ===============================================================================
    echo   ---------------------------------------------------------------------------
    echo                       C O P Y I N G:  ADK\Licensing\OA30
    echo   ---------------------------------------------------------------------------
    echo ===============================================================================
    echo.&echo.

    robocopy %ADK%\OA30\ %DEST% %opt% %log%

 :: Oscdimg:
    echo.&echo.&echo.&echo.&echo.
    echo ===============================================================================
    echo   ---------------------------------------------------------------------------
    echo                           C O P Y I N G:  ADK\OSCDimg
    echo   ---------------------------------------------------------------------------
    echo ===============================================================================
    echo.&echo.

    robocopy %ADK%\Oscdimg\ %DEST% %opt% %log%

 :: RegHiveRecovery:
    echo.&echo.&echo.&echo.&echo.
    echo ===============================================================================
    echo   ---------------------------------------------------------------------------
    echo                       C O P Y I N G:  ADK\RegHiveRecovery
    echo   ---------------------------------------------------------------------------
    echo ===============================================================================
    echo.&echo.

    robocopy %ADK%\RegHiveRecovery\ %DEST% %opt% %log%

 :: Wdsmcast:
    echo.&echo.&echo.&echo.&echo.
    echo ===============================================================================
    echo   ---------------------------------------------------------------------------
    echo                          C O P Y I N G:  ADK\Wdsmcast
    echo   ---------------------------------------------------------------------------
    echo ===============================================================================
    echo.&echo.

    robocopy %ADK%\Wdsmcast\ %DEST% %opt% %log%

     :: Language:
        echo.&echo.&echo.&echo.&echo.
        echo ===============================================================================
        echo   ---------------------------------------------------------------------------
        echo                       C O P Y I N G:  ADK\Wdsmcast\^<lang^>
        echo   ---------------------------------------------------------------------------
        echo ===============================================================================
        echo.&echo.

        robocopy %ADK%\Wdsmcast\%lang%\ %DESTL% %opt% %log%

 :: Successful Completion:
    color 2A

      echo.&echo.&echo.&echo.&echo.&echo.
      echo ===============================================================================
      echo   ---------------------------------------------------------------------------
      echo.
      echo              Verify successful file copy via command or log output
      echo.
      echo   ---------------------------------------------------------------------------
      echo ===============================================================================
      echo.&echo.&echo.
      echo    Log Files:
      echo                ADK Install:  %CD%WindowsADK.log
      echo.
      echo                Robocopy:     %CD%DISM-RoboCopy_%date%_%dtime%.log
      echo.&echo.&echo.
      echo  Press any key to exit...

  pause >nul

  color 0C
  echo.

  choice /M " --->  Are you sure you want to exit?"
    SET ERRORTEMP=%ERRORLEVEL%
      IF %ERRORTEMP%==1 GOTO :QUIT
      IF %ERRORTEMP%==2 GOTO :WAIT


:WAIT
  color 0E&echo.&echo.&echo.&echo  When ready, press any key to exit...

  pause >nul&echo.&color 0C

  choice /M " --->  Are you sure you want to exit?"
    SET ERRORTEMP=%ERRORLEVEL%
      IF %ERRORTEMP%==1 GOTO :QUIT
      IF %ERRORTEMP%==2 GOTO :WAIT


:QUIT
  echo.&echo.
