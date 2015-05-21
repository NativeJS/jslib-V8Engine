##
# V8Engine Win64 makefile
# description     : Windows dependency installer for V8Engine
# author          : Almir Kadric
# created on      : 2014-10-29
##



##
# Global variables
##

# Set default shell
SHELL = /bin/bash

# Select default platform
# NOTE: Indentation for this section must be spaces and not tabs
ifndef PLATFORM
    ifeq ($(OS),Windows_NT)
        PLATFORM=Windows
    else
        UNAME_S := $(shell uname -s)
        ifeq ($(UNAME_S),Linux)
            PLATFORM=Linux
        else ifeq ($(UNAME_S),Darwin)
            PLATFORM=MacOSX
        else
            $(error Unknown/Unsupported Platform "$(OS)")
        endif
    endif
endif

# Try and guess android paths if not set
ANDROID_NDK_ROOT ?= $(shell ls -d /opt/android-ndk-r10d 2>/dev/null || ls -d /Applications/android-ndk-r10d 2>/dev/null)
ANDROID_SDK_ROOT ?= $(shell ls -d /opt/android-sdk-r24.2 2>/dev/null || ls -d /Applications/android-sdk-r24.2 2>/dev/null)
APACHE_ANT_PATH ?= $(shell ls /opt/local/bin/ant 2>/dev/null)
ADB = $(ANDROID_SDK_ROOT)/platform-tools/adb

#
INCLUDEDIR = ../../../include
BUILDDIR = ../../../build
V8LIBS =  -lv8_base -lv8_libbase -lv8_libplatform -lv8_snapshot -licui18n -licuuc -licudata -pthread
TESTFILES = ../main.cpp ../execute_js.cpp
CXX11 = g++ -std=c++11 -I$(INCLUDEDIR)

#
MSBUILD = "/cygdrive/c/Program Files (x86)/MSBuild/12.0/Bin/MSBuild.exe"



##
# Build Targets
##

#
.PHONY: build build-Android build-Linux build-MacOSX build-Windows

#
build: build-$(PLATFORM)

#
build-Android:
	# Check that ANDROID_NDK_ROOT is specified
    ifndef ANDROID_NDK_ROOT
        $(error MUST SPECIFY ANDROID_NDK_ROOT path)
    endif
    ifndef ANDROID_SDK_ROOT
        $(error MUST SPECIFY ANDROID_SDK_ROOT path)
    endif
    ifndef APACHE_ANT_PATH
        $(error MUST SPECIFY APACHE_ANT_PATH path)
    endif

	#
	$(ANDROID_NDK_ROOT)/ndk-build
	$(ANDROID_SDK_ROOT)/tools/android update project -p . -t android-10 -s
	$(APACHE_ANT_PATH) debug

#
build-Linux:
	$(CXX11) -m32 -L$(BUILDDIR)/$(PLATFORM).ia32.static.debug $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).ia32.debug
	$(CXX11) -m32 -L$(BUILDDIR)/$(PLATFORM).ia32.static.release $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).ia32.release
	$(CXX11) -m64 -L$(BUILDDIR)/$(PLATFORM).x64.static.debug $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).x64.debug
	$(CXX11) -m64 -L$(BUILDDIR)/$(PLATFORM).x64.static.release $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).x64.release

#
build-MacOSX:
	$(CXX11) -stdlib=libstdc++ -m32 -L$(BUILDDIR)/$(PLATFORM).ia32.static.debug $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).ia32.debug
	$(CXX11) -stdlib=libstdc++ -m32 -L$(BUILDDIR)/$(PLATFORM).ia32.static.release $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).ia32.release
	$(CXX11) -stdlib=libstdc++ -m64 -L$(BUILDDIR)/$(PLATFORM).x64.static.debug $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).x64.debug
	$(CXX11) -stdlib=libstdc++ -m64 -L$(BUILDDIR)/$(PLATFORM).x64.static.release $(TESTFILES) $(V8LIBS) -o helloworld.$(PLATFORM).x64.release

#
build-Windows:
	$(MSBUILD) /t:Build /p:Configuration=Debug /p:Platform=x64 helloworld.sln
	$(MSBUILD) /t:Build /p:Configuration=Debug /p:Platform=Win32 helloworld.sln
	$(MSBUILD) /t:Build /p:Configuration=Release /p:Platform=x64 helloworld.sln
	$(MSBUILD) /t:Build /p:Configuration=Release /p:Platform=Win32 helloworld.sln



#
.PHONY: run run-Android run-Linux run-MacOSX run-Windows

#
run: run-$(PLATFORM)

#
run-Android:
	$(ADB) install -r bin/HelloWorld-debug.apk
	$(ADB) shell am start -n com.NativeJS.jslibV8Engine/.HelloWorld
	#$(ADB) logcat -s *:E helloworld:*

#
run-Linux:
	./helloworld.$(PLATFORM).ia32.debug
	./helloworld.$(PLATFORM).ia32.release
	./helloworld.$(PLATFORM).x64.debug
	./helloworld.$(PLATFORM).x64.release

#
run-MacOSX:
	./helloworld.$(PLATFORM).ia32.debug
	./helloworld.$(PLATFORM).ia32.release
	./helloworld.$(PLATFORM).x64.debug
	./helloworld.$(PLATFORM).x64.release

#
run-Windows:
	./x64/Debug/helloworld.exe
	./x64/Release/helloworld.exe
	./Win32/Debug/helloworld.exe
	./Win32/Release/helloworld.exe



#
.PHONY: clean clean-Android clean-Linux clean-MacOSX clean-Windows

#
clean: clean-$(PLATFORM)

#
clean-Android:
	$(ANDROID_NDK_ROOT)/ndk-build clean
	$(APACHE_ANT_PATH) clean

#
clean-Linux:
	rm -f ./helloworld.$(PLATFORM).ia32.debug
	rm -f ./helloworld.$(PLATFORM).ia32.release
	rm -f ./helloworld.$(PLATFORM).x64.debug
	rm -f ./helloworld.$(PLATFORM).x64.release

#
clean-MacOSX:
	rm -f ./helloworld.$(PLATFORM).ia32.debug
	rm -f ./helloworld.$(PLATFORM).ia32.release
	rm -f ./helloworld.$(PLATFORM).x64.debug
	rm -f ./helloworld.$(PLATFORM).x64.release

#
clean-Windows:
	$(MSBUILD) /t:Clean /p:Configuration=Debug /p:Platform=x64 helloworld.sln
	$(MSBUILD) /t:Clean /p:Configuration=Debug /p:Platform=Win32 helloworld.sln
	$(MSBUILD) /t:Clean /p:Configuration=Release /p:Platform=x64 helloworld.sln
	$(MSBUILD) /t:Clean /p:Configuration=Release /p:Platform=Win32 helloworld.sln