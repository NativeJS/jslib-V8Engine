##
# V8Engine makefile
# description     : Makefile to build V8Engine static/dynamic library files
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
ARCH ?= x64
LTYPE ?= static
BUILDDIR = ./build
DEPSDIR = ./deps

# Paths and URLs for V8 engine
# NOTE: Unfortunately the googlesource url doesn't have tags, so we get tags from the github mirror
# NOTE: To find latest stable version check what latest stable chrome is using here: http://omahaproxy.appspot.com
V8REPO = "$(DEPSDIR)/v8"
V8TAGURL = "https://github.com/v8/v8-git-mirror"
V8VERSION = "4.2.77.18"

# Paths and URL for depot_tools
DEPOTTOOLSURL = "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
DEPOTTOOLSREPO = $(shell cd $(DEPSDIR) && pwd)/depot_tools

# Function to check if a depot_tools pacakge has already been retrieved, if not fetch it
define depotFetch
	test -d $1 || PATH="$$PATH:$(DEPOTTOOLSREPO)" fetch $1
endef

# Function to sync up dependencies for packages listed in .gclient file
define depotGSync
	PATH="$$PATH:$(DEPOTTOOLSREPO)" gclient sync
endef

# Function to check if a git url has already been cloned, if not it will clone it
define gitClone
	test -d $2 || git clone $1 $2
endef

# Function to check if a git remote already exists in repo, if not add it
define gitAddRemote
	git remote -v | grep -q "^$1" || git remote add $1 $2
endef



##
# Main Targets
##

# List of target which should be run every time without caching
.PHONY: help

define helpMain
  help            Display this help menu
endef
export helpMain

# Default make target
%:: help
Default: help
help:
	@echo ""
	@echo "$$helpMain"
	@echo ""
	@echo "$$helpBuild"
	@echo ""
	@echo "$$helpTest"
	@echo ""
	@echo "$$helpClean"
	@echo ""



##
# Build Targets
##

#
.PHONY: build build-libs copy-headers compress decompress deps deps-repo

define helpBuild
  build           Build V8 Engine library files [defaults: ARCH=x64 LTYPE=static]
  build-all       Build V8 Engine library shared and static files for all archs
  compress        Compress build into split files
  decompress      Decompress build archive
endef
export helpBuild

#
build:
	$(MAKE) -f Makefile.$(PLATFORM) build ARCH=$(ARCH) LTYPE=$(LTYPE)

#
build-all:
	$(MAKE) -f Makefile.$(PLATFORM) build-all

#
compress:
	cd $(BUILDDIR) && \
	for platform in $$(ls -d $(PLATFORM).*); do \
		(cd $${platform}/debug && tar -cz $$(find . | egrep '.(a|lib|so|dll)') | split -b 50m - ./$${platform}_debug.tgz_); \
		(cd $${platform}/release && tar -cz $$(find . | egrep '.(a|lib|so|dll)') | split -b 50m - ./$${platform}_release.tgz_); \
	done

#
decompress:
	cd $(BUILDDIR) && \
    for platform in $$(ls -d $(PLATFORM).*); do \
    	(cd $${platform}/debug && cat ./$${platform}_debug.tgz_* | tar xz); \
    	(cd $${platform}/release && cat ./$${platform}_release.tgz_* | tar xz); \
    done

#
copy-headers:
	cp -r $(V8REPO)/include ./

#
deps:
	$(MAKE) -f Makefile.$(PLATFORM) deps

#
deps-repo:
	# Get depot_tools via git
	$(call gitClone,$(DEPOTTOOLSURL),"$(DEPOTTOOLSREPO)")

	# Get V8Engine via depot_tools fetch and checkout correct version
	cd $(DEPSDIR) && $(call depotFetch,v8)
	cd $(V8REPO) && $(call gitAddRemote,github,$(V8TAGURL))
	cd $(V8REPO) && git fetch --tags github
	cd $(V8REPO) && git checkout $(V8VERSION)
	cd $(DEPSDIR) && $(call depotGSync)



##
# Test Targets
##

#
.PHONY: test-helloworld

define helpTest
  test-helloworld Compile and run helloworld application
endef
export helpTest

#
test-helloworld:
	$(MAKE) -C ./test/helloworld/static build
	$(MAKE) -C ./test/helloworld/shared build
	$(MAKE) -C ./test/helloworld/static run
	$(MAKE) -C ./test/helloworld/shared run



##
# Clean Targets
##

#
.PHONY: clean clean-deps clean-all

define helpClean
  clean           Clean up build files and headers
  clean-deps      Clean up dependency files
  clean-all       Clean up all files (clean, clean-deps)
endef
export helpClean

#
clean:
	rm -rf $(BUILDDIR)/$(PLATFORM).*

#
clean-deps:
	rm -rf $(DEPSDIR)/*

#
clean-all: clean clean-deps