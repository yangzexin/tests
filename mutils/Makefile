THEOS_DEVICE_IP = 10.0.2.27

include theos/makefiles/common.mk

APPLICATION_NAME = mutils

# compile files
mutils_FILES = main.m mutilsApplication.mm RootViewController.m IMessageUtils.m
mutils_FILES += SingleSendController.m
mutils_FILES += IMessageTracker.m
mutils_FILES += YXBlockedButton.m
mutils_FILES += ServerSendController.m
mutils_FILES += MultipleSendController.m
mutils_FILES += IMessageCenter.m

# other settings
mutils_FRAMEWORKS = UIKit CoreGraphics
mutils_LDFLAGS = -lsqlite3

include $(THEOS_MAKE_PATH)/application.mk
