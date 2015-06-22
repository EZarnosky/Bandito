#--------> Nginx
#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install nginx -y && apt-get autoremove -y

#----> Start service
service nginx restart
