# Check http://android.mk/ for more details

# Location of this make file
LOCAL_PATH := $(call my-dir)

#
ifeq ($(TARGET_ARCH),x86)
    ARCH := ia32
else ifeq ($(TARGET_ARCH),arm)
    ARCH := arm
else ifeq ($(TARGET_ARCH),arm64)
    ARCH := arm64
else
    $(error Unknown/Unsupported TARGET_ARCH "$(TARGET_ARCH)")
endif

#
BUILDDIR := ../../../../build/Android.$(ARCH).shared.$(APP_OPTIM)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := v8
LOCAL_SRC_FILES       := $(BUILDDIR)/libv8.so
include $(PREBUILT_SHARED_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := v8_base
LOCAL_SRC_FILES       := $(BUILDDIR)/libv8_base.a
include $(PREBUILT_STATIC_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := v8_libbase
LOCAL_SRC_FILES       := $(BUILDDIR)/libv8_libbase.a
include $(PREBUILT_STATIC_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := v8_libplatform
LOCAL_SRC_FILES       := $(BUILDDIR)/libv8_libplatform.a
include $(PREBUILT_STATIC_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := v8_nosnapshot
LOCAL_SRC_FILES       := $(BUILDDIR)/libv8_nosnapshot.a
include $(PREBUILT_STATIC_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := v8_snapshot
LOCAL_SRC_FILES       := $(BUILDDIR)/libv8_snapshot.a
include $(PREBUILT_STATIC_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := icudata
LOCAL_SRC_FILES       := $(BUILDDIR)/libicudata.a
include $(PREBUILT_STATIC_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := icui18n
LOCAL_SRC_FILES       := $(BUILDDIR)/libicui18n.so
include $(PREBUILT_SHARED_LIBRARY)

#
include $(CLEAR_VARS)
LOCAL_MODULE          := icuuc
LOCAL_SRC_FILES       := $(BUILDDIR)/libicuuc.so
include $(PREBUILT_SHARED_LIBRARY)