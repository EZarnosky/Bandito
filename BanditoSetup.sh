#-----> Setup for Bandito
#----|
#----|  Eric Zarnosky
#----|  ezarnosky@gmail.com
#----|

#---> Part 1: Load Conf file and start geneal setup

# TODO: Read Conf file

#--> Create user account and group
addgroup $Bandito_Group --force-badname
useradd -g root -G sudo,$Bandito_Group -s /bin/zsh -p $Bandito_Password -d /home/bandito -m $Bandito_User -c 'User account for all Bandito installed applications'

#--> Create folder structure
mkdir -p $Ban_Home
mkdir -p $Ban_Conf
mkdir -p $Ban_Packages
mkdir -p $Ban_Installer
mkdir -p $Ban_Scripts
mkdir -p $Ban_Backup
mkdir -p $Ban_Logs
mkdir -p $Ban_Apps

#--> Update the repositories
echo "Updating Repositories"
apt-get update
apt-get upgrade -y
apt-get install apt-transport-https -y

#--> Install midnight commander
apt-get install mc -y

#--> Install SMB and NTFS packages
apt-get install cifs-utils -y

#--> Create mount folders and mount drives
mkdir -p /mnt/usb_dl_store
ln -s /mnt/usb_dl_store /bandito/incoming

mkdir -p /mnt/net_media_share
mount -t cifs -o username=$Share_Media_User,password=$Share_Media_Pass,iocharset=$Share_Media_CharSet,sec=$Share_Media_Sec $Share_Media_Path /mnt/net_media_share
ln -s /mnt/net_media_share $Ban_Home/media

mkdir -p /mnt/net_backup_share
mount -t cifs -o $Share_Backup_User,password=$Share_Backup_Pass,iocharset=$Share_Backup_CharSet,sec=$Share_Backup_Sec $Share_Backup_Path /mnt/net_backup_share
ln -s /mnt/net_backup_share $Ban_Backup/remote_archive

#--> Add mounts to fstab
# TODO: add vaiables in INI for share name, mount point, username and password
echo '' >> /etc/fstab
echo '# Network shares for Bandito Box' >> /etc/fstab
echo "$Share_Media_Path /mnt/net_media_share cifs username=$Share_Media_User,password=$Share_Media_Pass,iocharset=$Share_Media_CharSet,sec=$Share_Media_CharSet  0  0" >> /etc/fstab
echo "$Share_Backup_Path /mnt/net_backup_share cifs username=$Share_Backup_User,password=$Share_Backup_Pass,iocharset=$Share_Backup_CharSet,sec=$Share_Backup_CharSet  0  0" >> /etc/fstab
echo '' >> /etc/fstab

#--> Generate self signed SSL vertificate
mkdir -p $Ban_Apps/bandito/ssl && $Ban_Apps/bandito/ssl
openssl genrsa 1024 > bandito_ssl.key
openssl req -new -key ssl.key -out bandito_ssl.csr -subj $SSL_Subj
openssl req -days 36500 -x509 -key bandito_ssl.key -in bandito_ssl.csr > bandito_ssl.crt 

#--> Install coomon shared packages
apt-get install python git -y

#---> Part 2: Selective install
# Read BanditoSetup.Answers for what the user wants installed
