#!/bin/bash

    ##::[[--- Ubuntu 14 ClearFog MMC Image Creation ---]]::##

#================================================================
  # Title:        compile_mmc.sh
  # Description:  Creates the required U-Boot UART & MMC Images
  # Author:       JW0914
  # Created:      2018.01.24
  # Updated:      2018.01.24
  # Version:      1.0
  # Usage:        chmod +x ./compile_mm.sh && ./compile_mmc.sh
#================================================================


  # NOTE:
    # Due to SolidRun not maintaining their repo, I recommend
    # utilizing Ubuntu 14 (requires the least amount of hassle),
    # as their repo requires a max GCC version of 4.x



# Paramaters #
#----------------------------------------------------------------

  # User Name:
    user="$(echo $USER)"


  # Directories
    WD="/home/$user/compile"
      UB="$WD/u-boot-armada38x"


  # Commands:
    ag="sudo apt-get"


  # Packages (U-Boot & OpenWrt)
    PreReqs="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cl-getopt cryptsetup fastjar flex gawk gcc gcc-arm-none-eabi gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.55-dev libgtk-3-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-7-jdk patch perl-modules python3-dev rsync ruby sdcc sharutils subversion u-boot-tools util-linux unzip wget xsltproc zlib1g-dev"



# Prepare #
#----------------------------------------------------------------
sudo echo

printf "\n\n\n    # Prepararations #\n"
printf %b "============================================================\n"


  # Update:
    printf "\n\n\n...Updating Package Lists...\n"
    printf %b "----------------------------\n\n"
      $ag update && printf "\n\n  -----  DONE: Updating Package Lists  -----\n"


  # Install Packages:
    printf "\n\n\n...Installing Prequisite Packages...\n"
    printf %b "------------------------------------\n\n"
      $ag install $PreReqs && printf "\n\n  -----  DONE: Installed Prerequisite Packages  -----\n"



# Package Maintainance #
#----------------------------------------------------------------
printf "\n\n\n    # Package Maintainance #\n"
printf %b "============================================================\n"


  # Upgrade Packages:
    printf "\n\n\n...Checking for Package Upgrades...\n"
    printf %b "-----------------------------------\n\n"
      $ag upgrade && printf "\n\n  -----  DONE: Upgraded Any Required Packages  -----\n"


  # Remove Unused
    printf "\n\n\n...Removing Unused Packages...\n"
    printf %b "------------------------------\n\n"
      $ag autoremove && printf "\n\n  -----  DONE: Removed Any Unused Packages  -----\n"


  # Check Broken Dependencies
    printf "\n\n\n...Checking for Broken Dependencies...\n"
    printf %b "--------------------------------------\n\n"
      $ag check && printf "\n\n  -----  DONE: Checked for Broken Dependencies  -----\n"



# Build Environment #
#----------------------------------------------------------------
printf "\n\n\n    # Build Environment: Create #\n"
printf %b "============================================================\n"


  # Clone:
    printf "\n\n\n...Cloning U-Boot Armada38X Repo...\n"
    printf %b "-----------------------------------\n\n"
      mkdir -p $WD && cd $WD
        git clone https://github.com/SolidRun/u-boot-armada38x.git
        printf "\n\n  -----  DONE: Armada38X Repo Cloned  -----\n"


  # Own & Enter:
    printf "\n\n\n...Own & Enter...\n"
    printf %b "-----------------\n\n"
      sudo chown -R $user:$user $UB  && cd $UB
      printf "\n\n  -----  DONE: Ownership Obtained & Directory Entered  -----\n"



# Configure #
#----------------------------------------------------------------
printf "\n\n\n    # Build Environment: Configure & Make #\n"
printf %b "============================================================\n"


  # Update Repo:
    printf "\n\n\n...Exporting Toolchain...\n"
    printf %b "-------------------------\n\n"
      export CROSS_COMPILE=arm-none-eabi- && printf "\n\n  -----  DONE: Toolchain Prefix Exported  -----\n"


  # Make Config
    printf "\n\n\n...Making Config...\n"
    printf %b "-------------------\n\n"
      make armada_38x_clearfog_config && printf "\n\n  -----  DONE: ClearFog Armada38X Config Generated  -----\n"


    printf "\n\n\n...Making Boot Files...\n"
    printf %b "-----------------------\n\n"
      make u-boot.mmc && printf "\n\n  -----  DONE: eMMC & UART Boot Files Created  -----\n"



# Verify Created Files #
#----------------------------------------------------------------

printf "\n\n\n    # Verify Created Files #\n"
printf %b "============================================================\n"


  # Update Repo:
    printf "\n\n\n...MMC Boot Files...\n"
    printf %b "--------------------\n\n"
      ls -AFls $UB/*.mmc



# Boot & Flash ClearFog #
#----------------------------------------------------------------
printf %b "\n\n\n============================================================\n"
printf "                 # Boot and Flash CLearFog #\n"
printf %b "============================================================\n"

  # Boot from UART:
      ( printf "\n\n\n   To boot in UART mode\n"
      printf %b "  ----------------------\n" )

        printf "\n\n  - Issue: sudo ./download-serial.sh /dev/ttyUSB0 u-boot-uart.mmc"
          printf "\n    - Loads UART image in memory to access U-Boot terminal"

        printf "\n\n  - Issue: sudo kwboot -t /dev/ttyUSB0 -B 115200n8"
          printf "\n    - Opens a serial terminal for U-Boot\n"


        printf "\n\n  Follow this wiki:"
        printf "\n\n  - https://clockworkbird9.wordpress.com/2016/10/06/armada-388-clearfog-install-lede-into-emmc-in-an-easy-way/"


printf %b "\n\n\n============================================================\n\n"


  # Executing download-serial.sh
    printf "\n\n\n...Executing download-serial.sh...\n"
    printf %b "------------------------------------\n\n"
      xterm -hold -T "Loading UART image into RAM" -e "sudo /home/$(echo $USER)/compile/u-boot-armada38x/download-serial.sh /dev/ttyUSB0 /home/$(echo $USER)/compile/u-boot-armada38x/u-boot-uart.mmc && sudo kwboot -t /dev/ttyUSB0 -B 115200n8" &
      printf %b "\n\n  -----  DONE: Loaded UART Image & U-Boot Terminal  -----\n"


  # Done #
  #--------------------------------------
    printf "\n\n\n...Script completed...\n"
    printf %b "----------------------\n\n\n"
      exit 0
