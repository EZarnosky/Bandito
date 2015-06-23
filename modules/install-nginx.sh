#--------> Nginx
#----> Create folders for app
mkdir -p /bandito-box/.data/Nginx
mkdir -p /bandito-box/.conf/Nginx

#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install nginx apache2-utils -y && apt-get autoremove -y

#----> Create web password
htpasswd -b /etc/nginx/.htpasswd bandito bandito1

#----> Generate self signed SSL cert if none present
openssl genrsa -out /bandito-box/.conf/ssl/domain.tld.key 1024
openssl req -new -key /bandito-box/.conf/ssl/domain.tld.key -out /bandito-box/.conf/ssl/domain.tld.csr -subj '/C=US/OU=Private Party/CN=domain.tld'
openssl x509 -req -days 365 -in /bandito-box/.conf/ssl/domain.tld.csr -signkey /bandito-box/.conf/ssl/domain.tld.key -out /bandito-box/.conf/ssl/domain.tld.crt
cat /bandito-box/.conf/ssl/domain.tld.key /bandito-box/.conf/ssl/domain.tld.crt > /bandito-box/.conf/ssl/domain.tld.pem

#----> Backup the self signed SSL Certs
mkdir -p /bandito-box/.backup/ssl
cp /bandito-box/.conf/ssl/* /bandito-box/.backup/ssl

#----> Copy Nginx conf files to /etc/nginx/conf.d folder
cp /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/auth-basic.conf /etc/nginx/conf.d/auth-basic.conf
cp /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/proxy-control.conf /etc/nginx/conf.d/proxy-control.conf
cp /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/site-available.conf /etc/nginx/conf.d/site-available.conf
cp /bandito-box/apps/Bandito-Box/conf/etc/nginx/conf.d/ssl.conf /etc/nginx/conf.d/ssl.conf

#----> Link files to Bandito Box
ln -s /var/log/nginx/access.log /bandito-box/logs/Nginx-Access.log
ln -s /var/log/nginx/error.log /bandito-box/logs/Nginx-Error.log
ln -s /bandito-box/.data/Nginx/www /usr/share/nginx/www
ln -s /bandito-box/.conf/Nginx/htpassword /etc/nginx/.htpasswd
ln -s /etc/nginx/conf.d/auth-basic.conf /bandito-box/.conf/Nginx/Auth-Basic.conf
ln -s /etc/nginx/conf.d/proxy-control.conf /bandito-box/.conf/Nginx/Proxy-Control.conf
ln -s /etc/nginx/conf.d/site-available.conf /bandito-box/.conf/Nginx/Site-Available.conf
ln -s /etc/nginx/conf.d/ssl.conf /bandito-box/.conf/Nginx/SSL.conf
# Each app install the their own /etc/nginx/conf.d/service-*.conf and
# link it to /bandito-box/.conf/Nginx/

#----> Start service
service nginx restart
