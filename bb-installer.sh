#----------------> Bandito Box Installer
echo "Bandito Box Installer"

#--------> Prepare environment
echo "Prepare environment"

#----> Build folder structure
echo "Build folder structure"
mkdir -p /bandito-box/.packages              # Download location for zip and deb files to 
mkdir -p /bandito-box/logs                   # Log file location for all apps
mkdir -p /bandito-box/.conf/ssl              # SSL Certs folder
mkdir -p /bandito-box/.data/                 # App data folder (cache, db, etc.)
mkdir -p /bandito-box/.data/USB              # USB mount point for root drive access
mkdir -p /bandito-box/tmp                    # Temp working folder 
mkdir -p /bandito-box/.pids                  # location for all applicaiton PID files
mkdir -p /bandito-box/.backup                # Location for applicaiton backups - good use for USB drive
mkdir -p /bandito-box/media                  # Media location - typically a SMB share

#--> Assign permissions to new folders
chmod -R 777 /bandito-box/.pids

#----> Install dependencies
echo "Install dependencies"
apt-get update && apt-get upgrade -y && apt-get install zip unzip p7zip-full cifs-utils ntfs-3g build-essential make gcc -y && apt-get autoremove -y

#----> Mount drive (USB & Network)
echo "Mount drive (USB & Network)"
#--> Update fstab
echo "Update fstab"
echo '' >> /etc/fstab
echo '# USB Download storage' >> /etc/fstab
echo 'UUID=USB_DRIVE_UUID /bandito-box/.data/USB ntfs-3g uid=1000,gid=1000,umask=007 0 0' >> /etc/fstab
echo '' >> /etc/fstab
echo '# Network shares for Bandito Box' >> /etc/fstab
echo "//x.x.x.x/Media /bandito-box/media cifs username=SHARE_USER,password=SHARE_PASSWORD,iocharset=utf8,sec=ntlm  0  0" >> /etc/fstab
echo "//x.x.x.x/Backup/Applications/Bandito-Box /bandito-box/.backup cifs username=SHARE_USER,password=SHARE_PASSWORD,iocharset=utf8,sec=ntlm  0  0" >> /etc/fstab
echo '' >> /etc/fstab

#--> Perform mount of all drives in fstab
echo "Perform mount of all drives in fstab"
mount -a

#----> Change MOTD banner
echo "Change MOTD banner"
mv /etc/motd /bandito-box/.backup/motd.backup
tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc/motd > /etc/motd

#----> Add records to hosts file
echo "Add records to hosts file"
cp /etc/hosts /bandito-box/.backup/hosts.backup
#tr -d '\r' < /bandito-box/apps/Bandito-Box/conf/etc_hosts > /bandito-box/tmp/etc_hosts && cat /bandito-box/tmp/etc_hosts >> /etc/hosts
#rm /bandito-box/tmp/etc_hosts

echo "Time to install individual apps... WIP"

echo "\nInstalling Nginx"
#/bandito-box/apps/Bandito-Box/modules/install-nginx.sh

echo "\nInstalling CouchPotato"
#/bandito-box/apps/Bandito-Box/modules/install-couchpotato.sh

echo "\nInstalling SickRage"
#/bandito-box/apps/Bandito-Box/modules/install-sickrage.sh

echo "\nInstalling Headphones"
#/bandito-box/apps/Bandito-Box/modules/install-headphones.sh

echo "\nInstalling HTPC Manager"
#/bandito-box/apps/Bandito-Box/modules/install-htpcmanager.sh

echo "\n\n\nDone for now, working on the other scripts still..... ^.^"
