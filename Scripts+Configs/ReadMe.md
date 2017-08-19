### Information Directory ###
---
###### ESD to WIM ######
- Scripts to create a standablone DISM folder and convert Windows ESD <-> WIM

###### Explorer ######
- Registry keys to add various cloud storage services to the Windows Explorer nav tree

###### File Associations ######
- Registry key to allow Windows to display PEM certs in GUI form

###### Hyper-V ######
- Adds Hyper-V Manager to _Control Panel\Hardware and Sound_

###### IPtables ######
- Custom IPtables script for SSH & VPN logging, as well as blocking commonly exploited ports

###### LEDE ######
- Auto creates a LEDE build environment on Ubuntu, as well as a Nano Makefile for LEDE/OpenWrt

###### Nginx ######
- Prebuilt custom Nginx server config for ownCloud running within a FreeNAS _[FreeBSD 11]_ jail

###### Notepad++ ######
- Changes the default "Edit" option in context menus from Notepad to Notepad++

###### OpenSSH ######
- Prebuilt BSD/Linux & Windows OpenSSH client and server configs

###### OpenSSL ######
- Prebuilt custom OpenSSL config, including information and commands starting line 500

###### OpenVPN ######
- Custom client and server OpenVPN configs

###### PuTTY ######
- Files and instructions required for a MultiHop SSH Tunnel or a TFTP firmware flash

###### QDir ######
- Custom QDir config file and a useful registry key for WinPE/RE

###### System Restore ######
- Various system restore point creation scripts, with an accompanying Task Scheduler export

###### WinRE ######
- Script to create a custom WinRE image and an accompanying bootable ISO, USB, or, VHD

---

###### _Registry Keys_ ######
- Some values will need to be customized to your environment
- Explorer keys must be pointed to the right directory within the key
  - _Paths in registry keys must use double backslashes_  `\\`
- System Restore keys must have the path of the VBS script set correctly
  - I recommend placing vbs scripts in a folder with no spaces, such as `%ProgramData%\Scripts`
 
