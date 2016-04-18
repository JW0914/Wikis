###Information Directory
---
######Context Menu######
- Contains a registry file and VBS script in order to add a restore point creation option to the Context Menu

######RP Instant######
- VBS Script creates an instant restore point 
  - Has no ability to customize the name of the RP created

######RP with Confirmation######
- VBS Script creates an instant restore point, prompts for a description, and shows a success or error message upon completion

######RP with Description######
-  VBS Script creates an instant restore point and prompts for a description
 
######System Startup######
- VBS Script creates an instant restore point, containing a description of "System Startup", at System Startup
  - Description can be changed by editing 
    - __line 33:__ _sDesc = "System Startup"_
- Task Scheduler
  - XML export to be imported into Task Scheduler
    - Auto creates RP every time the system is initially booted or rebooted
    - _Action - Import Task..._
