#!/bin/sh

                          ##::[[---  OpenWrt First Run Script ---]]::##

#==================================================================================================

# Please modify before running:

  # Backup directory:
    BAK="/root/backups"

  # Device:
    device="WRT3200ACM"
    EXTROOT="/mnt/sda1/root"
    # Recommended if using VIM-Runtime, Oh-My-Zsh, etc. to store custom config files

  # Email:
    emailR1="receiver@email.com"
    emailS1="sender@email.com"

    # If using ssmtp or sendmail (else edit lines 737 - 755, 761, 811, 846):
      Domain="email.com"
      Mail="smtp.email.com:587"
      Pass="passphrase"
      User="user@email.com"

  # Admin GPG Key for emailing OpenVPN TLS-Crypt, or other sensitive, PSKs:
    adminKEY="46F7A27A2EAB9D23"
    adminEKEY="23046D6912055172!"
    # The !  is required, as it tells GPG to use that key specifically for encryption

  # SSH public keys:
    sshPubKey="<type> <key> <comment>"
    sshKeyComment="<comment>"

#--------------------------------------------------------------------------------------------------

  # Indent Output
    indent() { sed 's/^/    /'; }

  # Working Direcotry:
    dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
    SHT="/tmp/script"
    ##BAK="/root/backups"

    gpgfile="$SHT/gpg-email.tmp"
    logfile="$SHT/first_run_log.tmp"

    dt="$(date +%Y.%m.%d_%H:%M:%S)"
      dtT="$(date +%H:%M:%S)"
      dtY="$(date +%Y.%m.%d)"

    LOG1="/tmp/first-run_${dt}.log"
    LOG2="/tmp/gpg-email_${dt}.log"

    HEADn="====================================================================\n"
    nHEADn="\n====================================================================\n"
    nnHEADn="\n\n====================================================================\n"

    SUBHEADn="--------------------------------------------------------------------\n"
    nSUBHEADn="\n--------------------------------------------------------------------\n"

  # Device:
    ##device="WRT3200ACM"
    hn="OpenWrt"
    dn="WRT"

    fw="$(sed  "s/^DISTRIB_ID='//" /etc/openwrt_release | grep ^OpenWrt | sed "s/'//g")"
    kv="$(uname -r)"
    rev="$(cat /etc/openwrt_version)"
    up="$(uptime)"

    ##EXTROOT="/mnt/sda1/root"

  # Email:
    ##emailR1="receiver@email.com"
    ##emailS1="sender@email.com"

    subject1="First Run Status for $hn on $device"
    subject2="TLS-Crypt for $hn on $device"

    ssmtp="/root/ssmtp.conf"
      ##Domain="email.com"
      ##Mail="smtp.email.com:587"
      ##Pass="passphrase"
      ##User="user@email.com"

  # GPG:
    cGPG="$SHT/create-gpg-keys"
    GPG="/root/.gnupg"

    gcf="gpg --command-fd 0"
    kss="--keyserver hkps://hkps.pool.sks-keyservers.net"

    # Admin GPG Key
      ##adminKEY="46F7A27A2EAB9D23"
      ##adminEKEY="23046D6912055172!"

  # Services:
    INIT="/etc/init.d"

    # NTP:
      sysNTP="$($INIT/sysntpd restart)"
      NTP="$(ntpd -S 192.168.1.1 && ntpd -S time.nist.gov)"

  # SSH & SSL:
    SSH="/etc/ssh"

    SSL="/etc/ssl"
      VPN="$SSL/openvpn"
        tc="tc.psk"

    SSHs="OpenSSH Server"

    ##sshPubKey="<type> <key> <comment>"
    ##sshPubComment="<comment>"


#==================================================================================================

    # Prerequisites #
#--------------------------------------------------------------------------------------------------

# Ensure pwd is ~
  cd -P -- "$(dirname -- "$0")"

# Ensure we have correct time
  ( $sysNTP && $NTP ) 2>&1

  $INIT/sshd restart 2>&1

  if [ -e /etc/init.d/openvpn ]; then
    $INIT/openvpn restart 2>&1
  fi

# Working directory
  mkdir -p ${SHT}
    touch ${gpgfile} & echo > ${gpgfile}
    touch ${logfile} & echo > ${logfile}

(
  cd -P -- "$(dirname -- "$0")"

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

  if [ -e ${GPG} ]; then
    rm -rf ${GPG}
  fi
  gpg --list-keys
  chmod 700 ${GPG}
)

    # Email Options #
#--------------------------------------------------------------------------------------------------

# Header:
(
  echo "To: ${emailR1}"
  echo "Subject: ${subject1}"
  echo "Content-Type: text/html"
  echo "MIME-Version: 1.0"
  printf "\r\n"
) > ${logfile}


# Body:
(
  echo "<pre style=\"font-size:12px\">"
  printf "\r"
) >> ${logfile}

# Heading:
(
  printf "\n\n         ##::[[ -----  First Run Status: $device  ----- ]]::##\n"
  printf "\r\n\n"
  printf "Kernel:   $kv                                    Time: $dtT\n"
  printf "Firmware: $fw\n"
  printf "Revision: $rev                         Date: $dtY\n"
  printf "\r\n\n"
) >> ${logfile}

#==================================================================================================

    # GPG #
#--------------------------------------------------------------------------------------------------
(
  cd -P -- "$(dirname -- "$0")" 2&>1

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

  printf %b $HEADn

  printf "\n  # GnuPG #\n"
  printf %b $SUBHEADn

    if [ ! -e /root/.gnupg/gpg.conf ]; then
      printf "\n  Creating GPG Config...\n"
        cat <<EOF > $GPG/gpg.conf
#

     ##::[[---  OpenWrt GnuPG Config  ---]]::##

#---------------------------------------------------
           ##----- Global Options -----##
#---------------------------------------------------

    # CA #
#---------------------------------------------------
keyserver-options ca-cert-file = /etc/ssl/certs/sks-keyservers.netCA.pem.crt
EOF
      printf "    DONE.\n"
    fi
    chmod 644 $GPG/gpg.conf

    printf "\n  Creating GPG sks-keyservers.netCA.pem.crt...\n"
      # https://sks-keyservers.net/sks-keyservers.netCA.pem

      cat <<EOF > /etc/ssl/certs/sks-keyservers.netCA.pem.crt
-----BEGIN CERTIFICATE-----
MIIFizCCA3OgAwIBAgIJAK9zyLTPn4CPMA0GCSqGSIb3DQEBBQUAMFwxCzAJBgNV
BAYTAk5PMQ0wCwYDVQQIDARPc2xvMR4wHAYDVQQKDBVza3Mta2V5c2VydmVycy5u
ZXQgQ0ExHjAcBgNVBAMMFXNrcy1rZXlzZXJ2ZXJzLm5ldCBDQTAeFw0xMjEwMDkw
MDMzMzdaFw0yMjEwMDcwMDMzMzdaMFwxCzAJBgNVBAYTAk5PMQ0wCwYDVQQIDARP
c2xvMR4wHAYDVQQKDBVza3Mta2V5c2VydmVycy5uZXQgQ0ExHjAcBgNVBAMMFXNr
cy1rZXlzZXJ2ZXJzLm5ldCBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
ggIBANdsWy4PXWNUCkS3L//nrd0GqN3dVwoBGZ6w94Tw2jPDPifegwxQozFXkG6I
6A4TK1CJLXPvfz0UP0aBYyPmTNadDinaB9T4jIwd4rnxl+59GiEmqkN3IfPsv5Jj
MkKUmJnvOT0DEVlEaO1UZIwx5WpfprB3mR81/qm4XkAgmYrmgnLXd/pJDAMk7y1F
45b5zWofiD5l677lplcIPRbFhpJ6kDTODXh/XEdtF71EAeaOdEGOvyGDmCO0GWqS
FDkMMPTlieLA/0rgFTcz4xwUYj/cD5e0ZBuSkYsYFAU3hd1cGfBue0cPZaQH2HYx
Qk4zXD8S3F4690fRhr+tki5gyG6JDR67aKp3BIGLqm7f45WkX1hYp+YXywmEziM4
aSbGYhx8hoFGfq9UcfPEvp2aoc8u5sdqjDslhyUzM1v3m3ZGbhwEOnVjljY6JJLx
MxagxnZZSAY424ZZ3t71E/Mn27dm2w+xFRuoy8JEjv1d+BT3eChM5KaNwrj0IO/y
u8kFIgWYA1vZ/15qMT+tyJTfyrNVV/7Df7TNeWyNqjJ5rBmt0M6NpHG7CrUSkBy9
p8JhimgjP5r0FlEkgg+lyD+V79H98gQfVgP3pbJICz0SpBQf2F/2tyS4rLm+49rP
fcOajiXEuyhpcmzgusAj/1FjrtlynH1r9mnNaX4e+rLWzvU5AgMBAAGjUDBOMB0G
A1UdDgQWBBTkwyoJFGfYTVISTpM8E+igjdq28zAfBgNVHSMEGDAWgBTkwyoJFGfY
TVISTpM8E+igjdq28zAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4ICAQAR
OXnYwu3g1ZjHyley3fZI5aLPsaE17cOImVTehC8DcIphm2HOMR/hYTTL+V0G4P+u
gH+6xeRLKSHMHZTtSBIa6GDL03434y9CBuwGvAFCMU2GV8w92/Z7apkAhdLToZA/
X/iWP2jeaVJhxgEcH8uPrnSlqoPBcKC9PrgUzQYfSZJkLmB+3jEa3HKruy1abJP5
gAdQvwvcPpvYRnIzUc9fZODsVmlHVFBCl2dlu/iHh2h4GmL4Da2rRkUMlbVTdioB
UYIvMycdOkpH5wJftzw7cpjsudGas0PARDXCFfGyKhwBRFY7Xp7lbjtU5Rz0Gc04
lPrhDf0pFE98Aw4jJRpFeWMjpXUEaG1cq7D641RpgcMfPFvOHY47rvDTS7XJOaUT
BwRjmDt896s6vMDcaG/uXJbQjuzmmx3W2Idyh3s5SI0GTHb0IwMKYb4eBUIpQOnB
cE77VnCYqKvN1NVYAqhWjXbY7XasZvszCRcOG+W3FqNaHOK/n/0ueb0uijdLan+U
f4p1bjbAox8eAOQS/8a3bzkJzdyBNUKGx1BIK2IBL9bn/HravSDOiNRSnZ/R3l9G
ZauX0tu7IIDlRCILXSyeazu0aj/vdT3YFQXPcvt5Fkf5wiNTo53f72/jYEJd6qph
WrpoKqrwGwTpRUCMhYIUt65hsTxCiJJ5nKe39h46sg==
-----END CERTIFICATE-----
EOF
      printf "    DONE.\n"

    printf "\n  Creating GPG Batch File...\n"
      cat <<EOF > ${cGPG}  2>&1
#

%echo Generating DEVICE GPG key

# Key Paramaters:
  Key-Type:       RSA
  Expire-Date:    0
  Key-Length:     4096
  Key-Usage:      sign
  Name-Comment:   GPG DEVICE RSA
  Name-Email:     DEVICE@HN.DN
  Name-Real:      DEVICE
  Preferences:    AES SHA512
  Subkey-Length:  2048
  Subkey-Type:    RSA
  Subkey-Usage:   auth encrypt

# Command Paramaters:
  %commit
EOF

      sed -i "s/DEVICE/$device/g" ${cGPG}  2>&1
      sed -i "s/DN/$dn/g" ${cGPG}  2>&1
      sed -i "s/HN/$hn/g" ${cGPG}  2>&1
      printf "    DONE.\n"


    printf $nSUBHEADn
    printf "\n  Generating GPG RSA Keys...\n\n"
      gpg --batch --gen-key ${cGPG}  2>&1 | indent
      printf "\n    DONE.\n\n"

    printf $nSUBHEADn
    printf "\n  Listing Secret Keys...\n\n"
      gpg -K 2>&1 | indent
      printf "    DONE.\n\n"

    printf $nSUBHEADn
      printf "\n  Listing Fingerprints...\n\n"
      gpg --fingerprint $device 2>&1 | indent
      chmod 700 $GPG
      printf "    DONE.\n\n"

    printf %b $SUBHEADn
    printf "\n  Exporting GPG Key...\n\n"
      gpg --export -a "$device" 2>&1 | indent
      printf "\n    DONE.\n\n"

  printf %b $HEADn
) >> ${logfile} 2>&1

#--------------------------------------------------------------------------------------------------
(
  cd -P -- "$(dirname -- "$0")" 2>&1

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

  for fpr in $adminKEY; do
    printf $nHEADn

      printf "\n\n  # Importing Admin's Key #\n\n"
      echo -e "1" 2>&1 |  $gcf --batch $kss --search-keys $fpr 2>&1 | indent
      printf "\n    DONE.\n\n"

    printf %b $HEADn
      printf "\n\n  # Signing Admin's Key #\n"
      echo -e "y\ny" | $gcf --batch --sign-key $fpr 2>&1 | indent
      printf "    DONE.\n\n"

    printf %b $HEADn
      printf "\n\n  # Trusting Admin's Key #\n"
      echo -e "5\ny\n" | $gcf --batch --edit-key $fpr trust 2>&1 | indent
      printf "    DONE.\n\n"

    printf %b $HEADn
      printf "\n\n  # Verifing Trust #\n"
      echo -e "quit\n" | $gcf --batch --edit-key $fpr 2>&1 | indent
      printf "    DONE.\n\n"

    printf %b $HEADn
  done
) >> ${logfile} 2>&1

#==================================================================================================

# Ensure we have correct time
  ( $sysNTP && $NTP ) 2>&1

  $INIT/sshd restart 2>&1

  if [ -e /etc/init.d/openvpn ]; then
    ( $sysNTP && $NTP ) 2>&1
    $INIT/openvpn restart 2>&1
  fi

    # ZSH #
#--------------------------------------------------------------------------------------------------
(
  printf "\n\n  # ZSH #\n"
  printf %b $SUBHEADn
  #  printf "\n  Linking External Oh-My-Zsh...\n"
  #    if [ -e /root/.oh-my-zsh ]; then
  #      rm -rf /root/.oh-my-zsh
  #    fi
  #    ln -s $EXTROOT/.oh-my-zsh /root/.oh-my-zsh 2>&1
  #    printf "    DONE.\n"

  #  printf "\n  Linking External Zsh Autocomplete...\n"
  #    if [ -e /root/.zcompdump-OpenWrt-5.4.2 ]; then
  #      rm -f /root/.zcompdump-OpenWrt-5.4.2
  #    fi
  #    ln -s $EXTROOT/.zcompdump-OpenWrt-5.4.2 /root/.zcompdump-OpenWrt-5.4.2 2>&1

  #    if [ -e /root/.zcompdump ]; then
  #      rm -f /root/.zcompdump
  #    fi
  #    ln -s $EXTROOT/.zcompdump /root/.zcompdump 2>&1
  #    printf "    DONE.\n"

  #  printf "\n  Linking External Zsh History...\n"
  #    if [ -e /root/.zsh_history ]; then
  #      rm -f /root/.zsh_history
  #    fi
  #    echo > $EXTROOT/.zsh_history
  #    ln -s $EXTROOT/.zsh_history /root/.zsh_history 2>&1
  #    printf "    DONE.\n"

    printf "\n  Creating Zsh's /root/.directory_history ...\n"
      if [ ! -e /root/.directory_history ]; then
        mkdir -p /root/.directory_history 2>&1
      fi

    printf "\n  Linking System ZshRC to ~/.zshrc...\n"
      if [ -e /root/.zshrc ]; then
        mv /root/.zshrc /tmp 2>&1
        if [ ! -e /root/.zshrc ]; then
          ln -s /etc/zshrc /root/.zshrc 2>&1
        fi
      fi
      printf "    DONE.\n"

  # Source ~/.zshrc
    printf "\n  Sourcing System ZshRC...\n"
      sleep 2
      source /etc/zshrc 2>&1
) >> ${logfile} 2>&1

#==================================================================================================

    # System File Links #
#--------------------------------------------------------------------------------------------------

(
  printf "\n\n  # System File Links #\n"
  printf %b $SUBHEADn

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

  # History:
  #  printf "\n  Linking Directory History...\n"
  #    if [ -e /root/.directory_history ]; then
  #      rm -rf /root/.directory_history
  #    fi
  #    #if [ -e $EXTROOT/.directory_history ]; then
  #    #  rm -rf $EXTROOT/.directory_history
  #    #fi
  #    ln -s $EXTROOT/.directory_history /root/.directory_history 2>&1
  #    printf "    DONE.\n"

  # .local
  #  printf "\n  Linking External .local...\n"
  #    if [ -e /root/.local ]; then
  #      rm -rf /root/.local
  #    fi
  #    ln -s $EXTROOT/.local /root/.local 2>&1
  #    printf "    DONE.\n"

  # Monit:
  #  printf "\n  Linking External .monit.id...\n"
  #    if [ -e /root/.monit.id ]; then
  #      rm -f /root/.monit.id
  #    fi
  #    ln -s /tmp/.monit.id /root/.monit.id 2>&1
  #    printf "    DONE.\n"

  #  printf "\n  Linking External .monit.state...\n"
  #    if [ -e /root/.monit.state ]; then
  #      rm -f /root/.monit.state
  #    fi
  #    ln -s /tmp/.monit.state /root/.monit.state 2>&1
  #    printf "    DONE.\n"

  # Nano:
    printf "\n  Linking System NanoRC to ~/.nanorc...\n"
      if [ ! -e /root/.nanorc ]; then
        ln -s /etc/nanorc /root/.nanorc 2>&1
      fi
      printf "    DONE.\n"

  # Vim:
    printf "\n  Linking System VimRC to ~/.vimrc...\n"
      if [ ! -e /root/.vimrc ]; then
        ln -s /etc/vimrc /root/.vimrc 2>&1
      fi

  #    if [ -e /root/.vim_runtime ]; then
  #      printf "    Moved existing ~/.vim_runtime to /tmp/.vim_runtime"
  #      cp -R /root/.vim_runtime /tmp
  #      rm -Rf /root/.vim_runtime
  #    fi
  #    ln -s $EXTROOT/.vim_runtime /root/.vim_runtime
      printf "    DONE.\n"
) >> ${logfile} 2>&1

#==================================================================================================

    # Default rc.local #
#--------------------------------------------------------------------------------------------------
(
  printf "\n\n  # Prevent Script from Running Again #\n"
  printf %b $SUBHEADn

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

    printf "\n  Defaulting /etc/rc.local...\n"
    cat <<EOF > /etc/rc.local
#
        ##::[[---  OpenWrt RC.Local Script  ---]]::##

#-----------------------------------------------------------
                ##----- Shell Script -----##
#-----------------------------------------------------------

# Variables:
  INIT="/etc/init.d"

  adb="$($INIT/adblock stop && $INIT/adblock start)"
  ntp="$(/usr/sbin/ntpd -S time.nist.gov)"
  sntp="$($INIT/sysntpd restart)"

# Ensure we have correct time at boot:
  $sntp; $ntp; $sntp

# Restart AdBlock:
  $adb

# Check for errors in /etc/config:
  /root/uci-error-check.sh

# Backup MTD Partitions:
  /root/mtd_backup.sh

# Ensure we have correct time at boot:
  sleep 15 && $sntp; $ntp; $sntp

# Restart AdBlock:
  $adb

# Exit:
  exit 0

EOF

    printf "    DONE.\n"
) >> ${logfile} 2>&1

#==================================================================================================

    # Backup #
#--------------------------------------------------------------------------------------------------
(
  printf "\n\n  # Fixing Backup Permissions #\n"
  printf %b $SUBHEADn

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

    printf "\n  Ensuring /root/backups is Read Only...\n"
      if [ -e /root/backups ]; then
        chmod -R 400 /root/backups 2>&1
      else
        printf "    /root/backups does not exist.\n\n"
      fi
      printf "    DONE.\n"

  printf "\n\n  # Fixing SSL Permissions #\n"
  printf %b $SUBHEADn
    printf "\n  Assiging Certs Read Access...\n"
      if [ -e $SSL/ca ]; then
        chmod 644 $SSL/ca/* 2>&1
      fi
      if [ -e $SSL/certs/wrt*.crt ]; then
        chmod 644 $SSL/certs/wrt*.crt 2>&1
      fi
      printf "    DONE.\n"

    printf "\n  Removing Read Access from Cert Keys...\n"
      if [ -e /etc/init.d/openvpn ]; then
        chmod 600 $VPN/* 2>&1
      else
        chmod 600 $VPN/*
      fi
      chmod 600 $SSL/private/* 2>&1
      printf "    DONE.\n"
) >> ${logfile} 2>&1

#==================================================================================================

    # Disable Services #
#--------------------------------------------------------------------------------------------------
(
  printf "\n\n  # Services #\n"
  printf %b $SUBHEADn

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

  # OpenSSH:
    printf "\n  Ensuring OpenSSH is Enabled...\n"
      for osh in $INIT/sshd; do
        if [ -e $osh ]; then
          $osh enable
          pidof $osh | wc -w 2>&1 | indent
        fi
      done
      printf "    DONE.\n"

#--------------------------------------------------------------------------------------------------
  # To disable services upon first boot, copy, paste, modify accordingly:

    # DNScrypt #
    #  if [ -e $INIT/dnscrypt-proxy ]; then
    #    printf "\n  Stopping & Disabling DNScrypt...\n"
    #      for dcr in $INIT/dnscrypt-proxy; do
    #        if [ -e $dcr ]; then
    #          $dcr disable
    #          $dcr stop
    #          pidof $dcr | wc -w 2>&1 | indent
    #        fi
    #      done
    #      printf "    DONE.\n"
    #  fi
) >> ${logfile}

#==================================================================================================

    # OpenSSH #
#--------------------------------------------------------------------------------------------------
(
  printf "\n\n  # OpenSSH #\n"
  printf %b $SUBHEADn
    printf "\n  Removing OpenSSH Default Keys...\n"
      rm $SSH/ssh_host_* 2>&1
      printf "    DONE.\n"

    printf $nHEADn

    # Ensure we have correct time
      ( $sysNTP && $NTP ) 2>&1

    printf %b $HEADn
    printf "\n\n  # Generating ED25519 Host Key #\n\n"
      if [ -e $SSH/ssh_host_ed25519_key ]; then
        rm $SSH/ssh_host_ed25519_key
      fi
      ssh-keygen -t ed25519 -E sha256 -C "$device $SSHs ED25519" -f $SSH/ssh_host_ed25519_key -N "" 2>&1 | indent
      printf "    DONE.\n\n"

    printf %b $HEADn
    printf "\n\n  # Generating RSA Host Key #\n\n"
      if [ -e $SSH/ssh_host_rsa_key ]; then
        rm $SSH/ssh_host_rsa_key
      fi
      ssh-keygen -b 2048 -t rsa -E sha256 -C "$device $SSHs RSA" -f $SSH/ssh_host_rsa_key -N "" 2>&1 | indent
      printf "    DONE.\n\n"

    printf %b $HEADn
    printf "\n\n  # Exporting Admin RSA SSH Key #\n\n"
      if grep -q "n" /root/.ssh/authorized_keys; then
        printf "    authorized_keys: Key exists.\n\n"
      else
        printf "    Moved existing ~/authorized_keys to ~/authorized_keys.bak\n"
        mv /root/.ssh/authorized_keys /root/authorized_keys.bak 2>&1
        cat $sshPubKey > /root/.ssh/authorized_keys 2>&1
        printf "    authorized_keys: $sshKeyComment added\n\n"
      fi
      printf "    DONE.\n\n"

    printf %b $HEADn

    printf "\n  Correcting Host Key Permissions...\n"
      chmod 600 $SSH/*_key 2>&1
      printf "    DONE.\n"

    printf "\n  Linking Moduli to /etc/ssh/moduli...\n"
      if [ ! -e /etc/ssh/moduli && -e /etc/moduli ]; then
        ln -s /etc/moduli /etc/ssh/moduli 2>&1
      fi
      printf "    DONE.\n"

    printf "\n  Correcting root Key Permissions...\n"
      chmod 700 /root 2>&1
      chmod 700 /root/.ssh 2>&1
      chmod 600 /root/.ssh/authorized_keys 2>&1
      printf "    DONE.\n"

    printf "\n  Restarting OpenSSH...\n"
      ( $sysNTP && $NTP ) 2>&1
      $INIT/sshd enable
      $INIT/sshd restart
      printf "    DONE.\n"
) >> ${logfile} 2>&1

#==================================================================================================

    # OpenSSL #
#--------------------------------------------------------------------------------------------------

# Create Required Directories
  if [ ! -e $SSL/ca ]; then
    mkdir -p $SSL/ca
  fi
  if [ ! -e $SSL/crl ]; then
    mkdir -p $SSL/crl
  fi
  if [ ! -e $SSL/certs ]; then
    mkdir -p $SSL/certs
  fi

#==================================================================================================

    # OpenVPN #
#--------------------------------------------------------------------------------------------------
(
  printf "\n\n  # OpenVPN #\n"
  printf %b $SUBHEADn

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

    if [ -e /etc/init.d/openvpn ]; then
      printf "\n  Generating TLS-Crypt Key...\n"
        $INIT/openvpn stop ; sleep 2
          if [ ! -e $VPN/*_$tc ]; then
            openvpn --genkey --secret "$VPN/vpnadmin_$tc"
          else
            rm "$VPN/*_$tc"
            openvpn --genkey --secret "$VPN/vpnadmin_$tc"
          fi
        $INIT/openvpn start
        pidof $INIT/openvpn | wc -w 2>&1 | indent
    else
      printf "    OpenVPN not installed\n"
    fi
      printf "    DONE.\n"
) >> ${logfile} 2>&1

#==================================================================================================

    # Email Log without Moduli Creation #
#--------------------------------------------------------------------------------------------------

cp ${logfile} ${logfile}.tmp

(
  # Ensure we have correct time
  ( $sysNTP && $NTP ) 2>&1

  printf $nnHEADn
  printf "                      Beginning Moduli Creation"
  printf $nHEADn
  printf "    $up\r\n"
) >> ${logfile}.tmp

echo "</pre>" >> ${logfile}.tmp

# Create SSMTP Config:
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
  fi
  sed -i "s/DEVICE/$device/g" ${ssmtp}  2>&1
  sed -i "s/DN/$dn/g"         ${ssmtp}  2>&1
  sed -i "s/HN/$hn/g"         ${ssmtp}  2>&1
  sed -i "s/DOMAIN/$Domain/g" ${ssmtp}  2>&1
  sed -i "s/MAIL/$Mail/g"     ${ssmtp}  2>&1
  sed -i "s/PASS/$Pass/g"     ${ssmtp}  2>&1
  sed -i "s/USER/$User/g"     ${ssmtp}  2>&1

# Ensure we have correct time
  ( $sysNTP && $NTP ) 2>&1

  # Email R1:
  ssmtp -v -C ${ssmtp}  $emailR1 < ${logfile}.tmp

#==================================================================================================

  # OpenSSH Moduli #
#--------------------------------------------------------------------------------------------------
(
  printf "\n\n  # OpenSSH Moduli #\n"
  printf %b $SUBHEADn

    printf "\n  Generating Moduli Candidates...\n\n"
      ssh-keygen -G $SHT/2048.C -b 2048 2>&1

    printf "\n\n  Selecting Moduli Candidates...\n\n"
      ssh-keygen -T $SHT/2048.S -f $SHT/2048.C 2>&1

    printf "\n  Replacing and Re-Linking Moduli...\n\n"
      if [ -e /etc/moduli ]; then
        rm -f /etc/ssh/moduli 2>&1
        mv /etc/moduli /tmp/moduli.orig 2>&1
      fi

      cp $SHT/2048.S /etc/moduli 2>&1
      ln -s /etc/moduli /etc/ssh/moduli
      ( $sysNTP && $NTP ) 2>&1
      $INIT/sshd stop
      $INIT/sshd start
      printf "    DONE.\n"
) >> ${logfile} 2>&1

#==================================================================================================

    # Email #
#--------------------------------------------------------------------------------------------------
(
  ( $sysNTP && $NTP ) 2>&1

  printf $nnHEADn
  printf "                Script Finished @ $dtY $dtT"
  printf $nHEADn
  printf "        $up\r\n"
) >> ${logfile} 2>&1

# Footer:
  echo "</pre>" >> ${logfile}

# Ensure we have correct time
  ( $sysNTP && $NTP ) 2>&1

# Email R1:
  ssmtp -v -C ${ssmtp}  $emailR1 < ${logfile}
  cat ${logfile} > $LOG1
  if [ -e ${BAK} ]; then
    cp /tmp/first-run_*.log ${BAK} && chmod -R 400 ${BAK}
  fi

    # Email TLS Crypt PSK #
#--------------------------------------------------------------------------------------------------

if [ -e /etc/init.d/openvpn ]; then
  # Header:
  (
    echo "To: ${emailR1}"
    echo "Subject: ${subject2}"
    echo "Content-Type: text/html"
    echo "MIME-Version: 1.0"
    printf "\r\n"
  ) > ${gpgfile}

  # Body:
  (
    echo "<pre style=\"font-size:12px\">"
    printf "\r"
  ) >> ${gpgfile}

  # Ensure we have correct time
    ( $sysNTP && $NTP ) 2>&1

  # Encrypt:
    gpg --batch -a -r $adminEKEY -e < $VPN/vpnadmin_$tc >> ${gpgfile} 2>&1

  # Footer:
    echo "</pre>" >> ${gpgfile}

  # Email R1:
    ssmtp -v -C ${ssmtp}  $emailR1 < ${gpgfile}
    cat ${gpgfile} > $LOG2
fi

# Ensure we have correct time
  ( $sysNTP && $NTP ) 2>&1

# Exit:
  rm -rf ${SHT} 2&>1
  exit 2>&1
