### Information Directory ###
---
###### [REG](Add_Create_Restore_Point_to_Context_Menu.reg) ######
- Adds a restore point creation option to the _Context Menu_
  - __Line 13__ must point to the VBS script
    - `@="WScript C:\\ProgramData\\Scripts\\SR\\ContextMenu\\CreateRP-Success_Message.vbs"`
  - __Line 11__ Modify to change position within the Context Menu
    - `"Position"="Bottom"`

###### [VBS](CreateRP-Success_Message.vbs) ######
- Should be placed in a path with __no__ spaces
  - `%ProgramData%\Scripts\SR\ContextMenu`
 
