

####################################################
          ##----- OpenWrt Aliases -----##
####################################################

    # Paths #
#---------------------------------------------------

# Directories:
  OWrt="$HOME/openwrt"

    DEV="$OWrt/devices"
    DIFF="$OWrt/diff"
    MAK="$OWrt/make"
    SOURCE="$OWrt/source"

      tchain="$(find $SOURCE/staging_dir -maxdepth 1 -name "toolchain-*")"


    # Compiling #
#---------------------------------------------------

# Git:
alias wrta='git pull && ./scripts/feeds update -a && ./scripts/feeds install -a'
alias wrtg='git pull'


# Make:

  # Menuconfig
alias wrt='make MENUCONFIG_COLOR=blackbg menuconfig'
alias wrtk='make MENUCONFIG_COLOR=blackbg kernel_menuconfig'

  # Default Config
alias wrtD='make defconfig'

  # Prerequisites
alias wrtP='make prereq'


    # Scripts #
#---------------------------------------------------

# Update:
alias wrtu='./scripts/feeds update -a'
alias wrti='./scripts/feeds install -a'

# Diff Config:
alias wrtd='./scripts/diffconfig.sh'

# Environment:
alias wrte='./scripts/env'
alias wrted='./scripts/env diff'


    # Clean Up #
#---------------------------------------------------

# Force Removal:

target="$(find $SOURCE/build_dir -maxdepth 1 -name "target-*")"

alias wrtC='chmod -R 775 $target/root-mvebu/root && rm -rf $target/root-mvebu/root && make V=s'


####################################################
             ##----- Compiling -----##
#---------------------------------------------------

    # Staging & CCache #
#---------------------------------------------------

# OpenWrt:
STAGING_DIR=/home/user/openwrt/source/staging_dir/toolchain


    # Exports #
#---------------------------------------------------

# Colored GCC warnings and errors:
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# OpenWrt Staging:
export STAGING_DIR

