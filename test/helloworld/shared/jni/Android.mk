# Check http://android.mk/ for more details

# Location of this make file
LOCAL_PATH := $(call my-dir)

# Calls V8 makefile to setup v8 library targets
include $(LOCAL_PATH)/V8.mk

# Calls a makefile to clear all LOCAL_* values so that consecutive runs don't get polluted
include $(CLEAR_VARS)

# General LOCAL options for helloworld application
LOCAL_MODULE    := helloworld
LOCAL_SRC_FILES := ../../android_main.cpp ../../execute_js.cpp
LOCAL_LDLIBS    := -llog -landroid

# Enable C++11 support
LOCAL_CFLAGS := -std=c++11

# Include V8 headers and static libraries
# NOTE: Order of libraries matters here
LOCAL_SHARED_LIBRARIES := v8 icui18n icuuc
LOCAL_STATIC_LIBRARIES := v8_base v8_libbase v8_libplatform v8_snapshot icudata
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../include

# Calls a makefile to which uses all above LOCAL_* to build a shared library
include $(BUILD_SHARED_LIBRARY)