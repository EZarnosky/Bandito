#--------> SSLH Installation
# Create folders for app
mkdir -p /bandito-box/.data/sslh

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install git-core libconfig tcp-wrappers -y && apt-get autoremove -y

#----> Clone Git Repository
git clone https://github.com/yrutschle/sslh /bandito-box/apps/sslh


#----> Import and apply configuration changes


#----> Start service
#service sslh restart

# Notes - https://fak3r.com/2013/08/13/howto-connect-to-ssh-via-ssl-with-sslh/