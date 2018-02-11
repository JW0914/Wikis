### Information Directory ###
---

[LEDE-Project](https://lede-project.org/) | [OpenWrt Project](https://openwrt.org/)
  - Linux distribution for embedded devices
    - OpenWrt and LEDE reconciled and merged in 2018
      - Repo links in script will be updated to [OpenWrt's](https://github.com/openwrt/openwrt) repo once [LEDE's](https://github.com/lede-project/source) code has been fully merged


###### [lede-build.sh](lede-build.sh) ######
Creates a LEDE-Project build environment in Ubuntu _(preconfigured for 16.04, 16.10, 17.04, 17.10)_
  - **Lines 249 - 254:**
    - If custom files for a device already exist, uncomment & edit
  - **Lines 265 - 269:**
    - Appends the updated Marvell-CESA driver to crypto.mk
  - **Lines 273 - 277:**
    - Replaces default Nano makefile, enabling all Nano build options (incl. UTF-8), except libmagic
      - Increases nano package from ~41KB to ~124KB

###### Prerequisites ######
  - Ubuntu 16.04, 16.10, 17.04, or 17.10
  
  - I'll update as new versions become available
    - If I'm not quick enough, it's easy to do
      1. Copy everything after "_PR1710=_" on **Line 92** to paste in step 2.
      2. Open a terminal in Ubuntu, issue: `sudo apt-get update && sudo apt-get install <paste>`
          - Several packages will not install, and these will be updated packages specific to 17.10+.
          - To find the updated versions of packages, like _libboost1.63-dev_: `apt search libboost1.**-dev` 
            - Common packages needing to be updated: _libboost_, _libgtk_, _openjdk_, _perl_modules_, etc
