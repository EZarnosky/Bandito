#!/bin/sh
#---> pyLoad

#--> install dependencies
apt-get install liblept3 -y
apt-get install python python-crypto python-pycurl python-imaging tesseract-ocr python-qt4 rhino zip unzip -y

#--> Install UnRAR
mkdir $Ban_Packages/UnRAR/ && cd $Ban_Packages/UnRAR/
wget $Deb_Unrar

dpkg -i unrar*.deb

#--> Install pyLoad
mkdir $Ban_Packages/pyLoad/ && cd $Ban_Packages/pyLoad/
wget $Deb_pyLoad

dpkg -i $Ban_Packages/pyLoad/py*.deb

ln -s /usr/share/pyload $Ban_Apps/pyload

cd $Ban_Apps/pyload

#--> Config pyLoad
# Link the Bandito SSL cert
ln -s /bandito/apps/bandito/ssl/bandito_ssl.crt /bandito/apps/pyload/ssl.crt


python pyLoadCore.py -s

#https://wiki.archlinux.org/index.php/PyLoad