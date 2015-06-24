#!/bin/sh
#--------> NZBGet
#----> Clone Git Repository


#----> Install dependencies
#--> Add the repo
gpg --recv-keys --keyserver keyserver.ubuntu.com 0E50BF67 && gpg -a --export 0E50BF67 | apt-key add -
echo "deb http://packages.unusedbytes.ca wheezy main" > /etc/apt/sources.list.d/nzbget.list

#--> Install application
apt-get update && apt-get install nzbget -y && apt-get autoremove -y

#----> Import and apply configuration changes


#----> Configure for autostart on boot


#--> Load service information



#----> Start service
service nzbget restart