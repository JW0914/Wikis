

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

