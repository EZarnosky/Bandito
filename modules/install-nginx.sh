#--------> Nginx
#----> Create folders for app
mkdir -p /bandito-box/.data/Nginx
mkdir -p /bandito-box/.conf/Nginx/services/

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install nginx apache2-utils -y && apt-get autoremove -y

#----> Create web password
touch /etc/nginx/.htpasswd && htpasswd -b /bandito-box/.conf/Nginx/htpasswd bandito bandito1

#----> Generate self signed SSL cert if none present
openssl genrsa -out /bandito-box/.conf/ssl/domain.tld.key 1024
openssl req -new -key /bandito-box/.conf/ssl/domain.tld.key -out /bandito-box/.conf/ssl/domain.tld.csr -subj '/C=US/OU=Private Party/CN=domain.tld'
openssl x509 -req -days 365 -in /bandito-box/.conf/ssl/domain.tld.csr -signkey /bandito-box/.conf/ssl/domain.tld.key -out /bandito-box/.conf/ssl/domain.tld.crt
cat /bandito-box/.conf/ssl/domain.tld.key /bandito-box/.conf/ssl/domain.tld.crt > /bandito-box/.conf/ssl/domain.tld.pem

#----> Backup the self signed SSL Certs
mkdir -p /bandito-box/.backup/ssl
cp /bandito-box/.conf/ssl/* /bandito-box/.backup/ssl

#----> Copy Nginx conf files to /etc/nginx/conf.d folder

tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/auth-basic.conf > /bandito-box/.conf/Nginx/auth-basic.conf
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/proxy-control.conf > /bandito-box/.conf/Nginx/proxy-control.conf
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/ssl.conf > /bandito-box/.conf/Nginx/ssl.conf
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/site-available.conf > /bandito-box/.conf/Nginx/site-available.conf

ln -s /bandito-box/.conf/Nginx/site-available.conf /etc/nginx/conf.d/site-available.conf

#----> Link files to Bandito Box
ln -s /var/log/nginx/access.log /bandito-box/logs/Nginx-Access.log
ln -s /var/log/nginx/error.log /bandito-box/logs/Nginx-Error.log
ln -s /usr/share/nginx/www /bandito-box/.data/Nginx/www
ln -s /etc/nginx/.htpasswd /bandito-box/.conf/Nginx/htpassword

# Each app install the their own /bandito-box/.conf/Nginx/services/service-*.conf and

#----> Unlink default installed site
unlink /etc/nginx/sites-enabled/default

#----> Start service
service nginx restart
