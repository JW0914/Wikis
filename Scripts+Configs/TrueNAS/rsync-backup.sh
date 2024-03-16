#!/bin/sh

                 ##::[[-----> TrueNAS Rsync Backup <-----]]::##

#==============================================================================
  # Title:        rsync_backup.sh
  # Description:  Backs up or Restores ZFS Datastores on TrueNAS
  # Author:       JW0914
  # Created:      2016.01.01
  # Updated:      2024.03.16
  # Version:      2.0
  # Usage:        chmod +x ./rsync_backup.sh && ./rsync_backup.sh
#==============================================================================


# Variables #
#------------------------------------------------------------------------------

# Date & Time:
  dt=$(date '+%Y.%m.%d_%H:%M:%S')
  date=$(date '+%Y.%m.%d')

# Email:
  emailR="recipient@email.com"
  emailS="sender@email.com"
  subject="External Backup Status for ${hn}.${dn}"

  # Device:
    device="TrueNAS"
    hn="echo $(hostname -s)"
    dn="echo $(hostname -d)"

#------------------------------------------------------------------------------
# DataStores:

  # Backups:
    bak=backup-1

  # Logging:
    ssd=nas-ssd

  # Storage:
    data=nas-storage

  # System:
    sys=nas-system

#------------------------------------------------------------------------------
# Directories:

  # Backup:
    ext11=/mnt/${bak}/${data}/
    ext12=/mnt/${bak}/${sys}/

  # Data
    zp1=/mnt/${data}/
    zp2=/mnt/${sys}/

  # Logs:
    logfile=/tmp/Rsync_External_log.tmp
    logs=/mnt/${ssd}/logs/rsync
    extlog=/mnt/${bak}/logs

#------------------------------------------------------------------------------
# Rsync Logging:

  # Backup:
    logB1=--log-file=${logs}/backup/BACKUP_${data}-${dt}.log
    logB2=--log-file=${logs}/backup/BACKUP_${sys}-${dt}.log

    tailB1="tail -15 ${logs}/backup/BACKUP_${data}-${date}_**:**:**.log"
    tailB2="tail -16 ${logs}/backup/BACKUP_${sys}-${date}_**:**:**.log"

  # Restore:
    logR1=--log-file=${logs}/restore/RESTORE_${data}-${dt}.log
    logR2=--log-file=${logs}/restore/RESTORE_${sys}-${dt}.log

    tailR1="tail -16 ${logs}/restore/RESTORE_${data}-${date}_**:**:**.log"
    tailR2="tail -16 ${logs}/restore/RESTORE_${sys}-${date}_**:**:**.log"

#------------------------------------------------------------------------------
# Rsync:

  # Options:
    opt="-avrt --human-readable --partial --stats --info=progress2"

  # Backup:
    BackSt="rsync ${opt} ${logB1} ${zp1} ${ext11}"
    BackSy="rsync ${opt} ${logB2} ${zp2} ${ext12}"

  # Logs:
    BackLog="rsync ${opt} ${logs} ${extlog}"

  # Restore:
    RestSt="rsync ${opt} ${logR1} ${ext11} ${zp1}"
    RestSy="rsync ${opt} ${logR2} ${ext12} ${zp2}"


#==============================================================================
                                 # Paramaters #
#==============================================================================

# Email Options:
#-------------------------------------------------------------------------------

# Header:
(
  echo "To: ${emailR}"
  echo "Subject: ${subject}"
  echo "Content-Type: text/html"
  echo "MIME-Version: 1.0"
  printf "\r\n"
) > ${logfile}

# Begin HTML wrapper:
  echo "<pre style=\"font-size:12px\">" >> ${logfile}

# Heading:
(
  echo ""
  echo "                ##[[-----> External Backup Status for ${device} <-----]]##                "
  echo ""
) >> ${logfile}


# Storage Backup:
#------------------------------------------------------------------------------

# Copy:
  printf "\n\n...Backing up ${data} to ${bak}...\n\n"
  ${BackSt}

# Log:
(
  echo ""
  echo ""
  echo "    # ${data} --> ${bak} #                                                        "
  echo "----------------------------------------------------------------------------------------"
  echo ""
  ${tailB1}
  echo ""
  echo ""
  echo "       *****    *****    *****    *****          *****    *****    *****    *****       "
) >> ${logfile}


# System Backup:
#------------------------------------------------------------------------------

# Copy:
  printf "\n\n...Backing up ${sys} to ${bak}...\n\n"
  ${BackSy}

# Log:
(
  echo ""
  echo ""
  echo "    # ${sys} --> ${bak} #                                                         "
  echo "----------------------------------------------------------------------------------------"
  echo ""
  ${tailB2}
  echo ""
  echo ""
  echo "       *****    *****    *****    *****          *****    *****    *****    *****       "
) >> ${logfile}


#==============================================================================
# Storage Restore:
#------------------------------------------------------------------------------

# Copy:
##  printf "\n\n...Restoring ${data} from ${bak}...\n\n"
##  $RestSt

# Log:
##(
##  echo ""
##  echo ""
##  echo "    # ${data} <-- ${bak} #                                                        "
##  echo "----------------------------------------------------------------------------------------"
##  echo ""
##  ${tailR1}
##  echo ""
##  echo ""
##  echo "       *****    *****    *****    *****          *****    *****    *****    *****       "
##) >> ${logfile}


# System Restore:
#------------------------------------------------------------------------------

# Copy:
##  printf "\n\n...Restoring ${sys} from ${bak}...\n\n"
##  $RestSy

# Log:
##(
##  echo ""
##  echo ""
##  echo "    # ${sys} <-- ${bak} #                                                         "
##  echo "----------------------------------------------------------------------------------------"
##  echo ""
##  ${tailR2}
##  echo ""
##  echo ""
##  echo "       *****    *****    *****    *****          *****    *****    *****    *****       "
##) >> ${logfile}
#==============================================================================


# End HTML wrapper:
  echo "</pre>" >> ${logfile}


# Copy Logs:
#------------------------------------------------------------------------------
printf "\n\n...Backing up Logs to ${bak}...\n\n"
${BackLog}


# Email Report #
#------------------------------------------------------------------------------

# SendMail:
  if [ -z "${emailR}" ]; then
    echo "No email address specified, information available in ${logfile}"
  else
    sendmail ${emailR} < ${logfile}
    rm ${logfile}
  fi


#==============================================================================
# SSMTP:

  # Create Config:
##    if [ -z "${emailR}" ]; then
##      echo "No email address specified, information available in ${logfile}"
##    else
##      if [ ! -e ~/ssmtp.conf ]; then
##        cat <<EOF > ~/ssmtp.conf
##root=DEVICE@HN.DN
##mailhub=smtp.email.com:587
##rewriteDomain=email.com
##AuthUser=SENDER
##AuthPass=passphrase
##FromLineOverride=YES
##UseSTARTTLS=YES
##EOF
        # Insert variable values:
##          sed -i "s/DEVICE/${device}/g" ~/ssmtp.conf
##          sed -i "s/DN/${dn}/g" ~/ssmtp.conf
##          sed -i "s/HN/${hn}/g" ~/ssmtp.conf
##          sed -i "s/SENDER/${emailS}/g" ~/ssmtp.conf
##      fi
##      ssmtp -v -C ~/ssmtp.conf ${emailR} < ${logfile}
##      rm ${logfile}
##    fi
#==============================================================================
