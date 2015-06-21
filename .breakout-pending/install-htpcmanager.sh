#--------> HTPC Manager
#----> Clone Git Repository
git clone https://github.com/Hellowlol/HTPC-Manager /opt/HTPCManager

#----> Install dependencies
apt-get update && apt-get upgrade -y && install python-setuptools python-cherrypy vnstat smartmontools -y && pip install psutil && apt-get autoremove -y
pip install psutil

#----> Import and apply configuration changes
# None needed

#----> Configure for autostart on boot
cp /opt/HTPCManager/initd /etc/init.d/htpcmanager && sed -i 's#APP_PATH=/opt/HTPCManager#APP_PATH=/path/to/htpc-manager#g' /etc/init.d/htpcmanager && chmod +x /etc/init.d/htpcmanager

#--> Load service information
update-rc.d htpcmanager defaults

#----> Start service
service htpcmanager restart
