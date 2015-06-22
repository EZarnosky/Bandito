#----------------> Bandito Box Installer Stub
#------------> Use this to start the installation

#--------> Prepare environment

#----> Build folder structure
echo "Build folder structure"
mkdir -p /bandito-box/apps                   # Default install folder for all apps

#----> Install dependencies
echo "Install dependencies"
apt-get update && apt-get upgrade -y && apt-get install apt-transport-https git-core -y && apt-get autoremove -y

#----> Clone Git Repository
echo "Clone Git Repository"
git clone https://github.com/EZarnosky/Bandito /bandito-box/apps/Bandito-Box

#----> Start the main installer
echo "Start the main installer"
chmod +x /bandito-box/apps/Bandito-Box/bb-installer.sh && /bandito-box/apps/Bandito-Box/bb-installer.sh

#--> Mod module scripts to make executable
chmod +x /bandito-box/apps/Bandito-Box/modules/*.sh
