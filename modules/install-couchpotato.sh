#--------> CouchPotato Installation
# Create user account for service
useradd --system --user-group --no-create-home bandito-movies

# Create folders for app
mkdir -p /bandito-box/.data/CouchPotato

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install git-core python -y && apt-get autoremove -y

#----> Clone Git Repository
git clone https://github.com/RuudBurger/CouchPotatoServer /bandito-box/apps/CouchPotato

#----> Import and apply configuration changes
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc_default_couchpotato > /etc/default/couchpotato

#----> Apply rights and ownership
chown -R bandito-movies:bandito-movies /bandito-box/apps/CouchPotato
touch /bandito-box/.conf/CouchPotato.conf && chown -R bandito-movies:bandito-movies /bandito-box/.conf/CouchPotato.conf

#----> Configure for autostart on boot
cp /bandito-box/apps/CouchPotato/init/ubuntu /etc/init.d/couchpotato && chmod +x /etc/init.d/couchpotato

#--> Load service information
update-rc.d couchpotato defaults

#----> Configure the conf settings
service couchpotato start && couchpotato sickrage stop
#edit the /bandito-box/.conf/CouchPotato.conf with sed commands

#----> Start service
service couchpotato restart
