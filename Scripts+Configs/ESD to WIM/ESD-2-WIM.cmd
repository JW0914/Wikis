
                    ::[[---  ESD <-> WIM Conversion Script  ---]]::


@echo off

title ESD ^<-^> WIM

cls
color 0E

  echo.
  echo ===============================================================================
  echo.
  echo                   Enter complete path to install.esd/wim file
  echo.
  echo                 ^(without quotes, even if path contains spaces^)
  echo.
  echo ===============================================================================
  echo.
  echo.

set /p WIMFILE=
  if "%WIMFILE%"=="" color 0C&echo Incorrect file name or path&echo.&PAUSE&GOTO :QUIT

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
    echo.
    echo        -----------------------------------------------------------------
    echo.
    echo                This script requires administrator privileges!
    echo.
    echo                      ^(Select 'Run as administrator'^)
    echo.
    echo.
    echo.
    echo.
    echo  Press any key to exit...
    echo.
    echo.
    echo ===============================================================================

  pause >nul
  goto :eof
)

cd /d "%~dp0"
  if exist "%CD%\dism\dism.exe" set Path=%CD%\dism;%Path%

SET ERRORTEMP=
set /A count=0

dism /get-wiminfo /wimfile:"%WIMFILE%" >nul 2>&1 || (
  color 0C

    echo.
    echo.
    echo      ---------------------------------------------------------------------
    echo            I N C O R R E C T    F I L E    N A M E    O R    P A T H
    echo      ---------------------------------------------------------------------
    echo.
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  goto :eof
)

setlocal EnableDelayedExpansion
  FOR /F "tokens=2 delims=: " %%i IN ('dism /english /Get-WimInfo /WimFile:"%WIMFILE%" ^| findstr "Index"') DO SET images=%%i
  for /L %%i in (1, 1, %images%) do call :setcount %%i

if "%WIMFILE:~-3%"=="esd" GOTO :ESDMENU
if "%WIMFILE:~-3%"=="wim" GOTO :WIMMENU
exit


:setcount
  set /A count+=1
    for /f "tokens=1* delims=: " %%i in ('dism /english /get-wiminfo /wimfile:"%WIMFILE%" /index:%1 ^| find /i "Name"') do set name%count%="%%j"
  goto :eof


:ESDMENU
  cls
  color 0B

    echo ===============================================================================
    echo.                   Detected ESD image contains %images% indexes:
    echo.

  for /L %%i in (1, 1, %images%) do (
      echo.  %%i. !name%%i!
  )

    echo.
    echo ===============================================================================
    echo.                                  Options:
    echo -------------------------------------------------------------------------------
    echo.
    echo.                   1 - Export 1st index
    echo.                   2 - Export all indexes
    echo.                   3 - Export selected single index
    echo.                   4 - Export selected range of indexes
    echo.
    echo                    Q - Quit
    echo.
    echo -------------------------------------------------------------------------------
    echo ===============================================================================
    echo.

  choice /c 1234q /n /m "Choose a menu option: "
    SET ERRORTEMP=%ERRORLEVEL%
      IF %ERRORTEMP%==1 GOTO :ESD1
      IF %ERRORTEMP%==2 GOTO :ESD2
      IF %ERRORTEMP%==3 GOTO :ESD3
      IF %ERRORTEMP%==4 GOTO :ESD4
      IF %ERRORTEMP%==5 GOTO :QUIT
    GOTO :MAINMENU


:ESD1
  cls
  color 0B

  IF EXIST "%CD%\install.wim" (
    color 0C

      echo ===============================================================================
      echo.
      echo                  WIM file already present in current folder!
      echo.
      echo ===============================================================================
      echo.
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

    echo ===============================================================================
    echo.
    echo              ...Exporting ESD Index 1 to a new WIM image...
    echo.
    echo ===============================================================================
    echo.

  mkdir temp
    dism /Quiet /Capture-Image /ImageFile:install.wim /CaptureDir:.\temp /Name:container /Compress:max /CheckIntegrity
      rmdir /s /q temp

  dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:1 /DestinationImageFile:install.wim /compress:recovery /CheckIntegrity

  SET ERRORTEMP=%ERRORLEVEL%
    IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)

  dism /Quiet /Delete-Image /ImageFile:install.wim /Index:1 /CheckIntegrity

  color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:ESD2
  cls
  color 0B

  if "%images%"=="1" (
    color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

  for /L %%i in (2, 1, %images%) do (
      echo.
      echo ===============================================================================
      echo.
      echo                ...Exporting ESD Index %%i to an WIM image...
      echo.
      echo ===============================================================================

    dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%%i /DestinationImageFile:install.wim /compress:recovery /CheckIntegrity

    SET ERRORTEMP=%ERRORLEVEL%
      IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)
  )

  color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:ESD3
  cls
  color 0B

  set _index=

    echo ===============================================================================
    echo.                   Detected ESD image contains %images% indexes:
    echo.

  for /L %%i in (1, 1, %images%) do (
      echo.  %%i. !name%%i!
  )

    echo.
    echo ===============================================================================
    echo.                     Enter desired index number to export
    echo.
    echo.                          ^(0 - Return to Main Menu^)
    echo ===============================================================================

  set /p _index= ^>
    if /i "%_index%"=="0" goto :ESDMENU
    if [%_index%]==[] goto :ESD3
    if /i %_index% GTR %images% color 04&echo.&echo Selected number is higher than available indexes&echo.&PAUSE&goto :ESD3

  cls

  IF EXIST "%CD%\install.wim" (
    color 0C

      echo ===============================================================================
      echo.
      echo                  WIM file already present in current folder!
      echo.
      echo ===============================================================================
      echo.
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

    echo ===============================================================================
    echo.
    echo          ...Exporting ESD Index %_index% to a new WIM image...
    echo.
    echo ===============================================================================

  mkdir temp
    dism /Quiet /Capture-Image /ImageFile:install.wim /CaptureDir:.\temp /Name:container /Compress:max /CheckIntegrity
      rmdir /s /q temp

  dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%_index% /DestinationImageFile:install.wim /compress:recovery /CheckIntegrity
    SET ERRORTEMP=%ERRORLEVEL%
      IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)

  dism /Quiet /Delete-Image /ImageFile:install.wim /Index:1 /CheckIntegrity

  color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:ESD4
  cls
  color 0B

  set _range=
  set _start=
  set _end=

    echo ===============================================================================
    echo.                   Detected ESD image contains %images% indexes:
    echo.

  for /L %%i in (1, 1, %images%) do (
      echo.  %%i. !name%%i!
  )

    echo.
    echo ===============================================================================
    echo.             Enter desired Range of indexes to export ^(i.e. 2-4^)
    echo.
    echo.                          ^(0 - Return to Main Menu^)
    echo ===============================================================================

  set /p _range= ^>
    if /i "%_range%"=="0" goto :ESDMENU
    if [%_range%]==[] goto :ESD4

  for /f "tokens=1 delims=-" %%i in ('echo %_range%') do set _start=%%i
  for /f "tokens=2 delims=-" %%i in ('echo %_range%') do set _end=%%i
    if /i %_start% GTR %images% color 04&echo.&echo Range Start is higher than available indexes&echo.&PAUSE&goto :ESD4
    if /i %_end% GTR %images% color 04&echo.&echo Range End is higher than available indexes&echo.&PAUSE&goto :ESD4
    if /i %_start% EQU %_end% color 04&echo.&echo Range Start and End are equal. Use option 3 of main menu to export single index&echo.&PAUSE&goto :ESDMENU

  cls

  IF EXIST "%CD%\install.wim" (
    color 0C

      echo ===============================================================================
      echo.
      echo                  WIM file already present in current folder!
      echo.
      echo ===============================================================================
      echo.
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

    echo ===============================================================================
    echo.
    echo          ...Exporting ESD Index %_start% to a new WIM image...
    echo.
    echo ===============================================================================

  mkdir temp
    dism /Quiet /Capture-Image /ImageFile:install.wim /CaptureDir:.\temp /Name:container /Compress:max /CheckIntegrity
      rmdir /s /q temp

  dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%_start% /DestinationImageFile:install.wim /compress:recovery /CheckIntegrity

  SET ERRORTEMP=%ERRORLEVEL%
    IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)

  dism /Quiet /Delete-Image /ImageFile:install.wim /Index:1 /CheckIntegrity

  set /a _start+=1
    for /L %%i in (%_start%, 1, %_end%) do (
        echo.
        echo ===============================================================================
        echo.
        echo          ...Exporting ESD Index %%i to an WIM image...
        echo.
        echo ===============================================================================

      dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%%i /DestinationImageFile:install.wim /compress:recovery /CheckIntegrity

      SET ERRORTEMP=%ERRORLEVEL%
        IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)
    )

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:WIMMENU
  cls
  color 0A

    echo ===============================================================================
    echo.                   Detected WIM file contains %images% indexes:
    echo.

  for /L %%i in (1, 1, %images%) do (
      echo.  %%i. !name%%i!
  )

    echo.
    echo ===============================================================================
    echo.                                  Options:
    echo -------------------------------------------------------------------------------
    echo.
    echo.                   1 - Export 1st index
    echo.                   2 - Export all indexes
    echo.                   3 - Export selected single index
    echo.                   4 - Export selected range of indexes
    echo.
    echo                    Q - Quit
    echo.
    echo -------------------------------------------------------------------------------
    echo ===============================================================================
    echo.

  choice /c 1234q /n /m " Choose a menu option, or Q to quit: "
    SET ERRORTEMP=%ERRORLEVEL%
      IF %ERRORTEMP%==1 GOTO :WIM1
      IF %ERRORTEMP%==2 GOTO :WIM2
      IF %ERRORTEMP%==3 GOTO :WIM3
      IF %ERRORTEMP%==4 GOTO :WIM4
      IF %ERRORTEMP%==5 GOTO :QUIT
    GOTO :MAINMENU


:WIM1
  cls
  color 0A

  IF EXIST "%CD%\install.esd" (
    color 0C

      echo ===============================================================================
      echo.
      echo                  ESD file already present in current folder!
      echo.
      echo ===============================================================================
      echo.
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

    echo ===============================================================================
    echo.
    echo              ...Exporting WIM Index 1 to a new ESD image...
    echo.
    echo ===============================================================================
    echo.
    echo.
    echo       *** Be patient, this will require time and high CPU/Disk usage ***
    echo.
    echo.

  dism /export-image /sourceimagefile:"%WIMFILE%" /Sourceindex:1 /destinationimagefile:install.esd /compress:recovery /checkintegrity

  SET ERRORTEMP=%ERRORLEVEL%
    IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)

  color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:WIM2
  cls
  color 0A

  IF EXIST "%CD%\install.esd" (
    color 0C

      echo ===============================================================================
      echo.
      echo                  ESD file already present in current folder!
      echo.
      echo ===============================================================================
      echo.
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

  echo ===============================================================================
  echo.
  echo              ...Exporting WIM Index 1 to a new ESD image...
  echo.
  echo ===============================================================================
  echo.
  echo.
  echo       *** Be patient, this will require time and high CPU/Disk usage ***
  echo.
  echo.

  dism /Export-Image /SourceImageFile:"%WIMFILE%" /Sourceindex:1 /DestinationImageFile:install.esd /compress:recovery /CheckIntegrity

  SET ERRORTEMP=%ERRORLEVEL%
    IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)

  if "%images%"=="1" (
    color 2A

      echo.
      echo     Export successful...
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

  for /L %%i in (2, 1, %images%) do (
      echo.
      echo ===============================================================================
      echo.
      echo              ...Exporting WIM Index %%i to an ESD image...
      echo.
      echo ===============================================================================

    dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%%i /DestinationImageFile:install.esd /compress:recovery /CheckIntegrity

    SET ERRORTEMP=%ERRORLEVEL%
      IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)
  )

  color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:WIM3
  cls
  color 0A

  set _index=

    echo ===============================================================================
    echo.                   Detected WIM file contains %images% indexes:
    echo.

  for /L %%i in (1, 1, %images%) do (
      echo.  %%i. !name%%i!
  )

    echo.
    echo ===============================================================================
    echo.                     Enter desired index number to export
    echo.
    echo.                          ^(0 - Return to Main Menu^)
    echo ===============================================================================

  set /p _index= ^>
    if /i "%_index%"=="0" goto :WIMMENU
    if [%_index%]==[] goto :WIM3
    if /i %_index% GTR %images% color 04&echo.&echo Selected number is higher than available indexes&echo.&PAUSE&goto :WIM3

  cls
  color 0A

  IF EXIST "%CD%\install.esd" (
    color 0C

      echo ===============================================================================
      echo.
      echo                  ESD file already present in current folder!
      echo.
      echo ===============================================================================
      echo.
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

    echo ===============================================================================
    echo.
    echo          ...Exporting WIM Index %_index% to a new ESD image...
    echo.
    echo ===============================================================================
    echo.
    echo.
    echo       *** Be patient, this will require time and high CPU/Disk usage ***
    echo.
    echo.

  dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%_index% /DestinationImageFile:install.esd /compress:recovery /CheckIntegrity

  SET ERRORTEMP=%ERRORLEVEL%
    IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)

  color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:WIM4
  cls
  color 0A

  set _range=
  set _start=
  set _end=

    echo ===============================================================================
    echo.                   Detected WIM file contains %images% indexes:
    echo.

  for /L %%i in (1, 1, %images%) do (
      echo.  %%i. !name%%i!
  )

    echo.
    echo ===============================================================================
    echo.             Enter desired Range of indexes to export ^(i.e. 2-4^)
    echo.
    echo.                          ^(0 - Return to Main Menu^)
    echo ===============================================================================

  set /p _range= ^>
    if /i "%_range%"=="0" goto :WIMMENU
    if [%_range%]==[] goto :WIM4

  for /f "tokens=1 delims=-" %%i in ('echo %_range%') do set _start=%%i
  for /f "tokens=2 delims=-" %%i in ('echo %_range%') do set _end=%%i
    if /i %_start% GTR %images% color 04&echo.&echo Range Start is higher than available indexes&echo.&PAUSE&goto :WIM4
    if /i %_end% GTR %images% color 04&echo.&echo Range End is higher than available indexes&echo.&PAUSE&goto :WIM4
    if /i %_start% EQU %_end% color 04&echo.&echo Range Start and End are equal. Use option 3 of main menu to export single index&echo.&PAUSE&goto :WIMMENU

  cls
  color 0A

  IF EXIST "%CD%\install.esd" (
    color 0C

      echo ===============================================================================
      echo.
      echo                  ESD file already present in current folder!
      echo.
      echo ===============================================================================
      echo.
      echo.
      echo.
      echo Press any key to exit...

    pause >nul
    GOTO :QUIT
  )

    echo ===============================================================================
    echo.
    echo          ...Exporting WIM Index %_start% to a new ESD image...
    echo.
    echo ===============================================================================
    echo.
    echo.
    echo       *** Be patient, this will require time and high CPU/Disk usage ***
    echo.
    echo.

  dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%_start% /DestinationImageFile:install.esd /compress:recovery /CheckIntegrity

  SET ERRORTEMP=%ERRORLEVEL%
    IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)

  set /a _start+=1
    for /L %%i in (%_start%, 1, %_end%) do (
        echo.
        echo ===============================================================================
        echo.
        echo                ...Exporting WIM Index %%i to an ESD image...
        echo.
        echo ===============================================================================

      dism /Export-Image /SourceImageFile:"%WIMFILE%" /SourceIndex:%%i /DestinationImageFile:install.esd /compress:recovery /CheckIntegrity

      SET ERRORTEMP=%ERRORLEVEL%
        IF %ERRORTEMP% NEQ 0 (color 0C&echo.&echo Errors were reported during DISM export.&PAUSE&GOTO :QUIT)
    )

  color 2A

    echo.
    echo     Export successful...
    echo.
    echo.
    echo Press any key to exit...

  pause >nul
  GOTO :QUIT


:QUIT
  echo.&echo.
