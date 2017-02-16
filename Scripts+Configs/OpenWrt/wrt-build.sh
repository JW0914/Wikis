#!/bin/bash


        ##::[[--- OpenWrt Ubuntu x64 Build Script ---]]::##         


# Variables #
#--------------------------------------

  # User Name:
user="jw0914"


  # Commands:
ag="sudo apt-get"

wrt="make MENUCONFIG_COLOR=blackbg menuconfig"

wrtu="./scripts/feeds update -a"
wrti="./scripts/feeds install -a"

wrtd="make defconfig"
wrtp="make prereq"


  # Files & Directories:
crypto="package/kernel/linux/modules/crypto.mk"

dir="/home/$user/openwrt"
dev="$dir/dev"
devices="$dir/devices"

  # Packages:

    # 16.04:
PreReqs="asciidoc bash bc bcc bin86 binutils build-essential bzip2 fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.58-dev libgtk2.0-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-8-jdk patch perl-modules-5.22 python3-dev rsync ruby sdcc sharutils subversion util-linux wget xsltproc zlib1g-dev"

    # 16.10:
#PreReqs="asciidoc bash bc bcc bin86 binutils build-essential bzip2 fastjar flex gawk gcc gcc-multilib genisoimage gettext git-core intltool jikespg libboost1.61-dev libgtk2.0-dev libncurses5-dev libssl-dev libusb-dev libxml-parser-perl make mercurial openjdk-8-jdk patch perl-modules-5.22 python3-dev rsync ruby sdcc sharutils subversion util-linux wget xsltproc zlib1g-dev"



# Prepare #
#--------------------------------------

  # Update:
printf "\n\n...Updating Package Lists...\n\n"
$ag update

  # Install Prereqs:
printf "\n\n...Installing Prerequisite Packages...\n\n"
$ag install $PreReqs

  # Upgrade Packages:
printf "\n\n...Upgrading Required Packages...\n\n"
$ag upgrade


  # Clone:
printf "\n\n...Cloning OpenWrt from GitHub...\n\n"
mkdir -p $dir
cd $dir
git clone https://github.com/openwrt/openwrt.git


  # Rename & Enter:
printf "\n\n...Rename, Own, & Enter...\n"
mv openwrt dev
sudo chown -R $user:$user dev/
cd dev



# Configure #
#--------------------------------------

  # Update & Install Feeds:
printf "\n\n...Updating Feeds...\n\n"
$wrtu

printf "\n\n...Installing Feeds...\n\n"
$wrti


  # Copy Custom Files Over
printf "\n\n...Copying Custom Files & Directories...\n"
cp -R $devices $dev
cp -R $devices/configs/* $dev
cp -R $devices/wrt1900acs/files $dev


  # Add Updated Marvell-Cesa to Crypto Makefile:
printf "\n\n...Adding updated Marvell Cesa to crypto.mk...\n\n"
cp $crypto ../crypto.mk.original
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

$(eval $(call KernelPackage,crypto-marvell-cesa))' >> $crypto



# Build #
#--------------------------------------

  # Run MenuConfig:
printf "\n\n...Running MenuConfig...\n\n"
$wrt

  # Default & PreReq Configs:
printf "\n\n...Creating DefConfig and PreReq...\n\n"
$wrtd && $wrtp

  # Compile:
printf "\n\n...Compiling Image...\n\n"
make


printf "\n\n...Script completed...\n\n"
