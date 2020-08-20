### Information Directory ###
---
_I cover this in more detail on [Superuser][1]_

The [Component Store][2] [`%WinDir%\WinSxS`] maintains a backup copy of all Windows system files and the following tasks/command sequences must be executed in the order listed [1 - 5], as each relies upon what the preceding one does:

To import into Task Scheduler:
 - **GUI:**
   1. **<kbd>[![WinKey][3]][3]</kbd>+<kbd>R</kbd>** → Open: `TaskSchd.msc`
   2. _Action_ → _New Folder..._ → Name: `Custom`
   3. _Action_ → _Import Task..._ → `<task_name>.xml` <br><br>
 - **CLI:**
   - **[`Cmd`][4]:**
      ```bat
      SchTasks /Create /xml "%UserProfile%\Downloads\<task_name>.xml" /tn "\Custom\Task Name" /ru "%ComputerName%\%UserName%"
      ```
   - **[`Powershell`][5]:**
      ```pwsh
      Register-ScheduledTask -xml (Get-Content '$env:UserProfile\Downloads\<task_name>.xml' | Out-String) -TaskName "Task Name" -TaskPath "\Custom\" -User $env:ComputerName\$env:UserName –Force
      ```
---
 1. [DISM ComponentCleanup](Dism_ComponentCleanup.xml): [`Dism /Online /Cleanup-Image /StartComponentCleanup`][6] <br> _Executes weekly on Sundays at 11:30:00_
    - The Component Store should always be [cleaned][7] prior to running Windows Update, after an issue with Windows Update, and at least once a month, as it becomes dirty over time from updates occasionally breaking [hard links][8] <br><br>
 2. [DISM RestoreHealth](Dism_RestoreHealth.xml): [`Dism /Online /cleanup-Image /RestoreHealth`][9] <br> _Executes weekly on Sundays at 12:00:00_
    - Verify and fix any corruption in the Component Store by verifying against known good copies from the Windows Update servers, requiring an internet connection, else the offline method _(**a** through **c** below)_ will be required and may not correct the issue: <br><br> Use the `install.esd`||`install.wim` from the [Windows Install ISO][10]  for the installed Windows version _(v1909, v2004, etc.)_:
      1. _Create Windows 10 installation media_ → _Download tool now_ → Choose to _install on another PC_
      2. Mount the ISO and determine the installed OS [index][11] [image] from the `install.esd`||`install.wim`:
         ```pwsh
         DISM /Get-ImageInfo /ImageFile:"Z:\sources\install.esd"
         ```
      3. Specify the index number at the end of the [`/Source`][12] parameter:
         ```pwsh
         # Online (while booted to Windows):
           # ESD:
             DISM /Online /Cleanup-Image /RestoreHealth /Source:esd:"Z:\sources\install.esd":6 /LimitAccess

           # WIM:
             DISM /Online /Cleanup-Image /RestoreHealth /Source:wim:"Z:\sources\install.wim":6 /LimitAccess

         # Offline (while booted to WinPE/WinRE):
           DISM /Image:"D:\Windows" /Cleanup-Image /RestoreHealth /Source:esd:"Z:\sources\install.esd":6 /LimitAccess
           # C: is usually not the drive letter in WinPE/WinRE
           # To ascertain: DiskPart → Lis Vol → Exit
         ```
 3. Reboot _(If errors are found, review the `%WinDir%\Logs\DISM\dism.log`, starting from the bottom up)_
    - Log files are easier to read and sift through via the [Log syntax][13] in [VS Code][14] <br><br>
 4. [SFC ScanNow](Sfc_ScanNow.xml): [`SFC /ScanNow`][15] <br> _Executes weekly on Sundays at 13:00:00_
    - Verify and fix any corruption within `%WinDir%` by verifying against known good copies in the Component Store
      - SFC always assumes the Component Store is not corrupted and is why the `DISM` `/RestoreHealth` parameter should always be run prior to `SFC`; Not doing so allows a corrupted Component Store to potentially replace a good system file with a corrupted one due to the hash mismatch <br><br>
 5. Reboot _(If errors were found, review the `%WinDir%\Logs\CBS\CBS.log`, starting from the bottom up)_


  [1]: https://superuser.com/q/1579030/529800
  [2]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/manage-the-component-store
  [3]: https://i.stack.imgur.com/RVqhe.png
  [4]: https://docs.microsoft.com/en-us/windows/win32/taskschd/schtasks
  [5]: https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/register-scheduledtask
  [6]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder#dismexe
  [7]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder
  [8]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/manage-the-component-store#hard-links
  [9]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/repair-a-windows-image
  [10]: https://www.microsoft.com/en-us/software-download/windows10
  [11]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s14#get-imageinfo
  [12]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-a-windows-repair-source
  [13]: https://stackoverflow.com/a/30776845/6819406
  [14]: https://code.visualstudio.com/
  [15]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/sfc
