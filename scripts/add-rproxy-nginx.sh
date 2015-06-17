#!/bin/sh
#---> Nginx
apt-get install nginx -y

# TODO - Setup soft links to bandito conf directory for nginx conf files and bandito logs directory for nginx logs

service nginx start
