#--------> SickRage Installation
# Create user account for service
useradd --system --user-group --no-create-home bandito-tv

# Create folders for app
mkdir -p /bandito-box/.data/SickRage

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install python-cheetah python-pip python-dev git-core libssl-dev -y && pip install pyopenssl==0.13.1 && apt-get autoremove -y

#----> Clone Git Repository
git clone https://github.com/SiCKRAGETV/SickRage /bandito-box/apps/SickRage

#--> Install UnRAR
mkdir -p /bandito-box/.packages/unRAR/ && cd /bandito-box/.packages/unRAR/ && wget http://sourceforge.net/projects/bananapi/files/unrar_5.2.6-1.arm6_armhf.deb && dpkg -i unrar*.deb

#----> Import and apply configuration changes
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc_default_sickrage > /etc/default/sickrage

#----> Apply rights and ownership
chown -R bandito-tv:bandito-tv /bandito-box/apps/CouchPotato
touch /bandito-box/.conf/SickRage.conf && chown -R bandito-tv:bandito-tv /bandito-box/.conf/SickRage.conf

#----> Configure for autostart on boot
cp /bandito-box/apps/SickRage/runscripts/init.ubuntu /etc/init.d/sickrage && chmod +x /etc/init.d/sickrage

#--> Load service information
update-rc.d sickrage defaults

#----> Configure the conf settings
service sickrage start && service sickrage stop
#edit the /bandito-box/.conf/SickRage.conf with sed commands

#----> Start service
service sickrage restart
