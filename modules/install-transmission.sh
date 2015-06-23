#--------> Tranmission Installation
#---->  Create user account for service
useradd --system --user-group --no-create-home bandito-torrent

#----> Create folders for app
#--> Data directory
mkdir -p /bandito-box/.data/Transmission

#--> torrent data directories
mkdir -p /bandito-box/.data/USB/download/torrent/.blocklists
mkdir -p /bandito-box/.data/USB/download/torrent/.resume
mkdir -p /bandito-box/.data/USB/download/torrent/.torrents
mkdir -p /bandito-box/.data/USB/download/torrent/.watch
mkdir -p /bandito-box/.data/USB/download/torrent/complete
mkdir -p /bandito-box/.data/USB/download/torrent/incomplete

#----> Install package
#apt-get update && apt-get install transmission-daemon transmission-cli -y && apt-get autoremove -y
apt-get update && apt-get install transmission-daemon -y && apt-get autoremove -y

#----> Import and apply configuration changes
#--> Backup old init.d and defaults files
mkdir -p /bandito-box/.backup/Transmission-Daemon/default && mv /etc/default/transmission-daemon /bandito-box/.backup/Transmission-Daemon/transmission-daemon
mkdir -p /bandito-box/.backup/Transmission-Daemon/init.d && mv /etc/init.d/transmission-daemon /bandito-box/.backup/Transmission-Daemon/init.d/transmission-daemon && chmod -x /bandito-box/.backup/Transmission-Daemon/init.d/transmission-daemon

#--> Copy new init.d and defaults files
touch /bandito-box/logs/Transmission-Daemon.log
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/default/transmission-daemon > /etc/default/transmission-daemon
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/init.d/transmission-daemon > /etc/init.d/transmission-daemon && chmod +x /etc/init.d/transmission-daemon

#----> Load conf file for Nginx reverse proxy
cp /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/service-transmission.conf /etc/nginx/conf.d/service-transmission.conf

#----> Add host entry for site in /etc/hosts
echo "127.0.0.1       transmission.local" >> /etc/hosts

#----> Load service information
update-rc.d transmission-daemon defaults

#----> Apply rights and ownership
chown bandito-torrent:bandito-torrent /bandito-box/logs/Transmission-Daemon.log
chown -R bandito-torrent:bandito-torrent /bandito-box/.data/Transmission
chown -R bandito-torrent:bandito-torrent /bandito-box/.data/USB/download/torrent

#----> Link conf file to /bandito-box/.conf
ln -s /bandito-box/.data/Transmission/settings.json /bandito-box/.conf/Transmission.conf

#----> Start service
service transmission-daemon start


#https://trac.transmissionbt.com/wiki/Scripts/initd
#https://bobhood.wordpress.com/2013/07/28/raspberry-pi-creating-a-secure-torrent-client/
