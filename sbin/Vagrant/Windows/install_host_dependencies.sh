#!/bin/bash


# Setup path to only look at vagrant
PATH=/cygwin/c/HashiCorp/Vagrant/bin:/cygwin/c/HashiCorp/Vagrant/embedded/bin


# Install winnfsd plugin
bash vagrant plugin install vagrant-winnfsd


# Update winnfsd.exe file with patched version to fix permission related issues
pushd /cygwin/c/HashiCorp/Vagrant/embedded/gems/gems/vagrant-winnfsd-*/bin
if [ ! -e winnfsd.backup.exe ]; then
	mv winnfsd.exe winnfsd.backup.exe
	curl https://bitbucket.org/yannschepens/winnfsd-new/downloads/WinNFSd%20-%20for%20tests.exe > winnfsd.exe
else
	echo "winnfsd backup file already exists!" >&2
	exit 1
fi