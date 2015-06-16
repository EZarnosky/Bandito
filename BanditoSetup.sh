#-----> Setup for Bandito
#----|
#----|  Eric Zarnosky
#----|  ezarnosky@gmail.com
#----|

#---> Part 1: Load Conf file and start geneal setup

# TODO: Read Conf file

#--> Create user account and group
useradd -ou 0 -g 0 $Bandito_User
passwd $Bandito_Password

sudo addgroup $Bandito_Group
sudo usermod -a -G $Bandito_Group $Bandito_User

#--> Create folder structure
sudo mkdir $Ban_Home
sudo mkdir $Ban_Conf
sudo mkdir $Ban_Packages
sudo mkdir $Ban_Installer
sudo mkdir $Ban_Incoming
sudo mkdir $Ban_Scripts
sudo mkdir $Ban_Backup
sudo mkdir $Ban_Logs

#--> Update the repositories
echo "Updating Repositories"
apt-get update
apt-get upgrade -y
apt-get install apt-transport-https -y

#--> Install midnight commander
apt-get install mc -y

#--> Install coomon shared packages
apt-get install python git -y

#---> Part 2: Selective install
# Read BanditoSetup.Answers for what the user wants installed
