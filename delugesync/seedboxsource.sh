#################################################################################################################################
#
#                                                                                                                      
#	                                                                      dddddddd                                        
#	BBBBBBBBBBBBBBBBB                                                     d::::::d                                        
#	B::::::::::::::::B                                                    d::::::d                                        
#	B::::::BBBBBB:::::B                                                   d::::::d                                        
#	BB:::::B     B::::B                                                   d:::::d                                         
#  	B::::B     B:::::B    eeeeeeeeeeee    nnnn  nnnnnnnn        ddddddddd:::::d     eeeeeeeeeeee    rrrrr   rrrrrrrrr   
#  	B::::B     B:::::B  ee::::::::::::ee  n:::nn::::::::nn    dd::::::::::::::d   ee::::::::::::ee  r::::rrr:::::::::r  
#  	B::::BBBBBB:::::B  e::::::eeeee:::::een::::::::::::::nn  d::::::::::::::::d  e::::::eeeee:::::eer:::::::::::::::::r 
#  	B:::::::::::::BB  e::::::e     e:::::enn:::::::::::::::nd:::::::ddddd:::::d e::::::e     e:::::err::::::rrrrr::::::r
#  	B::::BBBBBB:::::B e:::::::eeeee::::::e  n:::::nnnn:::::nd::::::d    d:::::d e:::::::eeeee::::::e r:::::r     r:::::r
#  	B::::B     B:::::Be:::::::::::::::::e   n::::n    n::::nd:::::d     d:::::d e:::::::::::::::::e  r:::::r     rrrrrrr
#  	B::::B     B:::::Be::::::eeeeeeeeeee    n::::n    n::::nd:::::d     d:::::d e::::::eeeeeeeeeee   r:::::r            
#  	B::::B     B:::::Be:::::::e             n::::n    n::::nd:::::d     d:::::d e:::::::e            r:::::r            
#	BB:::::BBBBBB::::Be::::::::e            n::::n    n::::nd::::::ddddd::::::dde::::::::e             r:::::r            
#	B:::::::::::::::::B  e::::::::eeeeeeee  n::::n    n::::n d:::::::::::::::::d e::::::::eeeeeeee     r:::::r            
#	B::::::::::::::::B    ee:::::::::::::e  n::::n    n::::n  d:::::::::ddd::::d  ee:::::::::::::e     r:::::r            
#	BBBBBBBBBBBBBBBBB       eeeeeeeeeeeeee  nnnnnn    nnnnnn   ddddddddd   ddddd    eeeeeeeeeeeeee     rrrrrrr            
#                                                                                                                      
#                                                                                                                      
#################################################################################################################################  
#!/bin/bash

########   VARIABLES  ########
#set the directory you move to in your label settings
testfor="musiclibrary"       
remotehost=x.x.x.x or server.domain.com  #set to your remote ssh host
sshport=22
#set to the blackhole directory on the remote side AS THE HOST SEES IT (not the container)
remotepath=/downloads/torrents/red/sshblackhole/ 

#### install ssh if not installed ###
if [ ! -f /var/local/sshinstall.txt ]
  then
    yes | pacman -Sy openssh
    touch /var/local/sshinstall.txt
    wait 30
  else
    echo "ssh is already installed" &
fi


#### dont touch as these are set by deluge #########
torrentid=$1
torrentname=$2
torrentpath=$3
#echo "Torrent Details: " "$torrentname" "$torrentpath" "$torrentid"  >> /config/seedmover.log

#### check if it maches our testfor variable ######
if [[ $3 == *"$testfor"* ]];
  then
#   echo "path matches, lets copy" >> /config/seedmovetest.log
# create test file and copy torrent
    ssh -p ${sshport} -o "StrictHostKeyChecking no" -i id_rsa sshfs@${remotehost} 'echo '$torrentid' >> '${remotepath}'/'$torrentid'' >> sshtestlog.log
    scp -P ${sshport} -i id_rsa /config/state/${torrentid}.torrent sshfs@${remotehost}:${remotepath}
#'docker exec delugevpn deluge-console -c /config "info" '$torrentid'' >> sshtestlog.log
  else
  echo "path doesnt match, will exit" >> seedmovetest.log
fi
exit