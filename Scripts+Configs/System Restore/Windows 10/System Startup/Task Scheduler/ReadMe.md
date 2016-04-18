###Information Directory###
---
######Task Scheduler######
- XML export to be imported into Task Scheduler via _Action - Import Task..._
  - Auto creates RP every time the system is initially booted or rebooted
- Line 56 must point to the vbs script in the previous folder
  - `<Arguments>"C:\ProgramData\Scripts\SR\RPwithDscr\RPDescr-Startup.vbs"</Arguments>`
