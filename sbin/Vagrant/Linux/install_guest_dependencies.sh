#!/bin/bash


# Install required packages
if which apt-get >/dev/null 2>&1; then
	sudo apt-get install -y git g++-multilib
else
	echo "Could not find supported package manager" >&2
	exit 1;
fi


# Install Android NDK
if [ ! -d "/opt/android-ndk-r10d" ]; then
	pushd /opt
	sudo wget http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin;
	sudo chmod +x android-ndk-r10d-linux-x86_64.bin;
	sudo ./android-ndk-r10d-linux-x86_64.bin;
	popd
fi;