#!/bin/bash

        ##::[[--- OpenWrt Ubuntu x64 Build Script ---]]::##



# Paramaters #
#--------------------------------------

  # User Name:
user="<username>"


  # Commands:
#------------

  # Ubuntu:
ag="sudo apt-get"
dt=$(date +%Y.%m.%d_%H:%M:%S)

  # LEDE:
wrt="make MENUCONFIG_COLOR=blackbg menuconfig"

wrtu="./scripts/feeds update -a"
wrti="./scripts/feeds install -a"
wrtdif="./scripts/diffconfig.sh"

wrtdef="make defconfig"
wrtp="make prereq"


  # Files & Directories:
#-----------------------

crypto="package/kernel/linux/modules/crypto.mk"
nano="package/feeds/packages/nano/Makefile"

DEV="/home/$user/lede/devices"
DIF="/home/$user/lede/diff"
MAk="/home/$user/lede/make"
LEDE="/home/$user/lede/source"


  # Packages:
#------------

  # 16.04:
PR1604="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.58-dev libgtk2.0-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-8-jdk patch perl-modules-5.22 python3-dev rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"

  # 16.10:
PR1610="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.61-dev libgtk2.0-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-9-jdk patch perl-modules-5.22 python3-dev rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"

  # 17.04:
PR1704="asciidoc bash bc bcc bin86 binutils build-essential bzip2 cryptsetup fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.63-dev libgtk-3-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-9-jdk patch perl-modules-5.24 python3-dev rsync ruby sdcc sharutils subversion util-linux unzip wget xsltproc zlib1g-dev"



# Prepare #
#--------------------------------------

# Update:
printf "\n\n...Updating Package Lists...\n\n"
  $ag update

# Install Prereqs:
printf "\n\n...Installing Prerequisite Packages...\n\n"
  $ag install $PR1704

# Upgrade Packages:
printf "\n\n...Upgrading Required Packages...\n\n"
  $ag upgrade

# Remove Unused
printf "\n\n...Removing Unused Packages...\n\n"
  $ag autoremove

# Check Broken Dependencies
printf "\n\n...Checking for Broken Dependencies...\n\n"
  $ag check


  # Clone:
printf "\n\n...Cloning LEDE from GitHub...\n\n"
  mkdir lede && cd lede
  git clone https://github.com/lede-project/source.git


  # Own & Enter:
printf "\n\n...Owning & Entering...\n"
  sudo chown -R $user:$user source/ && cd $LEDE



# Configure #
#--------------------------------------

  # Update & Install Feeds:
printf "\n\n...Updating Feeds...\n\n"
  $wrtu

printf "\n\n...Installing Feeds...\n\n"
  $wrti


  # Copy Custom Files Over
printf "\n\n...Creating Directories & Copying Custom Files...\n"
  mkdir -p $DEV $DIF $MAK
#  cp -R $DEV $LEDE
#  cp -R $DEV/configs/* $LEDE
#  cp -R $DEV/wrt1900acs/files $LEDE



# Update Marvell-Cesa Crypto Makefile:
#--------------------------------------
printf "\n\n...Adding updated Marvell Cesa to crypto.mk...\n\n"
  cp $crypto $MAK/crypto-orig.mk

echo "

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

$(eval $(call KernelPackage,crypto-marvell-cesa))
" >> $crypto



# Backup & Replace Nano Makefile
#--------------------------------------
printf "\n\n...Updating Nano Makefile...\n\n"
  cp $nano $MAK/nano-orig.Makefile

echo "
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
  DEPENDS:=+libncurses
endef

define Package/nano/description
  Nano (Nano's ANOther editor, or Not ANOther editor) is an enhanced clone
  of the Pico text editor.
endef

CONFIGURE_ARGS += \
	--enable-tiny \
	--without-slang \
	--enable-utf8 \
	--enable-nanorc \
	--enable-color \
	--enable-help \
	--enable-linenumbers \
	--enable-multibuffer \
	--enable-browser \
	--enable-histories \

CONFIGURE_VARS += \
	ac_cv_header_regex_h=no \

define Package/nano/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/$(PKG_NAME) $(1)/usr/bin/
endef

$(eval $(call BuildPackage,nano))
" > $nano



# Build #
#--------------------------------------

  # Run MenuConfig:
printf "\n\n...Running MenuConfig...\n\n"
  $wrt

  # Default, PreReq, & Diff Configs:
printf "\n\n...Creating DefConfig, PreReq, & DiffConfig...\n\n"
  $wrtdef && $wrtp
  $wrtdif > $DIF/diffconfig-$dt


  # Compile:
printf "\n\n...Compiling Image...\n\n"
  make



# Done #
#--------------------------------------
printf "\n\n...Script Completed...\n\n"
  exit 0
