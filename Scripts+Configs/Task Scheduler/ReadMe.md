### Information Directory ###
---
The [Component Store][1] [`%WinDir%\WinSxS`] maintains a backup copy of all Windows system files and the following tasks/command sequences must be followed in the order listed below [1 - 5] due to each relying upon what the preceeding one does.

To import into Task Scheduler:
 - **GUI:**
   1. **<kbd>WinKey</kbd>+<kbd>R</kbd>** → Open: `TaskSchd.msc`
   2. _Action_ → _New Folder..._ → Name: `Custom`
   3. _Action_ → _Import Task..._ → `<task_name>.xml` <br><br>
 - **CLI:**
   - **`Cmd`:**
      ```bat
      SchTasks /Create /xml "%UserProfile%\Downloads\<task_name>.xml" /tn "\Custom\Task Name" /ru "%ComputerName%\%UserName%"
      ```
   - **`Powershell`:**
      ```pwsh
      Register-ScheduledTask -xml (Get-Content '$env:UserProfile\Downloads\<task_name>.xml' | Out-String) -TaskName "Task Name" -TaskPath "\Custom\" -User $env:ComputerName\$env:UserName –Force
      ```
---
 1. [DISM ComponentCleanup](Dism_ComponentCleanup.xml): [`Dism /Online /Cleanup-Image /StartComponentCleanup`][2] <br> _Executes weekly on Sundays at 11:30:00_
    - The Component Store should always be [cleaned][3] prior to running Windows Update, after an issue with Windows Update, and at least once a month, as it becomes dirty over time from updates occasionally breaking [hard links][4] <br><br>
 2. [DISM RestoreHealth](Dism_RestoreHealth.xml): [`Dism /Online /cleanup-Image /RestoreHealth`][5] <br> _Executes weekly on Sundays at 12:00:00_
    - Verify and fix any corruption in the Component Store by verifying against known good copies from the Windows Update servers, requiring an internet connection, else the offline method _(**a** through **c** below)_ will be required and may not correct the issue: <br><br> Use the `install.esd`||`install.wim` from the [Windows Install ISO][6]  for the installed Windows version _(v1909, v2004, etc.)_:
      1. _Create Windows 10 installation media_ → _Download tool now_ → Choose to _install on another PC_, saving it as an `.iso`
      2. The [index][7] [image] for the installed OS must be garnished from the `install.esd`||`install.wim`:
         ```pwsh
         DISM /Get-ImageInfo /ImageFile:"Z:\sources\install.esd"
         ```
      3. Specify the index number at the end of the [`/Source`][8] parameter:
         ```pwsh
         # ESD:
           DISM /Online /Cleanup-Image /RestoreHealth /Source:esd:"Z:\sources\install.esd":6 /LimitAccess
         
         # WIM:
           DISM /Online /Cleanup-Image /RestoreHealth /Source:wim:"Z:\sources\install.wim":6 /LimitAccess
         ```
         <br>
 3. Reboot
    - If errors are found, review the `%WinDir%\Logs\DISM\dism.log`, starting from the bottom up <br><br>
 4. [SFC ScanNow](Sfc_ScanNow.xml): [`SFC /ScanNow`][9] <br> _Executes weekly on Sundays at 13:00:00_
    - Verify and fix any corruption within `%WinDir%`:
      - SFC always assumes the Component Store is not corrupted, comparing all system files against the known good backups contained within the Component Store and is why the `DISM` `/RestoreHealth` parameter should always be run prior to `SFC`
      - Not doing so allows a corrupted Component Store to potentially replace a good system file with a corrupted one from within the corrupted Component Store due to a hash mismatch <br><br>
 5. Reboot
    - If errors were found, review the `%WinDir%\Logs\CBS\CBS.log`, starting from the bottom up


  [1]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/manage-the-component-store
  [2]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder#dismexe
  [3]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder
  [4]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/manage-the-component-store#hard-links
  [5]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/repair-a-windows-image
  [6]: https://www.microsoft.com/en-us/software-download/windows10
  [7]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s14#get-imageinfo
  [8]: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-a-windows-repair-source
  [9]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/sfc
