### Information Directory ###
---
###### [Show Hidden Files](ShowHiddenFiles.reg) ######
- Forces the showing of hidden and system files within GUI programs
- Mainly for utilization within WinPE/WinRE

###### [WinRE Create](WinRE-Create.cmd) ######
- Provided one has completed the prequisites, this will auto customize a WinRE image and replace the current image with the custom one and/or create a bootable ISO, USB, or VHD
  
  - __Prerequisites__
    - Recovery partition mounted as drive `X:`
    - Windows ADK installed
      - Add the following to System Path: <br> _`Control Panel\System and Security\System` 🡒 Advanced System Settings 🡒 Advanced 🡒 Environment Variables 🡒 System Variables - Path_
        - `#---ADK INSTALLATION PATH---#\Assessment and Deployment Kit\Deployment Tools\amd64\DISM`
        - `#---ADK INSTALLATION PATH---#\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg`
        - `#---ADK INSTALLATION PATH---#\Assessment and Deployment Kit\Windows Preinstallation Environment`

