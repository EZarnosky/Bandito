#--------> HTPC Manager
#----> Create user account for service
useradd --system --user-group --no-create-home bandito-htpcmgr

#----> Create folders for app
mkdir -p /bandito-box/.data/HTPCManager

#----> Install dependencies
#--> Install all other dependencies from wheezy repo
apt-get upgrade -y && apt-get install build-essential git python-imaging python-dev python-setuptools python-pip vnstat -y && apt-get autoremove -y
pip install psutil

#----> Clone Git Repository
git clone https://github.com/Hellowlol/HTPC-Manager /bandito-box/apps/HTPCManager

#----> Import and apply configuration changes
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/default/htpcmanager > /etc/default/htpcmanager
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/init.d/htpcmanager > /etc/init.d/htpcmanager && chmod +x /etc/init.d/htpcmanager

#----> Load conf file for Nginx reverse proxy
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/services/service-htpcmanager.conf > /bandito-box/.conf/Nginx/services/service-htpcmanager.conf

#----> Add host entry for site in /etc/hosts
echo "127.0.0.1       htpcmanager.local" >> /etc/hosts

#----> Apply rights and ownership
chown -R bandito-htpcmgr:bandito-htpcmgr /bandito-box/apps/HTPCManager
chown -R bandito-htpcmgr:bandito-htpcmgr /bandito-box/.data/HTPCManager

#----> Configure for autostart on boot
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/init.d/htpcmanager > /etc/init.d/htpcmanager && chmod +x /etc/init.d/htpcmanager

#--> Load service information
update-rc.d htpcmanager defaults

#----> Start service
service htpcmanager start && service nginx restart
