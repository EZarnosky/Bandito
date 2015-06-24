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
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/default/couchpotato > /etc/default/couchpotato

#----> Load conf file for Nginx reverse proxy
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/service-couchpotato.conf > /bandito-box/.conf/Nginx/services/service-couchpotato.conf

#----> Add host entry for site in /etc/hosts
echo "127.0.0.1       couchpotato.local" >> /etc/hosts

#----> Apply rights and ownership
chown -R bandito-movies:bandito-movies /bandito-box/apps/CouchPotato
chown -R bandito-movies:bandito-movies /bandito-box/.data/CouchPotato
touch /bandito-box/.conf/CouchPotato.conf && chown -R bandito-movies:bandito-movies /bandito-box/.conf/CouchPotato.conf

#----> Configure for autostart on boot
cp /bandito-box/apps/CouchPotato/init/ubuntu /etc/init.d/couchpotato && chmod +x /etc/init.d/couchpotato

#--> Load service information
update-rc.d couchpotato defaults

#----> Configure the conf settings
#--> Start the serice to generate a conf file, then stop to edit settings
service couchpotato start && service couchpotato stop

#--> edit the /bandito-box/.conf/CouchPotato.conf with sed commands
sed -i 's#username = ""#username = bandito#g' /bandito-box/.conf/CouchPotato.conf
sed -i 's#password = ""#password = 004f9914349662faf220a5a5efeed57f#g' /bandito-box/.conf/CouchPotato.conf   #bandito1
sed -i 's#url_base = /#url_base = /movies#g' /bandito-box/.conf/CouchPotato.conf
sed -i 's#ssl_key =#ssl_key =#g' /bandito-box/.conf/CouchPotato.conf
sed -i 's#ssl_cert =#ssl_cert =#g' /bandito-box/.conf/CouchPotato.conf
sed -i 's#data_dir =#data_dir = /bandito-box/.data/CouchPotato#g' /bandito-box/.conf/CouchPotato.conf

#----> Start service
service couchpotato start
