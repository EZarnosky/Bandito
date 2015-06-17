#!/bin/sh
#---> GateOne
apt-get install python-setuptools python-pam -y
git clone $Git_GateOne /opt/gateone

cd /opt/gateone
python setup.py install

Ban_HostIP=hostname -I
#edit file /etc/gateone/conf.d/10server.conf
#replace "address": "", with "address": "$Ban_HostIP",

#edit file /etc/gateone/conf.d/20authentication.conf
#replace "auth": "none", with "auth": "pam",

update-rc.d gateone defaults

/etc/init.d/gateone restart




#http://www.disk91.com/2014/technology/systems/install-gateone-an-html5-ssh-client/
#http://madnerd.org/Connect_to_ssh_from_a_webbrowser
#http://bluephonebox.com/2014/04/05/setting-up-web-ssh-on-a-raspberry-pi/

