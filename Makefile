TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = MobileSafari
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NewTab

NewTab_FILES = Tweak.xm
NewTab_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
