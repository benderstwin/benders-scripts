To do to increase functionality:
add ability to transfer with rclone
add ability to define multiple directories (for multiple labels/trackers)
create setup script to copy deluge scripts, generate sshkeys and copy pub key to remote host

NOTE:  You must sync your files to your seedbox.  I use syncthing for this currently, but you can use whatever you want.

create public/private keys for ssh

on remote machine add a user  
```sudo adduser sshfs```

create and give user permissions to your blackhole directory
```mkdir /downloads/torrents/blackhole``` 
```setfacl -d -m g:sshfs:rwX /downloads/torrents/sshblackhole```

#you may have to install acl

login as newly created sshfs user
create folder /home/sshfs/.ssh
copy public key to this directory and name it authorized_keys

on local machine
create a folder for the private key, easiest just to put the private key in the /config directory for deluge
copy private key to this folder as id_rsa
set up a label for the tracker you would like to sync to your seedbox and automove to the desired directory
add seedboxsource.sh to the deluge /config directory
configure execute plugin to run the script on torrent completion
set labels to move completed to desired location
edit script variables:

testfor="musiclibrary"       #set the directory you move to in your label settings
remotehost=x.x.x.x or server.domain.com  #set to your remote ssh host
sshport=22
remotepath=/downloads/torrents/sshblackhole/ #set to the blackhole directory on the remote side

add seedboxdestination.sh to seedbox and put it in deluge's /config directory
configure execute plugin to run the script on torrent ADD
edit script variables:

INCOMINGDIR=/data/torrents/blackhole #create a directory for blackhole
COMPLETEDDIR=/data/torrents/ipt

set option in deluge to add torrents in a paused state.  if the script doesnt detect that its a torrent it shouldn't watch, it will automatically resume and torrents added.

## Support on Beerpay
If you feel like donating, I like :beers:! :smiley:

[![Beerpay](https://beerpay.io/benderstwin/benders-scripts/badge.svg)](https://beerpay.io/benderstwin/benders-scripts)
