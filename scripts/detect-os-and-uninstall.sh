#!/bin/bash

detect=$(cat /etc/*-release | grep 'ID=')
if [[ $detect == *"debian"* ]]; then
  export DEBIAN_FRONTEND=noninteractive
	sudo apt-get --assume-yes remove clamav
elif [[ $detect == *"ubuntu"* ]]; then
  export DEBIAN_FRONTEND=noninteractive
	sudo apt-get --assume-yes remove clamav
elif [[ $detect == *"centos"* ]]; then
    sudo yum remove -y epel-release 
    sudo yum remove -y clamav
elif [[ $detect == *"almalinux"* ]]; then
    sudo yum remove -y clamav-freshclam
    sudo yum remove -y clamav
elif [[ $detect == *"alpine"* ]]; then
	sudo apk del clamav
fi
