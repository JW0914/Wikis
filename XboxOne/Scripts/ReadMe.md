### Information Directory ###
---
###### [GPT Utility Script](gptutil.py) ######
- Used by the _xboxonehdd.py_ script in order to correctly create the _mkxboxfs.sh_ script


###### [Make Xbox FileSystem](mkxboxfs-500gb.sh) ######
- Prior to running, one needs to edit the script so _DEV=/dev/__sdb___ points to the replacement HDD's device name

- If the replacement HDD is __larger__ than 500GB, _and the console shipped with a 500GB HDD_, this script must be utilized _first_ to partition the drive.  When Windows checks the partition table prior to an OS rebuild and sees a table different than what the drive shipped with, it will reformat the drive and erase your OSUDT rebuild files.


###### [Xbox One HDD Script](mkxboxfs-500gb.sh) ######
- Used to call on the _gptutil.py_ script and provide it Xbox One specific information (guids, partition sizes, etc.) in order to properly output the _mkxboxfs.sh_ script

---
> Forked from [Juvenal1's GitHub](https://github.com/Juvenal1/xboxonehdd) and included to make the wiki more fluid
 
