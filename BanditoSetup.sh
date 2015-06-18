#-----> Bandito Box
#----|
#----|  Eric Zarnosky
#----|  ezarnosky@gmail.comi
#----|

#---> Part 1: Load Conf file and start geneal setup

# TODO: Read Conf file

#--> Create user account and group
#addgroup $Bandito_Group --force-badname
#useradd -g root -G sudo,$Bandito_Group -s /bin/zsh -p $Bandito_Password -d /home/bandito -m $Bandito_User -c 'User account for all Bandito installed applications'
useradd -g root -ou 0 $Bandito_User -s /bin/zsh -d /root -p $Bandito_Password -c 'Cloned root account for Bandito Box'

#--> Create folder structure
mkdir -p $Ban_Home
mkdir -p $Ban_Conf
mkdir -p $Ban_Packages
mkdir -p $Ban_Installer
mkdir -p $Ban_Scripts
mkdir -p $Ban_Logs
mkdir -p $Ban_Apps
mkdir -p $Ban_Data

chown -R $Bandito_User:$Bandito_Group $Ban_Home

#--> Switch to Bandito-Box user to start all the installs
#su bandito

#--> Update the repositories
echo "Updating Repositories"
apt-get update
apt-get upgrade -y
apt-get install apt-transport-https -y

#--> Install common shared packages
apt-get install mc unzip -y

#--> Install file system packages
apt-get install cifs-utils ntfs-3g -y

#--> Install git and compile packages
apt-get install make gcc git -y

#--> Install basic python packages
apt-get install python python-dev -y

#--> Install non Apt packages
mkdir $Ban_Packages/unRAR/ && cd $Ban_Packages/unRAR/
wget $Deb_Unrar
dpkg -i unrar*.deb

#--> Create mount folders and mount drives
mkdir -p /mnt/usb_dl_store
mount -t ntfs-3g -o uid=1000,gid=1000,umask=007 /dev/sda1 /mnt/usb_dl_store
mkdir -p /mnt/usb_dl_store/download
ln -s /mnt/usb_dl_store/download $Ban_Data/download
ln -s /mnt/usb_dl_store/backup $Ban_Backup

mkdir -p /mnt/net_media_share
mount -t cifs -o username=$Share_Media_User,password=$Share_Media_Pass,iocharset=$Share_Media_CharSet,sec=$Share_Media_Sec $Share_Media_Path /mnt/net_media_share
ln -s /mnt/net_media_share $Ban_Data/media

mkdir -p /mnt/net_backup_share
mount -t cifs -o username=$Share_Backup_User,password=$Share_Backup_Pass,iocharset=$Share_Backup_CharSet,sec=$Share_Backup_Sec $Share_Backup_Path /mnt/net_backup_share
ln -s /mnt/net_backup_share $Ban_Backup/remote_archive

#--> Add mounts to fstab
# TODO: add vaiables in INI for share name, mount point, username and password
echo '' >> /etc/fstab
echo '# Network shares for Bandito Box' >> /etc/fstab
echo "$Share_Media_Path /mnt/net_media_share cifs username=$Share_Media_User,password=$Share_Media_Pass,iocharset=$Share_Media_CharSet,sec=$Share_Media_Sec  0  0" >> /etc/fstab
echo "$Share_Backup_Path /mnt/net_backup_share cifs username=$Share_Backup_User,password=$Share_Backup_Pass,iocharset=$Share_Backup_CharSet,sec=$Share_Backup_Sec  0  0" >> /etc/fstab
echo '' >> /etc/fstab

#--> Generate self signed SSL vertificate
mkdir -p $Ban_Apps/bandito-box/ssl && cd $Ban_Apps/bandito-box/ssl
openssl genrsa 1024 > bandito_ssl.key
openssl req -new -key bandito_ssl.key -out bandito_ssl.csr -subj $SSL_Subj
openssl req -days 36500 -x509 -key bandito_ssl.key -in bandito_ssl.csr > bandito_ssl.crt 

#--> Clone the Bandito-Box git
git clone $Git_BanditoBox /opt/Bandito-Box

#---> Part 2: Selective install
# Read BanditoSetup.Answers for what the user wants installed
