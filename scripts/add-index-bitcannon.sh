#!/bin/sh
#---> BitCannon
#-> Part 1: Install MongoDB
mkdir /opt/mongodb && cd /opt/mongodb
wget https://github.com/brice-morin/ArduPi/blob/master/mongodb-rpi/mongo/bin/bsondump?raw=true -O bsondump
wget https://github.com/brice-morin/ArduPi/blob/master/mongodb-rpi/mongo/bin/mongo?raw=true -O mongo
wget https://github.com/brice-morin/ArduPi/blob/master/mongodb-rpi/mongo/bin/mongod?raw=true -O mongod
wget https://github.com/brice-morin/ArduPi/blob/master/mongodb-rpi/mongo/bin/mongodump?raw=true -O mongodump
chmod +x *

#-> Part 2: Install BitCannon
git clone $Git_BitCannon /opt/BitCannon

mkir $Ban_Packages/node && $Ban_Packages/node
wget http://node-arm.herokuapp.com/node_latest_armhf.deb
dpkg -i node_latest_armhf.deb

npm install -g grunt
npm install -g grunt-cli

cd web
npm install
bower install
grunt
