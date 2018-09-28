BOARD_SEPOLICY_DIRS += $(if $(CONFIG_BLUETOOTH), \
	system/bt/vendor_libs/linux/sepolicy)

DEVICE_MANIFEST_FILE += $(PLATFORM_PATH)/bluetooth/manifest.xml
