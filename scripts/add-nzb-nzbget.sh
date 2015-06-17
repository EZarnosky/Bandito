#!/bin/sh
#---> NZBGet
#--> install VideoSort
mkdir $Ban_Packages/VideoSort/ && cd $Ban_Packages/VideoSort/
wget $Deb_Videosort
mkdir $Ban_Scripts/NZBGet && cd $Ban_Scripts/NZBGet
unzip $Ban_Packages/VideoSort/videosort*.zip

#--> Add the repo
gpg --recv-keys --keyserver keyserver.ubuntu.com 0E50BF67
gpg -a --export 0E50BF67 | apt-key add -
echo "deb http://packages.unusedbytes.ca wheezy main" |  tee -a /etc/apt/sources.list.d/nzbget.list

#--> refresh the repos
apt-get update

#--> install NZBGet
apt-get install nzbget -y

#--> Backup Conf file
mkdir $Ban_Backup/NZBGet
cp /usr/share/nzbget/nzbget.conf $Ban_Backup/NZBGet/nzbget.conf-backup

#--> Link to the 
ln -s /usr/share/nzbget/nzbget.conf $Ban_Conf/nzbget.conf
ln -s /usr/share/nzbget/nzbget.conf /etc/nzbget.conf

#--> Edit the config file
sed -i "s#MainDir=~/downloads#MainDir="$Ban_Data"/NZBGet#g" $Ban_Conf/nzbget.conf
sed -i 's#ScriptDir=${MainDir}/scripts#ScriptDir='$Ban_Scripts'/NZBGet#g' $Ban_Conf/nzbget.conf
sed -i 's#LogFile=${DestDir}/nzbget.log#LogFile='$Ban_Logs'/nzbget.log#g' $Ban_Conf/nzbget.conf
sed -i 's#ConfigTemplate=/usr/share/nzbget/nzbget.conf#ConfigTemplate='$Ban_Backup'/NZBGet/nzbget.conf-backup#g' $Ban_Conf/nzbget.conf
sed -i 's#ControlUsername=nzbget#ControlUsername='$Bandito_User'#g' $Ban_Conf/nzbget.conf
sed -i 's#ControlPassword=tegbzn6789#ControlPassword='$Bandito_Password'#g' $Ban_Conf/nzbget.conf
sed -i 's#DaemonUsername=root#DaemonUsername='$Bandito_User'#g' $Ban_Conf/nzbget.conf

#--> Configure NZBGet to autostart on boot
cp /opt/Bandito-Box/conf/etc_init.d_nzbget.conf /etc/init.d/nzbget
chown $Bandito_User:$Bandito_Group /etc/init.d/nzbget
chmod +x /etc/init.d/nzbget
update-rc.d nzbget defaults
