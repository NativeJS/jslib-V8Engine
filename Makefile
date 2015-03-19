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
        PLATFORM=Win64
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

# Function to check if a git url has already been cloned, if not it will clone it
define gitClone
	test -d $2 || git clone $1 $2
endef

# Function to check if a git remote already exists in repo, if not add it
define gitAddRemote
	git remote -v | grep -q "^$1" || git remote add $1 $2
endef

#
BUILDDIR = ./build/$(PLATFORM)
HEADERDIR = ./include
DEPSDIR = ./deps
TESTDIR = ./test
TESTENTRYPOINT = $(TESTDIR)/entrypoints/$(PLATFORM)

# Get code from "chromium.googlesource.com". It's faster (and more reliable) than GitHub.com
V8REPO = "$(DEPSDIR)/v8"
V8REPOURL = "https://chromium.googlesource.com/external/v8.git"

# Unfortunately the googlesource url doesn't have tags, so we get tags from the github mirror
V8TAGURL = "https://github.com/v8/v8-git-mirror"
V8VERSION = "3.30.37"



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
.PHONY: build build-libs build-headers compress decompress deps deps-repo

define helpBuild
  build           Build V8 Engine library files and create archive
  decompress      Decompress build archive
endef
export helpBuild

#
build: build-libs compress

#
build-libs:
	$(MAKE) -f Makefile.$(PLATFORM) build

#
compress:
	cd $(BUILDDIR) && tar -cz $$(find . | egrep '.(a|lib|so|dll)') | split -b 50m - ./$(PLATFORM)_archive.tgz_

#
decompress:
	cd $(BUILDDIR) && cat ./$(PLATFORM)_archive.tgz_* | tar xz

#
build-headers:
	cp -r $(V8REPO)/include/ ./include/

#
deps:
	$(MAKE) -f Makefile.$(PLATFORM) deps

#
deps-repo:
	# Get V8Engine via git
	$(call gitClone,$(V8REPOURL),$(V8REPO))
	cd $(V8REPO) && $(call gitAddRemote,github,$(V8TAGURL))
	cd $(V8REPO) && git fetch --tags github
	cd $(V8REPO) && git checkout $(V8VERSION)



##
# Test Targets
##

#
.PHONY: test test-compile test-execute

define helpTest
  test            Compile and run test application
endef
export helpTest

GXX = g++ -std=c++11 -stdlib=libstdc++
V8_LIBS = $(BUILDDIR)/v8_*.a $(BUILDDIR)/icu*.a

#
test: test-compile test-execute

#
# TODO: make runTests.cpp and entrypoint seperate targets so that make caching works
test-compile:
	$(GXX) -I $(HEADERDIR) $(V8_LIBS) $(TESTENTRYPOINT)/entrypoint.* $(TESTDIR)/runTests.cpp -o $(TESTENTRYPOINT)/test

#
test-execute:
	$(TESTENTRYPOINT)/test



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
	rm -rf $(BUILDDIR)

#
clean-deps:
	rm -rf $(DEPSDIR)/*

#
clean-all: clean clean-deps