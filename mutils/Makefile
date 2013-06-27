THEOS_DEVICE_IP = 10.0.2.27

include theos/makefiles/common.mk

APPLICATION_NAME = mutils
mutils_FILES = main.m mutilsApplication.mm RootViewController.mm
mutils_FILES += IMessageTracker.m
mutils_FRAMEWORKS = UIKit CoreGraphics
mutils_LDFLAGS = -lsqlite3

include $(THEOS_MAKE_PATH)/application.mk
