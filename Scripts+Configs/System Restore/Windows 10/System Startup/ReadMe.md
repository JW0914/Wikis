###Information Directory###
---
######VBS######
- Creates a restore point at System Startup
  - Script should be placed in a path with no spaces
    - `%ProgramData%\Scripts\SR\SystemStartup`
  - Description can be changed by editing __Line 33__ 
    - `sDesc = "System Startup"`

######Task Scheduler######
  - XML export to be imported into Task Scheduler
    - Auto creates RP every time the system is initially booted or rebooted
