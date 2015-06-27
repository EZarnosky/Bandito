#!/bin/sh
#--------> NZBGet
# Create user account for service
useradd --system --user-group --no-create-home bandito-nzb

# Create folders for app
mkdir -p /bandito-box/.data/NZBGet

#----> Install dependencies
#--> Add the repo
gpg --recv-keys --keyserver keyserver.ubuntu.com 0E50BF67 && gpg -a --export 0E50BF67 | apt-key add -
echo "deb http://packages.unusedbytes.ca wheezy main" > /etc/apt/sources.list.d/nzbget.list

#--> Install application
apt-get update && apt-get install nzbget -y && apt-get autoremove -y

#--> install VideoSort
mkdir /bandito-box/.packages/VideoSort && cd /bandito-box/.packages/VideoSort
wget http://sourceforge.net/projects/nzbget/files/ppscripts/videosort/videosort-ppscript-5.0.zip
mkdir /bandito-box/.data/NZBGet/scripts && cd /bandito-box/.data/NZBGet/scripts
unzip /bandito-box/.packages/VideoSort/videosort*.zip

#----> Import and apply configuration changes
cp /usr/share/nzbget/nzbget.conf /bandito-box/.conf/NZBGet.conf && chown bandito-nzb:bandito-nzb /bandito-box/.conf/NZBGet.conf

#----> Load conf file for Nginx reverse proxy
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/services/service-nzbget.conf > /bandito-box/.conf/Nginx/services/service-nzbget.conf
             
#----> Add host entry for site in /etc/hosts
echo "127.0.0.1       nzbget.local" >> /etc/hosts

#----> Apply rights and ownership
touch /bandito-box/.pids/NZBGet.pid && chown bandito-nzb:bandito-nzb /bandito-box/.pids/NZBGet.pid
touch /bandito-box/logs/nzbget.log && chown bandito-nzb:bandito-nzb /bandito-box/logs/nzbget.log


#----> Configure for autostart on boot
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/init.d/nzbget > /etc/init.d/nzbget && chmod +x /etc/init.d/nzbget

#--> Load service information
update-rc.d nzbget defaults

#----> Configure the conf settings
sed -i "s#MainDir=~/downloads#MainDir=~/downloads#g" /bandito-box/.conf/NZBGet.conf
sed -i 's#ScriptDir=${MainDir}/ppscripts#ScriptDir=/bandito-box/.data/NZBGet/scripts#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#ControlUsername=nzbget#ControlUsername=bandito#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#ControlPassword=tegbzn6789#ControlPassword=bandito1#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#DaemonUsername=root#DaemonUsername=bandito-nzb#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#ControlPort=6789#ControlPort=6789#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#SecureControl=no#SecureControl=no#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#SecurePort=6791#SecurePort=6791#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#SecureCert=#SecureCert=#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#SecureKey=#SecureKey=#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#LockFile=${MainDir}/nzbget.lock#LockFile=/bandito-box/.pids/NZBGet.pid#g' /bandito-box/.conf/NZBGet.conf
sed -i 's#LogFile=${DestDir}/nzbget.log#LogFile=/bandito-box/logs/nzbget.log#g' /bandito-box/.conf/NZBGet.conf

#----> Start service
service nzbget start && service nginx restart