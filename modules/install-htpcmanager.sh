#--------> HTPC Manager
#----> Clone Git Repository
git clone https://github.com/Hellowlol/HTPC-Manager /bandito-box/apps/HTPCManager

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install build-essential git python-imaging python-dev python-setuptools python-pip python-cherrypy vnstat smartmontools -y && apt-get autoremove -y
pip install psutil

#----> Configure for autostart on boot
cp /bandito-box/apps/HTPCManager/initd /etc/init.d/htpcmanager && sed -i 's#APP_PATH=/path/to/htpc-manager#APP_PATH=/bandito-box/apps/HTPCManager#g' /etc/init.d/htpcmanager && chmod +x /etc/init.d/htpcmanager

#----> Import and apply configuration changes
sed -i 's#PID_FILE=/var/run/htpcmanager.pid#PID_FILE=/bandito-box/.pids/HTPCManager.pid#g' /etc/init.d/htpcmanager
#more options https://github.com/Hellowlol/HTPC-Manager/blob/master2/Htpc.py

#--> Load service information
update-rc.d htpcmanager defaults

#----> Start service
service htpcmanager restart
