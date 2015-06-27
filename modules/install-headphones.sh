#!/bin/sh
#--------> Headphones Installation
#----> Create user account for service
useradd --system --user-group --no-create-home bandito-music

#----> Create folders for app
mkdir -p /bandito-box/.data/Headphones

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install git-core python -y && apt-get autoremove -y

#----> Clone Git Repository
git clone https://github.com/rembo10/headphones /bandito-box/apps/Headphones

#----> Import and apply configuration changes
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/default/headphones > /etc/default/headphones

#----> Load conf file for Nginx reverse proxy
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/services/service-headphones.conf > /bandito-box/.conf/Nginx/services/service-headphones.conf

#----> Add host entry for site in /etc/hosts
echo "127.0.0.1       headphones.local" >> /etc/hosts

#----> Apply rights and ownership
chown -R bandito-music:bandito-music /bandito-box/apps/Headphones
chown -R bandito-music:bandito-music /bandito-box/.data/Headphones
touch /bandito-box/.conf/Headphones.conf && chown -R bandito-music:bandito-music /bandito-box/.conf/Headphones.conf

#----> Configure for autostart on boot
cp /bandito-box/apps/Headphones/init-scripts/init.ubuntu /etc/init.d/headphones && chmod +x /etc/init.d/headphones

#--> Load service information
update-rc.d headphones defaults

#----> Configure the conf settings
#--> Start the serice to generate a conf file, then stop to edit settings
service headphones start && service headphones stop

#--> edit the /bandito-box/.conf/CouchPotato.conf with sed commands
#> Need to wait for service to fully shutdown and release conf file
sleep 2s

#> Begin edits
# Issues with user and password for reverse proxy - https://github.com/rembo10/headphones/issues/2077
#sed -i 's#http_username = ""#http_username = bandito#g' /bandito-box/.conf/Headphones.conf
#sed -i 's#http_password = ""#http_password = bandito1#g' /bandito-box/.conf/Headphones.conf
sed -i 's#http_root = /#http_root = /music#g' /bandito-box/.conf/Headphones.conf
sed -i 's#https_key = /bandito-box/apps/Headphones/server.key#https_key = /bandito-box/apps/Headphones/server.key#g' /bandito-box/.conf/Headphones.conf
sed -i 's#https_cert = /bandito-box/apps/Headphones/server.crt#https_cert = /bandito-box/apps/Headphones/server.crt#g' /bandito-box/.conf/Headphones.conf
sed -i 's#launch_browser = 1#launch_browser = 0#g' /bandito-box/.conf/Headphones.conf
sed -i 's#cache_dir = /bandito-box/apps/Headphones/cache#cache_dir = /bandito-box/.data/Headphones/cache#g' /bandito-box/.conf/Headphones.conf
sed -i 's#log_dir = /bandito-box/apps/Headphones/logs#log_dir = /bandito-box/logs#g' /bandito-box/.conf/Headphones.conf
sed -i 's#api_enabled = 0#api_enabled = 1#g' /bandito-box/.conf/Headphones.conf

#----> Start service
service headphones start && service nginx restart
