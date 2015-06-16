#-----> Setup for Bandito
#----|
#----|  Eric Zarnosky
#----|  ezarnosky@gmail.com
#----|

#---> Part 1: Load Conf file and start geneal setup

# TODO: Read Conf file

#--> Create user account and group
useradd -ou 0 -g 0 -d /home/bandito -m $Bandito_User
passwd $Bandito_Password

addgroup $Bandito_Group
usermod -a -G $Bandito_Group $Bandito_User

#--> Create folder structure
mkdir $Ban_Home
mkdir $Ban_Conf
mkdir $Ban_Packages
mkdir $Ban_Installer
mkdir $Ban_Incoming
mkdir $Ban_Scripts
mkdir $Ban_Backup
mkdir $Ban_Logs

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
