#!/bin/bash

# Courtesy of GitHub user Juvenal1 (GitHub.com/Juvenal1)

#	If replacement drive is larger than original HDD, edit 
# DEV=/dev/sdb to equal the replacement HDD device’s name 

DEV=/dev/sdb

parted -s "$DEV" mktable gpt
parted -s "$DEV" mkpart primary ntfs 1.00MiB 41985MiB
parted -s "$DEV" name 1 "\"Temp Content\""
mkntfs -q "${DEV}1" -f -L "Temp Content"

parted -s "$DEV" mkpart primary ntfs 41985MiB 415745MiB
parted -s "$DEV" name 2 "\"User Content\""
mkntfs -q "${DEV}2" -f -L "User Content"

parted -s "$DEV" mkpart primary ntfs 415745MiB 456705MiB
parted -s "$DEV" name 3 "\"System Support\""
mkntfs -q "${DEV}3" -f -L "System Support"

parted -s "$DEV" mkpart primary ntfs 456705MiB 468993MiB
parted -s "$DEV" name 4 "\"System Update\""
mkntfs -q "${DEV}4" -f -L "System Update"

parted -s "$DEV" mkpart primary ntfs 468993MiB 476161MiB
parted -s "$DEV" name 5 "\"System Update 2\""
mkntfs -q "${DEV}5" -f -L "System Update 2"
