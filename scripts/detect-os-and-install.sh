#!/bin/bash

detect=$(cat /etc/*-release | grep 'ID=')
if [[ $detect == *"debian"* ]]; then
  export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get --assume-yes install clamav
	sed -i -e "s/^Example/#Example/" /etc/freshclam.conf
elif [[ $detect == *"ubuntu"* ]]; then
  export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get --assume-yes install clamav
	sed -i -e "s/^Example/#Example/" /etc/freshclam.conf
elif [[ $detect == *"centos"* ]]; then
   	yum install -y epel-release 
    	yum install -y clamav 
    	sed -i -e "s/^Example/#Example/" /etc/freshclam.conf
elif [[ $detect == *"almalinux"* ]]; then
   	yum install -y epel-release
    	yum install -y clamav clamav-freshclam
    	sed -i -e "s/^Example/#Example/" /etc/freshclam.conf
elif [[ $detect == *"alpine"* ]]; then
	apk add clamav
	apk add clamav-libunrar
	sed -i -e "s/^Example/#Example/" /etc/clamav/freshclam.conf
fi

#update the config file to use correct log-file
if [[ $detect == *"alpine"* ]]; then
	sed -i -e 's@^#UpdateLogFile /var/log/freshclam.log@UpdateLogFile /var/log/clamav/clamav.log@' /etc/clamav/freshclam.conf
	sed -i -e 's@^#LogFileMaxSize 2M@LogFileMaxSize 0@' /etc/clamav/freshclam.conf
else
	sed -i -e 's@^#UpdateLogFile /var/log/freshclam.log@UpdateLogFile /var/log/clamav/clamav.log@' /etc/freshclam.conf
	sed -i -e 's@^#LogFileMaxSize 2M@LogFileMaxSize 0@' /etc/freshclam.conf
fi

#add correct folders and set rights for quarantine and log
if [[ $detect == *"alpine"* ]]; then
	mkdir -p /var/log/clamav
	touch /var/log/clamav/clamav.log
	chgrp clamav /var/log/clamav/clamav.log
	chmod 0764 /var/log/clamav/clamav.log
	
	mkdir -p /opt/clamav_quarantined
	chown 700:700 /opt/clamav_quarantined
	chmod 0764 /opt/clamav_quarantined
else
	mkdir -p /var/log/clamav
	touch /var/log/clamav/clamav.log
	chgrp clamupdate /var/log/clamav/clamav.log
	chmod 0764 /var/log/clamav/clamav.log

	mkdir -p /opt/clamav_quarantined
	chown 700:700 /opt/clamav_quarantined
	chmod 0764 /opt/clamav_quarantined

	echo /opt/clamav_quarantined >> /etc/jelastic/redeploy.conf
fi

