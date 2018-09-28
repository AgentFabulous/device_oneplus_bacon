#
# Copyright (C) 2016 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# AOSP Packages
PRODUCT_PACKAGES += \
    Launcher3 \
    messaging \
    Terminal

# API (for CTS backward compatibility)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=19

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Disable lockscreen discard
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lockscreen.secdiscard=false

# Display
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
PRODUCT_PROPERTY_OVERRIDES += debug.hwui.use_buffer_age=false

# Limit dex2oat threads to improve thermals
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-threads=2 \
    dalvik.vm.image-dex2oat-threads=4

# Disable Treble properties
PRODUCT_PROPERTY_OVERRIDES += \
    persist.media.treble_omx=false \
    camera.disable_treble=true

# Bionic
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bionic.ld.warning=0

define inherit-product-dirs
 $(foreach dir,$(1), \
   $(call inherit-product-if-exists, $(LOCAL_PATH)/$(dir)/device.mk) \
 )
endef

define inherit-product-if-true
 $(call inherit-product-if-exists, $(if $(filter true,$(1)),$(2)))
endef

define add-to-product-copy-files-if-true
 $(call add-to-product-copy-files-if-exists, $(if $(filter true,$(1)),$(2)))
endef

$(foreach dev,$(wildcard vendor/*/*/device-partial.mk), $(call inherit-product, $(dev)))

PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
			system/core/rootdir/init.rc:root/init.rc \
			$(LOCAL_PATH)/init.rc:root/init.unknown.rc \
			$(LOCAL_PATH)/ueventd.rc:root/ueventd.unknown.rc \
			$(LOCAL_PATH)/fstab:root/fstab.unknown)

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    $(LOCAL_PATH)/media_codecs.xml:system/etc/media_codecs.xml \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gadgets.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/gadgets.rc \
    $(LOCAL_PATH)/init.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.sh \

# Dalvik
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=16m \
    dalvik.vm.heapgrowthlimit=192m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapmaxfree=8m

# HWUI
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hwui.texture_cache_size=72 \
    ro.hwui.layer_cache_size=48 \
    ro.hwui.path_cache_size=32 \
    ro.hwui.gradient_cache_size=1 \
    ro.hwui.drop_shadow_cache_size=6 \
    ro.hwui.r_buffer_cache_size=8 \
    ro.hwui.texture_cache_flushrate=0.4 \
    ro.hwui.text_small_cache_width=1024 \
    ro.hwui.text_small_cache_height=1024 \
    ro.hwui.text_large_cache_width=2048 \
    ro.hwui.text_large_cache_height=1024

PRODUCT_PACKAGES += \
	linaro-vndk \
	android.hardware.drm@1.0-service \
	android.hardware.drm@1.0-impl \
	android.hardware.audio@2.0-impl \
	android.hardware.audio@2.0-service \
	android.hardware.audio.effect@2.0-impl \
	android.hardware.keymaster@3.0-impl \
	android.hardware.keymaster@3.0-service \
	android.hardware.soundtrigger@2.0-impl

subdirs-true := lights graphics
subdirs-true += firmware
subdirs-true += lowmem
subdirs-true += bluetooth
subdirs-true += wifi
subdirs-true += sensor
$(call inherit-product-dirs, $(subdirs-true))