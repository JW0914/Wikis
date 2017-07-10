### Information Directory ###
---
###### ESD-2-WIM ######
- Converts ESD <-> WIM _install.esd_/_wim_ files
- Script can be modified to convert any _*.esd_/_*.wim_
  - Garnish standalone export command options: [`DISM /Export-Image /?`](https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/dism-image-management-command-line-options-s14#export-image)


###### DISM-Creation ######
- An interactive script that:
  - Silently installs the Windows ADK  _Windows Preinstallation Environment (Windows PE)_ & _Deployment Tools_ packages
    - Option to skip install if the two aforementioned packages are already installed from the Windows ADK
  - Copies required files to a standalone DISM folder

- While the built-in DISM in Windows >8.1 has imaging options, it's best to have a separate, portable DISM folder containing all DISM files required which can be kept with the [`ESD-2-WIM.cmd`](https://github.com/JW0914/Wikis/blob/master/Scripts%2BConfigs/ESD%20to%20WIM/ESD-2-WIM.cmd) script
  - The built in DISM tools in Windows >8.1 do not provide all required files needed for a portable folder.
  - The ESD <-> WIM script should run fine by itself on Windows >8.1 _(i.e. w/o standalone DISM folder)_
  - If not using a standalone DISM folder, running this script will result with the converted image saved to _C:\Windows\System32_

###### Prequisites ######
- Download the [Windows ADK](https://developer.microsoft.com/en-us/windows/hardware/windows-assessment-deployment-kit)
- Download & run [`DISM-Creation.cmd`](https://github.com/JW0914/Wikis/blob/master/Scripts%2BConfigs/ESD%20to%20WIM/DISM-Creation.cmd) script

***
> _ESD <-> WIM script was written by an unknown MSFN forum member_
