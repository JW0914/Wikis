#!/bin/sh

                          ##::[[---  OpenWrt MTD Backup Script  ---]]::##

#==================================================================================================

# Please modify before running:

  # Device:
    device="WRT3200ACM"

  # Email:
    emailR1="receiver@email.com"

    # If using ssmtp or sendmail (else edit lines 126 - 144):
      Domain="email.com"
      Mail="smtp.email.com:587"
      Pass="passphrase"
      User="user@email.com"

  # USB Drive:
    USBa="/mnt/sda1/mtd_backup"
    USBb="/mnt/sdb1/mtd_backup"

#--------------------------------------------------------------------------------------------------

  # Indent Output
    indent() { sed 's/^/    /'; }

  # Header:
    nHEAD="\n======================================================================================================="
    nSUBHEADn="\n-------------------------------------------------------------------------------------------------------\n"

  # Date & Time:
    dt="$(date +%Y.%m.%d_%H:%M:%S)"
      dtT="$(date +%H:%M:%S)"
      dtY="$(date +%Y.%m.%d)"

  # Device:
    ##device="WRT3200ACM"
    hn="OpenWrt"
    dn="WRT"

    fw="$(sed  "s/^DISTRIB_ID='//" /etc/openwrt_release | grep ^OpenWrt | sed "s/'//g")"
    kv="$(uname -r)"
    rev="$(cat /etc/openwrt_version)"

  # Email:
    ##emailR1="receiver@email.com"
    ssmtp="/root/ssmtp.conf"

  # Logfile:
    log="/tmp/mtd_backup_$dtY-$dtT.log"
    erlog="/tmp/ERROR-mtd_backup_$dtY-$dtT.log"

  # USB Drive:
    ##USBa="/mnt/sda1/mtd_backup"
    ##USBb="/mnt/sdb1/mtd_backup"


#==================================================================================================

    # Prerequisites #
#--------------------------------------------------------------------------------------------------

(
  printf $nHEAD
  printf  "\n                         ##::[[ ----- $device MTD Partition Backup ----- ]]::##"
  printf "$nHEAD\n\n"
  printf "Kernel:   $kv                                                                                  Time: $dtT\n"
  printf "Firmware: $fw\n"
  printf "Revision: $rev                                                                       Date: $dtY\n"
  printf $nSUBHEADn

  echo "
                      Flash Layout: Primary (mtd6: ubi) || Alternate (mtd8: ubi)
__________________________________________________________________________________________________________________
| Layer 0 |                                            raw flash 256Mb                                            |
|_________|_______________________________________________________________________________________________________|
| Layer 1 | mtd0: | mtd1: | mtd2: |  mtd3:  |  mtd4:  |                                         | mtd9:  | mtd10: |
|         | uboot | u_env | s_env | devinfo | sysdiag |             firmware 160Mb              | syscfg | unused |
|         |  2Mb  | 128Kb | 256Kb | 1920Kb  |  256Kb  |                                         |  86Mb  | 5888Kb |
|_________|       |       |       |         |         |_________________________________________|        |        |
| Layer 2 |       |       |       |         |         |       mtd5:       |        mtd7:        |        |        |
|         |       |       |       |         |         |      kernel1      |       kernel2       |        |        |
|         |       |       |       |         |         |       80Mb        |        80Mb         |        |        |
|_________|       |       |       |         |         |___________________|_____________________|        |        |
| Layer 3 |       |       |       |         |         | primary |  mtd6:  | alternate |  mtd8:  |        |        |
|         |       |       |       |         |         |  kernel | rootfs1 |   kernel  | rootfs2 |        |        |
|         |       |       |       |         |         |  image  |  (ubi)  |   image   |  (ubi)  |        |        |
|         |       |       |       |         |         |   6Mb   |  74Mb   |    6Mb    |  74Mb   |        |        |
|_________|_______|_______|_______|_________|_________|___________________|_____________________|________|________|
"
  printf $nSUBHEADn
) > ${log}

    # Create Backups #
#--------------------------------------------------------------------------------------------------
(
  if (
    if [ -e /dev/sda1 ]; then
      mkdir -p ${USBa}/$dtY
    elif [ -e /dev/sdb1 ]; then
      mkdir -p ${USBb}/$dtY
    fi
  ); then
    if [ -e /dev/sda1 ]; then
      cat /proc/mtd | tail -n+2 | while read ; do
        MTD_DEV=$(echo ${REPLY} | cut -f1 -d:)
        MTD_NAME=$(echo ${REPLY} | cut -f2 -d\")
        printf "\n  Backing up ${MTD_DEV}: ${MTD_NAME}...\n\n"
        dd if=/dev/${MTD_DEV}ro of=${USBa}/$dtY/${MTD_DEV}_${MTD_NAME}.bak.img 2>&1 | indent >> ${log}
      done

    elif [ -e /dev/sdb1 ]; then
      cat /proc/mtd | tail -n+2 | while read ; do
        MTD_DEV=$(echo ${REPLY} | cut -f1 -d:)
        MTD_NAME=$(echo ${REPLY} | cut -f2 -d\")
        printf "\n  Backing up ${MTD_DEV}: ${MTD_NAME}...\n\n"
        dd if=/dev/${MTD_DEV}ro of=${USBb}/$dtY/${MTD_DEV}_${MTD_NAME}.bak.img 2>&1 | indent >> ${log}
      done
    fi

  else
    printf "\n\n  !!! BACKUP FAILED !!! \n    ! No USB storage attached !\n" 2>&1 > ${erlog}
    if [ ! -e ${ssmtp} ]; then
      cat <<EOF > ${ssmtp}
root=DEVICE@HN.DN
mailhub=MAIL
rewriteDomain=DOMAIN
AuthUser=USER
AuthPass=PASS
FromLineOverride=YES
UseSTARTTLS=YES
EOF
      sed -i "s/DEVICE/$device/g" ${ssmtp}  2>&1
      sed -i "s/DN/$dn/g"         ${ssmtp}  2>&1
      sed -i "s/HN/$hn/g"         ${ssmtp}  2>&1
      sed -i "s/DOMAIN/$Domain/g" ${ssmtp}  2>&1
      sed -i "s/MAIL/$Mail/g"     ${ssmtp}  2>&1
      sed -i "s/PASS/$Pass/g"     ${ssmtp}  2>&1
      sed -i "s/USER/$User/g"     ${ssmtp}  2>&1
    fi
    ssmtp -v -C ${ssmtp} $emailR1 < /tmp/ERROR_mtd_backup_*-*.log
  fi

  printf "\n  ...Backup Completed...\n"
  printf $nHEAD
) >> ${log}

if [ -e /dev/sda1 ]; then
  cp ${log} ${USBa}/$dtY
elif [ -e /dev/sdb1 ]; then
  cp ${log} ${USBb}/$dtY
fi

cat ${log} && rm ${log}
