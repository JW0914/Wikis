:: #
               :: #[[---  RoboCopy File Sync Script ---]] # ::

:: #=========================================================================

@echo off

:: # Variables #
:: #-------------------------------------------------------------------------

   :: # Date:
      set Date=%date:~0,4%%date:~5,2%%date:~8,2%

   :: # Time:
      :: # Hour:
         set Hour=%time:~0,2%
         if "%hour:~0,1%" == " "  set HH=0%hour:~1,1%

      :: # Minute:
         set MM=%time:~3,2%

      :: # Seconds
         set SS=%time:~6,2%

      set Dtime=%HH%%mm%%ss%

   :: # Directories:
      :: # Destination:
         set Dest=C:\Destination

      :: # Log:
         set LogDir=D:\Source\Logs

      :: # Source:
         set Src=D:\Source

   :: # RoboCopy:
      :: # Log:
         set Log=/ETA /LOG:"%LogDir%\%date%_%dtime%.log" /NP /TEE /TS /V

      :: # Options:
         set Opt=/MON:1 /Z
             :: # /TBD - Use if copying to/from a network location

      :: # What to Copy:
         set What=/COPY:DAT /DCOPY:DAT /E /XD Logs /XN

      :: # Save Job:
         set Save=/SAVE:C:\ProgramData\Scripts\Robocopy\File-Sync

:: # Sync ::
:: #-------------------------------------------------------------------------
   RoboCopy %Src% %Dest% %Log% %Opt% %What% %Save%
