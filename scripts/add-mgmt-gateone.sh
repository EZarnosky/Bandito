#!/bin/sh
#---> GateOne
apt-get install python-setuptools python-pam python-tornado python-pip python-pyopenssl python-kerberos build-essential -y
apt-get purge python-tornado -y
pip install tornado pyopenssl

git clone $Git_GateOne.git /opt/GateOne

#--> Initiates the GateOne install
cd /opt/gateone
python setup.py install

#--> Start GateOne so that configs are generated
/etc/init.d/gateone start

#--> Setup links in to the Bandito Box folders
mkdir $Ban_Conf/gateone
ln -s /etc/gateone/conf.d/10server.conf $Ban_Conf/GateOne/server.conf
ln -s /etc/gateone/conf.d/20authentication.conf $Ban_Conf/GateOne/authentication.conf
ln -s /etc/gateone/conf.d/50terminal.conf $Ban_Conf/GateOne/terminal.conf
ln -s /var/log/gateone/gateone.log $Ban_Logs/GateOne.log

#--> Backup GateOne's original configs
mkdir $Ban_Backup/gateone
cp /etc/gateone/conf.d/10server.conf $Ban_Backup/GateOne/10server.conf-backup
cp /etc/gateone/conf.d/20authentication.conf $Ban_Backup/GateOne/20authentication.conf-backup

#--> Adds your host IP and designated port number to the server config file
sed -i 's/"address": "",/"address": "'$Ban_HostIP'",/g' /etc/gateone/conf.d/10server.conf
sed -i 's/"port": 443,/"port": $Ban_Port_GateOne,/g' /etc/gateone/conf.d/10server.conf

#edit file /etc/gateone/conf.d/20authentication.conf
sed -i 's/"auth": "none",/"auth": "pam",/g' /etc/gateone/conf.d/20authentication.conf

#-> update-rc.d gateone defaults - does not work, below does the setuo manually
ln -s /etc/init.d/gateone /etc/rc0.d/K01gateone
ln -s /etc/init.d/gateone /etc/rc1.d/K01gateone
ln -s /etc/init.d/gateone /etc/rc2.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc3.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc4.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc5.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc6.d/K01gateone

#--> Installation complete restart GateOne to load the new configuration
/etc/init.d/gateone restart
