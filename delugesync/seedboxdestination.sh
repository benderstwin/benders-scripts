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
                                                                                                                      
                                                                                                                      
#script written by Bender (github.com/benderstwin)
#place this script in deluge config directory on seedbox and use execute plugin to run on "add"

#!/bin/bash
#SET VARIABLES
INCOMINGDIR=/data/torrents/blackhole
COMPLETEDDIR=/data/torrents/ipt
#Dont touch these variables as they are set by deluge
torrentid=$1
torrentname=$2
torrentpath=$3

############check if torrent was added by remote host to the sync directory##########
mkdir -p /config/synclogs
config=/config

if [ ! -f $INCOMINGDIR/${torrentid} ]
  then
    echo "file doesnt exist, resuming torrent download'
    deluge-console -c $config "resume" $torrentid
    exit
fi


torrentfile=${INCOMINGDIR}/${torrentid}.torrent


#remove torrent and add with path to completed
deluge-console -c ${config} "add -p" ${COMPLETEDDIR} ${torrentfile}

#######start checking progress for completion  before resuming

result=$(deluge-console -c /config "info" ${torrentid} |grep Size)

line0int=5
line1int=10
while [ $line0int -ne $line1int ]
do
result=$(deluge-console -c $config "info" ${torrentid} |grep Size)
clean1=$(awk -F ' [MK]iB/' '{for(i=1;i<=NF;i++){printf $i"\n"}}' <<< $result)
#echo "value after awk=" ${clean1}
IFS=": "
arrayindex=($clean1)
echo ${arrayindex[1]} > /config/synclogs/${torrentid}size.txt
readarray -t line < /config/synclogs/${torrentid}size.txt
####### remove decimal #######
line0int=${line[0]%.*}
line1int=${line[1]%.*}
echo ${line0int}/${line1int} > /config/synclogs/${torrentid}status.txt
deluge-console -c $config "recheck" ${torrentid}
sleep 10
done

######################end of progress loop##########################

echo "sync is complete" > /config/synclogs/${torrentid}status.txt
deluge-console -c $config "resume" $torrentid
exit
