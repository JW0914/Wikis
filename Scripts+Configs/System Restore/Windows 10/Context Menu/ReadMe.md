###Information Directory###
---
######REG######
- Adds a restore point creation option to the _Context Menu_
  - __Line 13__ must point to the VBS script
    - `@="WScript C:\\ProgramData\\Scripts\\SR\\ContextMenu\\CreateRP-Success_Message.vbs"`

######VBS######
- Should be placed in a path with __no__ spaces
  - `%ProgramData%\Scripts\SR\ContextMenu`
