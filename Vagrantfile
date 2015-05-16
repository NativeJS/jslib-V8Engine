# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Function to determine host OS
module OS
	def OS.windows?
		(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
	end

	def OS.mac?
		(/darwin/ =~ RUBY_PLATFORM) != nil
	end

	def OS.unix?
		!OS.windows?
	end

	def OS.linux?
		OS.unix? and not OS.mac?
	end
end

#
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	#
	config.vm.define "linux" do |linux|
		# Box name and URL
		linux.vm.box = "jslib-V8Engine - Debian 8.0"
		linux.vm.box_url = "https://github.com/holms/vagrant-jessie-box/releases/download/Jessie-v0.1/Debian-jessie-amd64-netboot.box"

		# Adjust RAM and CPU count
		linux.vm.provider "virtualbox" do |vb|
			vb.customize ["modifyvm", :id, "--cpus", "2"]
			vb.customize ["modifyvm", :id, "--memory", "4096"]
		end

		# Setup sync folder mounts
		linux.vm.synced_folder ".", "/vagrant", disabled: true
		if OS.windows? then
			linux.vm.synced_folder ".", "/vagrant", type: "smb"
		else
			linux.vm.synced_folder ".", "/vagrant", type: "nfs"
		end

		# Network configurations
		linux.vm.network "private_network", ip: "192.168.30.10"

		# Enable SSH agent forwarding
		linux.ssh.forward_agent = true
	end

	#
	config.vm.define "windows", autostart: false do |windows|
		# Box name and URL
		windows.vm.box = "jslib-V8Engine - Windows 7"
		windows.vm.box_url = "http://aka.ms/vagrant-win7-ie11"

		# Adjust RAM and CPU count
		windows.vm.provider "virtualbox" do |vb|
			vb.customize ["modifyvm", :id, "--cpus", "2"]
			vb.customize ["modifyvm", :id, "--memory", "4096"]
		end

		# Setup sync folder mounts
		windows.vm.synced_folder ".", "/vagrant", disabled: true
		if OS.windows? then
			windows.vm.synced_folder ".", "/vagrant", type: "smb"
		else
			windows.vm.synced_folder ".", "/vagrant", type: "nfs"
		end

		# Network configurations
		windows.vm.network "private_network", ip: "192.168.30.11"

		# Enable SSH agent forwarding
		windows.ssh.forward_agent = true
	end

end