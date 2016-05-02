###Information Directory###
---
######gptutil.py######
- Used by the _xboxonehdd.py_ script in order to correctly create the _mkxboxfs.sh_ script


######mkxboxfs-500gb.py######
- Prior to running, one needs to edit the script so _DEV=/dev/__sdb___ points to the replacement HDD's device name

- If the replacement HDD is larger than 500GB, and the console shipped with a 500GB HDD, this script must be utilized first to partition the drive.  When Windows checks the partition table prior to an OS rebuild and sees a table different than what the drive shipped with, it will reformat the drive and erase your OSUDT rebuild files.


######xboxonehdd.py######
- Used to call on the _gptutil.py_ script and provide it Xbox One specific information (guids, partition sizes, etc.) in order to properly output the _mkxboxfs.sh_ script

---
> Forked from [Juvenal1's GitHub](https://github.com/Juvenal1/xboxonehdd) and included to make the wiki more fluid
