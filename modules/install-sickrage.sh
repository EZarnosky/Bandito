#!/bin/sh
#--------> SickRage Installation
# Create user account for service
useradd --system --user-group --no-create-home bandito-tv

# Create folders for app
mkdir -p /bandito-box/.data/SickRage

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install python-cheetah python-pip python-dev git-core libssl-dev -y && pip install pyopenssl==0.13.1 && apt-get autoremove -y

#----> Clone Git Repository
git clone https://github.com/SiCKRAGETV/SickRage /bandito-box/apps/SickRage

#--> Install UnRAR
mkdir -p /bandito-box/.packages/unRAR/ && cd /bandito-box/.packages/unRAR/ && wget http://sourceforge.net/projects/bananapi/files/unrar_5.2.6-1.arm6_armhf.deb && dpkg -i unrar*.deb

#----> Import and apply configuration changes
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/default/sickrage > /etc/default/sickrage

#----> Load conf file for Nginx reverse proxy
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/services/service-sickrage.conf > /bandito-box/.conf/Nginx/services/service-sickrage.conf

#----> Add host entry for site in /etc/hosts
echo "127.0.0.1       sickrage.local" >> /etc/hosts

#----> Apply rights and ownership
chown -R bandito-tv:bandito-tv /bandito-box/apps/SickRage
chown -R bandito-tv:bandito-tv /bandito-box/.data/SickRage
touch /bandito-box/.conf/SickRage.conf && chown -R bandito-tv:bandito-tv /bandito-box/.conf/SickRage.conf

#----> Configure for autostart on boot
cp /bandito-box/apps/SickRage/runscripts/init.ubuntu /etc/init.d/sickrage && chmod +x /etc/init.d/sickrage

#--> Load service information
update-rc.d sickrage defaults

#----> Configure the conf settings
#--> Start the serice to generate a conf file, then stop to edit settings
service sickrage start && service sickrage stop

#--> edit the /bandito-box/.conf/CouchPotato.conf with sed commands
sed -i 's#web_username =#web_username = bandito#g' /bandito-box/.conf/SickRage.conf
sed -i 's#password = ""#web_password = bandito1#g' /bandito-box/.conf/SickRage.conf   #bandito1
sed -i 's#web_root = /#web_root = /tv#g' /bandito-box/.conf/SickRage.conf
sed -i 's#https_key = server.key#https_key = server.key#g' /bandito-box/.conf/SickRage.conf
sed -i 's#https_cert = server.crt#https_cert = server.crt#g' /bandito-box/.conf/SickRage.conf
sed -i 's#log_dir = Logs#log_dir = /bandito-box/logs#g' /bandito-box/.conf/SickRage.conf

#----> Start service
service sickrage start
