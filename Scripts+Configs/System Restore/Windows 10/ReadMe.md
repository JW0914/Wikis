Context Menu
  - Contains a registry file and VBS script in order to add a restore point creation option to the Context Menu

RP Instant
  - Contains a VBS Script which creates an instant restore point 
  - Has no ability to customize the name of the RP created

RP with Confirmation
  - Contains a VBS Script which creates an instant restore point, prompts for a description, and shows a success or error message upon completion

RP with Description
  -  Contains a VBS Script which creates an instant restore point and prompts for a description
 
System Startup
  - Contains a VBS Script which creates an instant restore point, containing a description of "System Startup", at System Startup
    - Description can be changed by editing line 33:
      - sDesc = "System Startup"
  - Task Scheduler
    - Contains an xml export to be imported into Task Scheduler
      - Auto creates a RP every time the system is initially booted or rebooted
