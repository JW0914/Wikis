### Information Directory ###
---

[LEDE-Project](https://lede-project.org/): **L**inux **E**mbedded **D**evelopment **E**nvironment

###### lede-build.sh ######
Creates a LEDE-Project build environment in Ubuntu _(preconfigured for 16.04, 16.10, or 17.04)_
  - **Lines 108 - 110:**
    - If custom files for a device already exist, uncomment & edit
  - **Lines 114 - 133:**
    - Appends the updated Marvell-Cesa driver to crypto.mk
  - **Lines 137 - 203:**
    - Replaces default Nano makefile, adding syntax color & nanorc support, among others
      - Increases nano package from ~41KB to ~121KB

###### Prerequisites ######
  - Edit Lines:
    - **11:** `user="<username>"`
    - **67:** `$ag install $PR1xxx`
      - Where `xxx` is equal to the variable on lines 48, 51, or 54
