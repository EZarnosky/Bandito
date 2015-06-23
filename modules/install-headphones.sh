#--------> Headphones Installation
#----> Create user account for service
useradd --system --user-group --no-create-home bandito-music

#----> Create folders for app
mkdir -p /bandito-box/.data/Headphones

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install git-core python -y && apt-get autoremove -y

#----> Clone Git Repository
git clone https://github.com/rembo10/headphones /bandito-box/apps/Headphones

#----> Import and apply configuration changes
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/default/headphones > /etc/default/headphones

#----> Apply rights and ownership
chown -R bandito-music:bandito-music /bandito-box/apps/Headphones
chown -R bandito-music:bandito-music /bandito-box/.data/Headphones
touch /bandito-box/.conf/Headphones.conf && chown -R bandito-music:bandito-music /bandito-box/.conf/Headphones.conf

#----> Configure for autostart on boot
cp /bandito-box/apps/Headphones/init-scripts/init.ubuntu /etc/init.d/headphones && chmod +x /etc/init.d/headphones

#--> Load service information
update-rc.d headphones defaults

#----> Configure the conf settings
service headphones start && service headphones stop
#edit the /bandito-box/.conf/Headphones.conf with sed commands

#----> Start service
service headphones start
