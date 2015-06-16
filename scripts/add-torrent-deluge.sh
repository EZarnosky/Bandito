#!/bin/sh
#---> Install Deluge and web client
apt-get install deluged deluge-web -y

#-> Creat the deluge log files
touch /var/log/deluged.log
ln -s /var/log/deluged.log $Ban_Logs/deluged.log

touch /var/log/deluge-web.log
ln -s /var/log/deluge-web.log $Ban_Logs/deluge-web.log

chown $Bandito_User:$Bandito_Group $Ban_Logs/deluge*


