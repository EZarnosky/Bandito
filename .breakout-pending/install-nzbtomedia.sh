#--------> nzbToMedia
#----> Create user account for service
useradd --system --user-group --no-create-home bandito-htpcmgr

#----> Create folders for app
mkdir -p /bandito-box/.data/HTPCManager

#----> Install dependencies
#--> Install all other dependencies from wheezy repo
apt-get upgrade -y && apt-get install python -y 

#----> Clone Git Repository
git clone https://github.com/clinton-hall/nzbToMedia /bandito-box/apps/nzbToMedia




mv autoProcessMedia.cfg.sample autoProcessMedia.cfg
#http://www.gizmojunkee.com/2013/10/setup-sick-beard-on-ubuntu-12-04-server/
#http://ffmpeginstaller.com/