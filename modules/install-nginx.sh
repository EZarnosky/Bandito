#--------> Nginx
#----> Install dependencies
apt-get update && apt-get upgrade -y && apt-get install nginx -y && apt-get autoremove -y

#----> Generate self signed SSL cert if none present
openssl genrsa -out /bandito-box/.conf/ssl/domain.tld.key 1024
openssl req -new -key /bandito-box/.conf/ssl/domain.tld.key -out /bandito-box/.conf/ssl/domain.tld.csr -subj '/C=US/OU=Private Party/CN=domain.tld'
openssl x509 -req -days 365 -in /bandito-box/.conf/ssl/domain.tld.csr -signkey /bandito-box/.conf/ssl/domain.tld.key -out /bandito-box/.conf/ssl/domain.tld.crt
cat /bandito-box/.conf/ssl/domain.tld.key /bandito-box/.conf/ssl/domain.tld.crt > /bandito-box/.conf/ssl/domain.tld.pem

mkdir -p /bandito-box/.backup/ssl
cp /bandito-box/.conf/ssl/* /bandito-box/.backup/ssl

#----> Start service
service nginx restart
