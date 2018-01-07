### Information Directory ###
---

[LEDE-Project](https://lede-project.org/): **L**inux **E**mbedded **D**evelopment **E**nvironment

###### [lede-build.sh](lede-build.sh) ######
Creates a LEDE-Project build environment in Ubuntu _(preconfigured for 16.04, 16.10, 17.04, 17.10)_
  - **Lines 225 - 230:**
    - If custom files for a device already exist, uncomment & edit
  - **Lines 241 - 259:**
    - Appends the updated Marvell-CESA driver to crypto.mk
  - **Lines 264 - 320:**
    - Replaces default Nano makefile, enabling all Nano build options and UTF8
      - Increases nano package from ~41KB to ~124KB

###### Prerequisites ######
  - Ubuntu 16.04, 16.10, 17.04, or 17.10
  
  - I'll update as new versions become available
    - If I'm not quick enough, it's easy to do
      1. Copy everything after "_PR1710=_" on **Line 68** to paste in step 2.
      2. Open a terminal in Ubuntu, issue: `sudo apt-get update && sudo apt-get install <paste>`
          - Several packages will not install, and these will be updated packages specific to 17.10+.
          - To find the updated versions of packages, like _libboost1.63-dev_: `sudo apt-cache search libboost1.**-dev` 
            - Common packages needing to be updated: _libboost_, _libgtk_, _openjdk_, _perl_modules_, etc
