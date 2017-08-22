### Information Directory ###
---
###### [ESD to WIM](ESD%20to%20WIM) ######
- Scripts to create a standablone DISM folder and convert Windows ESD <-> WIM

###### [Explorer](Explorer) ######
- Registry keys to add various cloud storage services to the Windows Explorer nav tree

###### [File Associations](File%20Associations) ######
- Registry key to allow Windows to display PEM certs in GUI form

###### [Hyper-V](Hyper-V) ######
- Adds Hyper-V Manager to _Control Panel\Hardware and Sound_

###### [IPtables](IPtables) ######
- Custom IPtables script for SSH & VPN logging, as well as blocking commonly exploited ports

###### [LEDE](LEDE) ######
- Auto creates a LEDE build environment on Ubuntu, as well as a Nano Makefile for LEDE/OpenWrt

###### [Nginx](Nginx) ######
- Prebuilt custom Nginx server config for ownCloud running within a FreeNAS _[FreeBSD 11]_ jail

###### [Notepad++](Notepad++) ######
- Changes the default "Edit" option in context menus from Notepad to Notepad++

###### [OpenSSH](OpenSSH) ######
- Prebuilt BSD/Linux & Windows OpenSSH client and server configs

###### [OpenSSL](OpenSSL) ######
- Prebuilt custom OpenSSL config, including information and commands starting line 500

###### [OpenVPN](OpenVPN) ######
- Custom client and server OpenVPN configs

###### [PuTTY](PuTTY) ######
- Files and instructions required for a MultiHop SSH Tunnel or a TFTP firmware flash

###### [QDir](QDir) ######
- Custom QDir config file and a useful registry key for WinPE/RE

###### [System Restore](System%20Restore) ######
- Various system restore point creation scripts, with an accompanying Task Scheduler export

###### [WinRE](WinRE) ######
- Script to create a custom WinRE image and an accompanying bootable ISO, USB, or, VHD

---

###### _Registry Keys_ ######
- Some values will need to be customized to your environment
- Explorer keys must be pointed to the right directory within the key
  - _Paths in registry keys must use double backslashes_  `\\`
- System Restore keys must have the path of the VBS script set correctly
  - I recommend placing vbs scripts in a folder with no spaces, such as `%ProgramData%\Scripts`
 
