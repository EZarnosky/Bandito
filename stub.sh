#-----> Bandito Box Stub Installer
#----|
#----|  Eric Zarnosky
#----|  ezarnosky@gmail.comi
#----|
#--> Create the Bandito Box user and group, give root group membership
addgroup $Bandito_Group --force-badname
useradd -g root -G sudo,$Bandito_Group -s /bin/zsh -p $Bandito_Password -d /home/bandito -m $Bandito_User -c 'User account for all Bandito installed applications'
usermod -a -G $Bandito_Group root

#--> Update the repositories
echo "Updating Repositories"
apt-get update
apt-get upgrade -y
apt-get install apt-transport-https git -y

#--> Clone the Bandito-Box git
git clone $Git_BanditoBox /opt/Bandito-Box
