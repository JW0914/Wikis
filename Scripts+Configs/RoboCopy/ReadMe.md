### Information Directory ###
---

[**`RoboCopy`**][1] is one of the most efficient solutions to utilize for syncing directories on Windows

##### [File-Sync.cmd](File-Sync.cmd) #####
* Monitors the source for any changes and logs whenever a file is copied to the destination
  * **Date & Time:** _(Locale dependent)_
    * **`%date%`:**  Outputs a date in the following format: `yyyy.MM.dd`
    * **`%dtime%`:** Outputs time in the following format: `HHmmss` <br><br>
  * **Directories:**
    * **`%Dest%`:** Destination Directory
    * **`%LogDir%`:** Log Directory
    * **`%Src%`:** Source Directory <br><br>
  * **RoboCopy:**
    * **`%log%`:** Logging Options, outputs a log file in the following format `YYYY.MM.DD_HHMMSS.log`
       * **`/ETA`:** Show **E**stimated **T**ime of **A**rrival of copied files
       * **`/LOG:`:** Output status to **LOG** file
       * **`/NP`:** **N**o **P**rogress - don't display percentage copied
       * **`/TEE`:** Output to console window, as well as the log file <br> _Helpful if needing to run from a terminal occassionally_
       * **`/TS`:** Include source file **T**ime **S**tamps in the output
       * **`/V`:** Produce **V**erbose output, showing skipped files <br><br>
    * **`%opt%`:** Copy options
       * **`/MON`:** **MON**itor source; run again when more than `n` changes seen
       * **`/Z`:** Copy files in restartable mode <br><br>
    * **`%what%`:** What to copy
       * **`/COPY:DAT`:** what to **COPY** for files (default is `/COPY:DAT`) <br> _Copy Flags: **D**=Data, **A**=Attributes, **T**=Timestamps_
       * **`/DCOPY:DAT`:** Same as above, except for directories
       * **`/E`:** copy subdirectories, including **E**mpty ones
       * **`/XD`:** E**X**clude **D**irectories matching given names/paths <br> _Required if Log Directory is stored in the Source directory_
       * **`/XN`:** e**X**clude **N**ewer files <br><br>
    * **`/SAVE`:** **SAVE** parameters to the named job file <br> _Outputs job file to: `C:\ProgramData\Scripts\Robocopy\File-Sync.rcj`_ <br>

##### [NoShell-RoboCopy.vbs](NoShell-RoboCopy.vbs) #####

- Runs [`File-Sync.cmd`](File-Sync.cmd) with no shell _(intended for use when running `File-Sync.cmd` as a task)_.  To execute:
  ```bat
  wscript "C:\ProgramData\Scripts\Robocopy\NoShell-RoboCopy.vbs" "C:\ProgramData\Scripts\Robocopy\File-Sync.cmd"
  ```

##### [File-Sync.xml](File-Sync.xml) #####

- Task Scheduler task that runs 30s after login
  
  
  [1]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
