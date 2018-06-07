#!/bin/bash

       ##::[[--- OpenWrt Ubuntu x64 Build Script ---]]::##

#================================================================
  # Title:        lede-build.sh
  # Description:  Creates the OpenWrt Build Environment in Ubuntu
  # Author:       JW0914
  # Created:      2017.07.09
  # Updated:      2018.06.06
  # Version:      2.1
  # Usage:        chmod +x ./lede-build.sh && ./lede-build.sh
#================================================================


# Paramaters #
#----------------------------------------------------------------

# User Name:
  user="$(echo $USER)"


# Directories:N
  UH="$(echo $HOME)"

  OWrt="/home/$user/openwrt"

    DEV="$OWrt/devices"
    DIFF="$OWrt/diff"
    MAK="$OWrt/make"
    SOURCE="$OWrt/openwrt"
      STAGING="$SOURCE/staging_dir"

    CF="$OWrt/clearfog"
      CFU="$CF/u-boot-armada38x"

  TOOLCHAIN="$(find /home/$user/openwrt/openwrt/staging_dir -maxdepth 1 -name "toolchain-*")"


# Files:
  crypto="package/kernel/linux/modules/crypto.mk"
  cryptoM="https://raw.githubusercontent.com/JW0914/Wikis/master/Scripts%2BConfigs/LEDE/Marvell-CESA/wrt-ac-series-addition_crypto.mk"
  cryptoT="$SOURCE/crypto-temp"

  nano="package/feeds/packages/nano/Makefile"
  nanoM="https://raw.githubusercontent.com/JW0914/Wikis/master/Scripts%2BConfigs/LEDE/Nano/Makefile"
  nanoT="$SOURCE/nano-temp"

  bashrcM="https://raw.githubusercontent.com/JW0914/Wikis/master/Scripts%2BConfigs/LEDE/Bash/.bashrc"
  bashrcT="$SOURCE/bashrc-temp"


# Commands:

  # apt-get
    ag="sudo apt-get"

  # Date:
    dt=$(date +%Y.%m.%d_%H:%M:%S)

  # MenuConfig:
    wrt="make MENUCONFIG_COLOR=blackbg menuconfig"


  # Update:
    wrtG="git pull"
    wrtU="$SOURCE/scripts/feeds update -a"
    wrtI="$SOURCE/scripts/feeds install -a"

  # Config:
    wrtd="$SOURCE/scripts/diffconfig.sh"
    wrtD="make defconfig"
    wrtp="make prereq"


  # Environments:
    # See: https://lede-project.org/docs/guide-developer/using-build-environments

    gcu="git config --global user.name '$user'"
    gce="git config --global user.email '$user@openwrt.buildroot'"

    wrtE="$SOURCE/scripts/env"
    wrtED="$SOURCE/scripts/env diff"


# Packages:

  # All:
    Req="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-9-jdk patch rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"


  # 14.04 (ClearFog):
    PR1404="cl-getopt gcc-arm-none-eabi libboost1.55-dev libgtk2.0-dev openjdk-7-jdk perl-modules python3-dev u-boot-tools"

  # 16.04:
    PR1604="libboost1.58-dev libgtk2.0-dev openjdk-8-jdk perl-modules-5.22 python3-dev"

  # 16.10:
    PR1610="libboost1.61-dev libgtk2.0-dev openjdk-9-jdk perl-modules-5.22 python3-dev"

  # 17+:
    PR17="libboost1.63-dev libgtk-4-dev openjdk-9-jdk perl-modules-5.26 python3.7-dev"


  # Errors:
    ERROR=" "


# Git Sources

  # ClearFog
    CFA="git clone https://github.com/SolidRun/u-boot-armada38x.git"

  # LEDE 17.01.4
    L17="git clone -b lede-17.01 https://github.com/openwrt/openwrt.git"

  # lEDE 17.x Development Branch
    LD17="git clone -b master https://github.com/openwrt/openwrt.git"

  # OpenWrt 18.x Development Branch
    OD18="git clone -b openwrt-18.06 https://github.com/openwrt/openwrt.git"


# Prepare #
#----------------------------------------------------------------
printf "\n\n\n    # Prepararations #\n"
printf %b "============================================================\n"


  # Update:
    printf "\n...Updating Package Lists...\n"
    printf %b "----------------------------\n\n"
      $ag update && printf "\n  -----  DONE: Updating Package Lists  -----\n"



# Menu #
#----------------------------------------------------------------
printf "\n\n\n    # OS Prerequisites #\n"
printf %b "============================================================\n"


  # Choose Prereqs:
    printf "\n...Choose Prerequisite OS Packages...\n"
    printf %b "-------------------------------------\n"


    (
      # Options:
        options[0]="Ubuntu 14.04"
        options[1]="Ubuntu 16.04"
        options[2]="Ubuntu 16.10"
        options[3]="Ubuntu 17+"

      # Actions:
        function ACTIONS {
          if [[ ${choices[0]} ]]; then
            printf "\n=====>  Ubuntu 14.04 selected  <=====\n"
              sleep 3

              printf "\n\n...Installing Prerequisite Packages...\n"
              printf %b "--------------------------------------\n\n"
                $ag install $Req $PR1404

            printf "\n  -----  DONE: Installed 14.04 Prerequisites  -----\n"
          fi

          if [[ ${choices[1]} ]]; then
            printf "\n=====>  Ubuntu 16.04 selected  <=====\n"
              sleep 3

              printf "\n\n...Installing Prerequisite Packages...\n"
              printf %b "--------------------------------------\n\n"
                $ag install $Req $PR1604

            printf "\n  -----  DONE: Installed 16.04 Prerequisites  -----\n"
          fi

          if [[ ${choices[2]} ]]; then
            printf "\n=====>  Ubuntu 16.10 selected  <=====\n\n\n"
              sleep 3

              printf "\n\n...Installing Prerequisite Packages...\n"
              printf %b "--------------------------------------\n\n"
              $ag install $Req $PR1610

            printf "\n  -----  DONE: Installed 16.10 Prerequisites  -----\n"
          fi

          if [[ ${choices[3]} ]]; then
            printf "\n=====>  Ubuntu 17+ selected  <=====\n"
              sleep 3

              printf "\n\n...Installing Prerequisite Packages...\n"
              printf %b "--------------------------------------\n\n"
                $ag install $Req $PR17

            printf "\n  -----  DONE: Installed 17|18 Prerequisites  -----\n"
          fi
        }

      # Function
        function MENU {
          printf "\n  OS Selection\n"
          printf %b "=================\n"
            for NUM in ${!options[@]}; do
              echo "${choices[NUM]:- }" $(( NUM+1 ))") ${options[NUM]}"
            done
          echo " "
        }

      # Execution:
        MENU && read -e -p "Selected OS: " -n1 SELECTION && [[ -n "$SELECTION" ]]
          if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
            (( SELECTION-- ))

            if [[ "${choices[SELECTION]}" == "+" ]]; then
              choices[SELECTION]=""
            else
              choices[SELECTION]="+"
            fi

          else
            ERROR="Invalid option: $SELECTION"
          fi

      # Install Prereqs:
        ACTIONS
    )



# Package Maintainance #
#----------------------------------------------------------------
printf "\n\n\n    # Package Maintainance #\n"
printf %b "============================================================\n"


  # Upgrade Packages:
    printf "\n...Upgrading Required Packages...\n"
    printf %b "---------------------------------\n\n"
      $ag upgrade && printf "\n  -----  DONE: Upgraded Any Required Packages  -----\n"


  # Remove Unused
    printf "\n\n\n...Removing Unused Packages...\n"
    printf %b "------------------------------\n\n"
      $ag autoremove && printf "\n  -----  DONE: Removed Any Unused Packages  -----\n"


  # Check Broken Dependencies
    printf "\n\n\n...Checking for Broken Dependencies...\n"
    printf %b "--------------------------------------\n\n"
      $ag check && printf "\n  -----  DONE: Checked for Broken Dependencies  -----\n"



# Build Environment #
#----------------------------------------------------------------
printf "\n\n\n    # OpenWrt Build Environment: Create #\n"
printf %b "============================================================\n"


# Choose Prereqs:
  printf "\n...Choose OpenWrt Branch...\n"
  printf %b "---------------------------\n"
    mkdir -p $OWrt $DEV $DIFF $MAK && cd $OWrt

    (
      # Options:
        options[0]="17.01"
        options[1]="17.xx"
        options[2]="18.xx"


      # Actions:
        function ACTIONS {
          if [[ ${choices[0]} ]]; then
            printf "\n=====>  LEDE 17.01.4 selected  <=====\n"
              sleep 3

              printf "\n\n\n...Cloning OpenWrt from Git...\n"
              printf %b "------------------------------\n\n"
                $L17

            printf "\n  -----  DONE: Cloned LEDE 17.01.4 Source  -----\n"
          fi

          if [[ ${choices[1]} ]]; then
            printf "\n=====>  LEDE 17.x Development Branch selected  <=====\n"
              sleep 3

              printf "\n\n\n...Cloning OpenWrt from Git...\n"
              printf %b "------------------------------\n\n"
                $LD17

            printf "\n  -----  DONE: Cloned LEDE 17.xx Development Source  -----\n"
          fi

          if [[ ${choices[2]} ]]; then
            printf "\n=====>  OpenWrt 18.xx Development Branch selected  <=====\n"
              sleep 3

              printf "\n\n\n...Cloning OpenWrt from Git...\n"
              printf %b "------------------------------\n\n"
                $OD18

            printf "\n  -----  DONE: Cloned OpenWrt 18.x Development Source  -----\n"
          fi
        }


      # Function
        function MENU {
          printf "\n  Branch Selection\n"
          printf %b "====================\n"
          for NUM in ${!options[@]}; do
            echo "${choices[NUM]:- }" $(( NUM+1 ))") ${options[NUM]}"
          done
          echo " "
        }


      # Execution:
        MENU && read -e -p "Selected Branch: " -n1 SELECTION && [[ -n "$SELECTION" ]]
          if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
            (( SELECTION-- ))

            if [[ "${choices[SELECTION]}" == "+" ]]; then
              choices[SELECTION]=""
            else
              choices[SELECTION]="+"
            fi

          else
            ERROR="Invalid option: $SELECTION"
          fi


      # Install Prereqs:
        ACTIONS
    )


# OpenWrt Configure #
#----------------------------------------------------------------
printf "\n\n\n    # OpenWrt Build Environment: Configure #\n"
printf %b "============================================================\n"


  # Rename & Enter:
    printf "\n...Own & Enter...\n"
    printf %b "-----------------\n"
      sudo chown -R $user:$user $SOURCE/ && cd $SOURCE && printf "\n  -----  DONE: Ownership Obtained & Buildroot Entered  -----\n"


  # Update Repo:
    printf "\n\n\n...Updating Repo...\n"
    printf %b "-------------------\n\n"
      $wrtG && printf "\n  -----  DONE: LEDE Repo Up-to-Date  -----\n"


  # Update & Install Feeds:
    printf "\n\n\n...Updating Feeds...\n"
    printf %b "--------------------\n\n"
      $wrtU && printf "\n  -----  DONE: Feeds Updated  -----\n"


    printf "\n\n\n...Installing Feeds...\n"
    printf %b "----------------------\n\n"
      $wrtI && printf "\n  -----  DONE: Feeds Installed  -----\n"


  # Copy Custom Files Over
    #printf "\n\n\n...Copying Custom Files & Directories...\n"
    #printf %b "----------------------------------------\n\n"
    #  cp -R $DEV $OWrt
    #    cp -R $DEV/configs/* $OWrt
    #    cp -R $DEV/wrt1900acs/files $OWrt
    #  printf "\n  -----  DONE: Custom Files Copied.....\n"



# Customize Makefiles:
#----------------------------------------------------------------
printf "\n\n\n    # OpenWrt Build Environment: Update Makefiles #\n"
printf %b "============================================================\n"


  # Nano:
    printf "\n...Creating custom Nano Makefile...\n"
    printf %b "-----------------------------------\n\n"
      cp $nano $MAK/nano-orig.Makefile && echo > $nano
        wget $nanoM -O $nanoT && cat $nanoT > $nano && rm -f $nanoT
      printf "\n  -----  DONE: Nano Makefile Replaced  -----\n"


# Build #
#----------------------------------------------------------------
printf "\n\n\n    # OpenWrt Build Environment: MenuConfig #\n"
printf %b "============================================================\n"


  # Run MenuConfig:
    printf "\n...Running MenuConfig...\n"
    printf %b "------------------------\n\n"
      $wrt && printf %b "  -----  DONE: Config Created  -----\n"


  # Default, PreReq, & Diff Configs:
    printf "\n\n\n...Creating DefConfig, PreReq, & DiffConfig...\n"
    printf %b "----------------------------------------------\n\n"
      $wrtD && printf "\n  -----  DONE: DefConfig Created  -----\n\n\n"
      $wrtp && printf "\n\n  -----  DONE: Prerequisites Satisfied  -----\n"
      $wrtd > $DIFF/diffconfig-$dt && printf "\n\n  -----  DONE: DiffConfig Created  -----\n"


  # Environment:
    printf "\n\n\n...Creating Environment...\n"
    printf %b "--------------------------\n\n"
      #$gcu && $gce
      #  $wrtE new current && printf "\n  -----  DONE: Environment Created for Current Build  -----\n"


  # Modify ~/.bashrc
    printf "\n\n\n...Adding Toolchain to ~/.bashrc...\n"
    printf %b "-----------------------------------\n\n"
      cp ~/.bashrc ~/.bashrc.bak
        export PATH="$PATH:$TOOLCHAIN/bin:$STAGING/host/bin"
        wget $bashrcM -O $bashrcT && cat $bashrcT >> ~/.bashrc && rm -f $bashrcT
          sed -i "s|STAGING_DIR=$tchain|STAGING_DIR=$TOOLCHAIN|g" ~/.bashrc
      source ~/.bashrc && printf "\n  -----  DONE: STAGING_DIR & Toolchain added to ~/.bashrc  -----\n"


  # Compile:
    printf "\n\n\n...Compiling Image...\n"
    printf %b "---------------------\n\n"
      make V=s && printf "\n  -----  DONE: Image Compiled  -----\n"



# Environment Usage Notes #
#----------------------------------------------------------------
printf %b "\n\n\n============================================================\n"
printf "              # Using Buildroot Environments #\n"
printf %b "============================================================\n"

  # Create Environment:
    ( printf "\n\n   Using Environments\n"
    printf %b "  --------------------\n" )
      printf "\n    - See: https://lede-project.org/docs/guide-developer/using-build-environments"
        printf "\n\n      - Allows building images for multiple configurations, using multiple targets"
        printf "\n\n    - Usage: ./scripts/env [options] <command> [arguments]"
            printf "\n      - Commands:"
              printf "\n        - help"
              printf "\n        - list"
              printf "\n        - clear"
              printf "\n        - new <name>"
              printf "\n        - switch <name>"
              printf "\n        - delete <name>"
              printf "\n        - rename <newname>"
              printf "\n        - diff"
              printf "\n        - save [message]"
              printf "\n        - revert"


printf %b "\n\n\n============================================================\n\n"



# Done #
#--------------------------------------
  printf "\n\n...Script completed...\n"
  printf %b "----------------------\n\n"


  # Function:
    function pause(){
      read -p "$*"
    }


  # Confirmation:
    pause "  Press [Enter] key to exit...
    "  && echo
    read -p "  Last chance to read 'Using Buildroot Environments'... If sure, press any key to exit
    "

  exit 0
