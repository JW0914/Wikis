###Information Directory
---
######Explorer######
- Registry keys to add various cloud storage services to the Windows Explorer nav tree

######Hyper-V######
- Adds Hyper-V Manager to _Control Panel\Hardware and Sound_

######Notepad++######
- Changes the default "Edit" option in context menus from Notepad to Notepad++

######OpenSSL######
- Prebuilt custom OpenSSL config, including information and commands starting line 315

######PuTTY######
- Files and instructions required for a MultiHop SSH Tunnel or a TFTP firmware flash

######System Restore######
- Various system restore point creation scripts, with an accompanying Task Scheduler export

---

######_Registry Keys_######
- Some values will need to be customized to your environment
- Explorer keys must be pointed to the right directory within the key
  - _Paths in registry keys must use double backslashes "\\\"_
- System Restore keys must have the path of the VBS script set correctly
  - I recommend placing vbs scripts in a folder with no spaces, such as _%ProgramData%\Scripts_
 
