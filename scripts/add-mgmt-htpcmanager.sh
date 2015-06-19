#!/bin/sh
#---> HTPC-Manager
@--> Install dependencies
apt-get install build-essential python-imaging python-setuptools python-pip python-cherrypy vnstat smartmontools -y
pip install psutil


git clone $Git_HTPCManager /opt/HTPCManager

python /opt/HTPCManager/Htpc.py --daemon

cp /opt/HTPCManager/initd /etc/init.d/htpcmanager


