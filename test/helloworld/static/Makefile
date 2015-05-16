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

#
MSBUILD = "/cygdrive/c/Program Files (x86)/MSBuild/12.0/Bin/MSBuild.exe"
CXX11 = g++ -std=c++11
INCLUDEDIR = ../../../include
BUILDDIR = ../../../build



##
# Build Targets
##

#
.PHONY: build build-Android build-Linux build-MacOSX build-Windows

#
build: build-$(PLATFORM)

#
build-Linux:
	$(CXX11) -m32 -I$(INCLUDEDIR) $(BUILDDIR)/$(PLATFORM).ia32.static.debug/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).ia32.debug
	$(CXX11) -m32 -I$(INCLUDEDIR) $(BUILDDIR)/$(PLATFORM).ia32.static.debug/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).ia32.debug
	$(CXX11) -m64 -I$(INCLUDEDIR) $(BUILDDIR)/$(PLATFORM).x64.static.debug/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).x64.debug
	$(CXX11) -m64 -I$(INCLUDEDIR)  $(BUILDDIR)/$(PLATFORM).x64.static.debug/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).x64.debug

#
build-MacOSX:
	$(CXX11) -stdlib=libstdc++ -m32 -I$(INCLUDEDIR) $(BUILDDIR)/$(PLATFORM).ia32.static.debug/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).ia32.debug
	$(CXX11) -stdlib=libstdc++ -m32 -I$(INCLUDEDIR) $(BUILDDIR)/$(PLATFORM).ia32.static.release/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).ia32.release
	$(CXX11) -stdlib=libstdc++ -m64 -I$(INCLUDEDIR) $(BUILDDIR)/$(PLATFORM).x64.static.debug/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).x64.debug
	$(CXX11) -stdlib=libstdc++ -m64 -I$(INCLUDEDIR) $(BUILDDIR)/$(PLATFORM).x64.static.release/*.a ../helloworld.cpp -o helloworld.$(PLATFORM).x64.release

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