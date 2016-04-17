Contains a VBS Script which creates an instant restore point, containing a description of "System Startup", at System Startup
  - VBS script should be placed in a path with no spaces
    - For example: %ProgramData%\Scripts\SR\SystemStartup
  - Description can be changed by editing line 33:
    - sDesc = "System Startup"

Task Scheduler
  - Contains an xml export to be imported into Task Scheduler
    - Auto create a RP every time the system is initially booted or rebooted
