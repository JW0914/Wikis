#!/bin/bash

        ##::[[--- LEDE Ubuntu x64 Build Script ---]]::##

#================================================================
  # Title:        lede-build.sh
  # Description:  Creates the LEDE Build Environment in Ubuntu
  # Author:       JW0914
  # Created:      2017.07.09
  # Updated:      2018.01.07
  # Version:      1.0
  # Usage:        ./lede-build.sh
#================================================================


# Paramaters #
#----------------------------------------------------------------

# User Name:
  user="$(echo $USER)"


# Directories:
  LEDE="/home/$user/lede/custom/tmp"

    DEV="$LEDE/devices"
    DIFF="$LEDE/diff"
    MAK="$LEDE/make"
    SOURCE="$LEDE/source"


# Files:
  crypto="package/kernel/linux/modules/crypto.mk"
  nano="package/feeds/packages/nano/Makefile"


# Commands:
  ag="sudo apt-get"

  dt=$(date +%Y.%m.%d_%H:%M:%S)

  wrt="make MENUCONFIG_COLOR=blackbg menuconfig"

  wrtG="git pull"

  wrtU="$SOURCE/scripts/feeds update -a"
  wrtI="$SOURCE/scripts/feeds install -a"

  wrtd="$SOURCE/scripts/diffconfig.sh"

  wrtD="make defconfig"
  wrtp="make prereq"



# Packages:

  # 16.04:
    PR1604="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.58-dev libgtk2.0-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-8-jdk patch perl-modules-5.22 python3-dev rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"

  # 16.10:
    PR1610="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.61-dev libgtk2.0-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-9-jdk patch perl-modules-5.22 python3-dev rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"

  # 17.04:
    PR1704="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.63-dev libgtk-3-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-9-jdk patch perl-modules-5.24 python3.7-dev rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"

  # 17.10:
    PR1710="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.63-dev libgtk-4-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-9-jdk patch perl-modules-5.26 python3.7-dev rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"

  # Errors:
    ERROR=" "



# Prepare #
#----------------------------------------------------------------
printf "\n\n\n    # Prepararations #\n"
printf %b "============================================================\n"


  # Update:
    printf "\n\n\n...Updating Package Lists...\n"
    printf %b "----------------------------\n\n"
      $ag update  && printf "\n\n  -----  DONE: Updating Package Lists  -----\n"



# Menu #
#----------------------------------------------------------------
printf "\n\n\n    # OS Prerequisites #\n"
printf %b "============================================================\n"


  # Choose Prereqs:
    printf "\n\n...Choose Prerequisite OS Packages...\n\n"
    printf %b "--------------------------------------\n\n"


    # Options:
      options[0]="Ubuntu 16.04"
      options[1]="Ubuntu 16.10"
      options[2]="Ubuntu 17.04"
      options[3]="Ubuntu 17.10"

    # Actions:
      function ACTIONS {
        if [[ ${choices[0]} ]]; then
          printf "\n\n...Ubuntu 16.04 selected...\n\n" && $ag install $PR1604 && printf "\n\n  -----  DONE: Installed 16.04 Prerequisites  -----\n"
        fi

        if [[ ${choices[1]} ]]; then
          printf "\n\n...Ubuntu 16.10 selected...\n\n" && $ag install $PR1610 && printf "\n\n  -----  DONE: Installed 16.10 Prerequisites  -----\n"
        fi

        if [[ ${choices[2]} ]]; then
          printf "\n\n...Ubuntu 17.04 selected...\n\n" && $ag install $PR1704 && printf "\n\n  -----  DONE: Installed 17.04 Prerequisites  -----\n"
        fi
	
        if [[ ${choices[3]} ]]; then
          printf "\n\n...Ubuntu 17.10 selected...\n\n" && $ag install $PR1710 && printf "\n\n  -----  DONE: Installed 17.10 Prerequisites  -----\n"
        fi
      }

    # Function
      function MENU {
          printf "\n\nOS Selection\n"
          printf %b "==================\n"
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
      printf "\n\n\n...Installing Prerequisite Packages...\n"
      printf %b "--------------------------------------\n\n"
        ACTIONS



# Package Maintainance #
#----------------------------------------------------------------
printf "\n\n\n    # Package Maintainance #\n"
printf %b "============================================================\n"


  # Upgrade Packages:
    printf "\n\n\n...Upgrading Required Packages...\n"
    printf %b "--------------------------------\n\n"
      $ag upgrade && printf "\n\n  -----  DONE: Upgraded Required Packages  -----\n"


  # Remove Unused
    printf "\n\n\n...Removing Unused Packages...\n"
    printf %b "------------------------------\n\n"
      $ag autoremove && printf "\n\n  -----  DONE: Removed Unused Packages  -----\n"


  # Check Broken Dependencies
    printf "\n\n\n...Checking for Broken Dependencies...\n"
    printf %b "--------------------------------------\n\n"
      $ag check && printf "\n\n  -----  DONE: Checked for Broken Dependencies  -----\n"



# Build Environment #
#----------------------------------------------------------------
printf "\n\n\n    # Build Environment: Create #\n"
printf %b "============================================================\n"


  # Clone:
    printf "\n\n\n...Cloning LEDE from GitHub...\n"
    printf %b "------------------------------\n\n"
      mkdir -p $LEDE && cd $LEDE
        git clone https://github.com/lede-project/source.git
        printf "\n\n  -----  DONE: Cloned LEDE GitHub  -----\n"


  # Rename & Enter:
    printf "\n\n\n...Own & Enter...\n"
      sudo chown -R $user:$user $SOURCE/  && cd $SOURCE  && printf "\n\n  -----  DONE: Ownership Obtained & Entered  -----\n"



# Configure #
#----------------------------------------------------------------
printf "\n\n\n    # Build Environment: Configure #\n"
printf %b "============================================================\n"


  # Update Repo:
    printf "\n\n\n...Updating Repo...\n"
    printf %b "-------------------\n\n"
      $wrtG  && printf "\n\n  -----  DONE: LEDE Repo Up-to-Date  -----\n"


  # Update & Install Feeds:
    printf "\n\n\n...Updating Feeds...\n"
    printf %b "--------------------\n\n"
      $wrtU && printf "\n\n  -----  DONE: Feeds Updated  -----\n"

    printf "\n\n\n...Installing Feeds...\n"
    printf %b "----------------------\n\n"
      $wrtI && printf "\n\n  -----  DONE: Feeds Installed  -----\n"


  # Copy Custom Files Over
    #printf "\n\n\n...Copying Custom Files & Directories...\n"
    #printf %b "----------------------------------------\n\n"
    #  cp -R $DEV $LEDE
    #    cp -R $DEV/configs/* $LEDE
    #    cp -R $DEV/wrt1900acs/files $LEDE
    #  printf "\n\n  -----  DONE: Custom Files Copied.....\n"



# Customize Makefiles:
#----------------------------------------------------------------
printf "\n\n\n    # Build Environment: Update Makefiles #\n"
printf %b "============================================================\n"



  # Marvell-Cesa Crypto:
    printf "\n\n\n...Adding updated Marvell Cesa to crypto.mk...\n"
    printf %b "----------------------------------------------\n\n"
      mkdir -p $MAK && cp $crypto $MAK/crypto-orig.mk

        echo '

define KernelPackage/crypto-marvell-cesa
  TITLE:=Marvell crypto engine (new)
  DEPENDS:=+kmod-crypto-des +kmod-crypto-manager @TARGET_kirkwood||@TARGET_orion||TARGET_mvebu
  KCONFIG:= \
    CONFIG_CRYPTO_DEV_MARVELL_CESA \
    CONFIG_CRYPTO_HW=y
  FILES:=$(LINUX_DIR)/drivers/crypto/marvell/marvell-cesa.ko
  AUTOLOAD:=$(call AutoLoad,09,marvell-cesa)
  $(call AddDepends/crypto)
endef

$(eval $(call KernelPackage,crypto-marvell-cesa))' >> $crypto  && printf "\n\n  -----  DONE: Marvell-CESA Updated  -----\n"



  # Nano:
    printf "\n\n\n...Creating custom Nano Makefile...\n"
    printf %b "-----------------------------------\n\n"
      cp $nano $MAK/nano-orig.Makefile

        echo '
#
# Copyright (C) 2007-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nano
PKG_VERSION:=2.8.4
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0+
PKG_LICENSE_FILES:=COPYING

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@GNU/nano
PKG_HASH:=c7cf264f0f3e4af43ecdbc4ec72c3b1e831c69a1a5f6512d5b0c109e6bac7b11

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/nano
  SUBMENU:=Editors
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=An enhanced clone of the Pico text editor
  URL:=http://www.nano-editor.org/
  MAINTAINER:=Jonathan Bennett <JBennett@incomsystems.biz>
  DEPENDS:=+libncurses +zlib +libmagic
endef

define Package/nano/description
  Nano (Nano`s ANOther editor, or Not ANOther editor) is an enhanced clone
  of the Pico text editor.
endef

CONFIGURE_ARGS += \
	--enable-all \
	--enable-utf8 \

CONFIGURE_VARS += \
	ac_cv_header_regex_h=no \

define Package/nano/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/$(PKG_NAME) $(1)/usr/bin/
endef

$(eval $(call BuildPackage,nano,+libmagic))' > $nano  && printf "\n\n  -----  DONE: Nano Makefile Replaced  -----\n"



# Build #
#----------------------------------------------------------------
printf "\n\n\n    # Build Environment: MenuConfig #\n"
printf %b "============================================================\n"


  # Run MenuConfig:
    printf "\n\n\n...Running MenuConfig...\n"
    printf %b "------------------------\n\n"
      $wrt  && printf "\n\n  -----  DONE: Config Created  -----\n"


  # Default, PreReq, & Diff Configs:
    printf "\n\n\n...Creating DefConfig, PreReq, & DiffConfig...\n"
    printf %b "----------------------------------------------\n\n"
      $wrtD  && printf "\n\n  -----  DONE: DefConfig Created  -----\n"
      $wrtp && printf "\n\n  -----  DONE: Prerequisites Satisfied  -----\n"
      mkdir -p $DIFF && $wrtd > $DIFF/diffconfig-$dt  && printf "\n\n  -----  DONE: DiffConfig Created  -----\n"


  # Compile:
    printf "\n\n\n...Compiling Image...\n"
    printf %b "---------------------\n\n"
      make V=s  && printf "\n\n  -----  DONE: Image Compiled  -----\n"


  # Done #
  #--------------------------------------
    printf "\n\n\n...Script completed...\n"
    printf %b "----------------------\n\n"
      exit 0
