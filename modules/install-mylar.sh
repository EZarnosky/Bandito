#!/bin/sh
#--------> Mylar Installation
# Create user account for service
useradd --system --user-group --no-create-home bandito-comics

# Create folders for app
mkdir -p /bandito-box/.data/Mylar

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install git-core python -y && apt-get autoremove -y

#----> Clone Git Repository
git clone https://github.com/evilhero/mylar /bandito-box/apps/Mylar

#----> Import and apply configuration changes
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/default/mylar > /etc/default/mylar

#----> Load conf file for Nginx reverse proxy
cp /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/service-mylar.conf /etc/nginx/conf.d/service-mylar.conf

#----> Add host entry for site in /etc/hosts
echo "127.0.0.1       mylar.local" >> /etc/hosts

#----> Apply rights and ownership
chown -R bandito-comics:bandito-comics /bandito-box/apps/Mylar
chown -R bandito-comics:bandito-comics /bandito-box/.data/Mylar
touch /bandito-box/.conf/Mylar.conf && chown -R bandito-comics:bandito-comics /bandito-box/.conf/Mylar.conf

#----> Configure for autostart on boot
cp /bandito-box/apps/Mylar/init-scripts/ubuntu.init.d /etc/init.d/mylar && chmod +x /etc/init.d/mylar

#--> Load service information
update-rc.d mylar defaults

#### TODO Post Processing setup - http://www.htpcguides.com/install-mylar-raspberry-pi-usenet-torrent-comics/

#----> Configure the conf settings
service mylar start && service mylar stop
#edit the /bandito-box/.conf/Mylar.conf with sed commands

#----> Start service
service mylar restart
