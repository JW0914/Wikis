### Information Directory ###
---

[OpenWrt Project](https://openwrt.org/)
  - Linux distribution for embedded devices
    - OpenWrt and the LEDE-Project reconciled and merged in February 2018

###### [lede-build.sh](lede-build.sh) ######
Creates an OpenWrt build environment in Ubuntu _(preconfigured for 14.04, 16.04, 16.10, 17.04, 17.10+)_
  - **Lines 370 - 376:**
    - If custom files for a device already exist, uncomment & edit
  - **Lines 387 - 391:**
    - Replaces default Nano makefile, enabling all Nano build options (incl. UTF-8), except libmagic
      - Increases nano package from ~41KB to ~124KB
<br></br>
  - _I removed the ClearFog section with commit [78d279c](https://github.com/JW0914/Wikis/commit/78d279c5d806dfd5530e9ba7a83eef7d4c6fb660), but will add it back once those blocks of code are fixed._

###### Prerequisites ######
  - Ubuntu 14.04, 16.04, 16.10, 17+
<br></br>
  - I'll update as need be when new versions become available, and/or package versions are updated
    - If needing to do so:
      1. Copy everything after "_PR171=_" on **Line 102** to paste in step 2.
      2. Open a terminal in Ubuntu, issue: `sudo apt-get update && sudo apt-get install <paste>`
          - Several packages will not install, and these will be updated packages specific to 18.04+.
          - To find the updated versions of packages, like _libboost1.63-dev_: `apt search libboost1.**-dev` 
            - Common packages needing to be updated: _libboost_, _libgtk_, _openjdk_, _perl_modules_, etc
