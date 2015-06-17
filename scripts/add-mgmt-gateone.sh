#!/bin/sh
#---> GateOne
apt-get install python-setuptools python-pam python-tornado python-pip python-pyopenssl python-kerberos build-essential -y
apt-get purge python-tornado -y
pip install tornado pyopenssl

git clone $Git_GateOne.git /opt/gateone

cd /opt/gateone
python setup.py install

/etc/init.d/gateone start

ln -s /var/log/gateone/gateone.log $Ban_Logs/gateone.log

/etc/init.d/gateone stop

cp /etc/gateone/conf.d/10server.conf /etc/gateone/conf.d/10server.conf.original
Ban_HostIP=`hostname -I`
sed -i "s/"address": "",/"address": ""$Ban_HostIP"",/g" 10server.conf.text
#edit file /etc/gateone/conf.d/10server.conf
#replace "address": "", with "address": "$Ban_HostIP",

cp /etc/gateone/conf.d/20authentication.conf /etc/gateone/conf.d/20authentication.conf.original
#edit file /etc/gateone/conf.d/20authentication.conf
#replace "auth": "none", with "auth": "pam",

#-> update-rc.d gateone defaults - does not work, below does the setuo manually
ln -s /etc/init.d/gateone /etc/rc0.d/K01gateone
ln -s /etc/init.d/gateone /etc/rc1.d/K01gateone
ln -s /etc/init.d/gateone /etc/rc2.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc3.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc4.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc5.d/S20gateone
ln -s /etc/init.d/gateone /etc/rc6.d/K01gateone


/etc/init.d/gateone restart




#http://www.disk91.com/2014/technology/systems/install-gateone-an-html5-ssh-client/
#http://madnerd.org/Connect_to_ssh_from_a_webbrowser
#http://bluephonebox.com/2014/04/05/setting-up-web-ssh-on-a-raspberry-pi/
