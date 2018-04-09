#!/bin/bash
#
# Syncs openaps rigs preferences.json
# All passwords must be the same and in the environment variable RSYNC_PASSWD
#
# You have to run rsync manually for the first time from this rig to the others to setup the 
# initial trust key
#
epochdate=$(date +'%s')

# servers - list of all rig hostnames or ip addresses - add your own list of rigs here 
servers="
        root@eddie2
        root@fido0
	"

# servers - list of all files to sync - add your own list of filenames here 
#files="
#      ~/myopenaps/preferences.json
#      ~/.bash_profile
#      /etc/wpa_supplicant/wpa_supplicant.conf
#      "
files="
      /root/myopenaps/preferences.json
      /etc/wpa_supplicant/wpa_supplicant.conf
      /root/.bash_profile
      /root/src/Lookout/calibrations.csv
      /root/src/Lookout/calibration-linear.json
      "

cd
mkdir -p ./archive
# save files just in case
tar -czvf ./archive/files-$epochdate.tar.gz $files

for server in $servers; do
  for file in $files; do
    echo Debug $server -- $file
  done
done

for server in $servers; do
  for file in $files; do
    echo 
    echo syncing $file from $server to $(hostname)
    sshpass -p $RSYNC_PASSWD rsync -rtuzv ${server}:${file} ${file} 
    echo
  done
done

echo
echo 

for server in $servers; do
  for file in $files; do
    echo 
    echo syncing $file from $(hostname) to $server
    sshpass -p $RSYNC_PASSWD  rsync -rtuzv ${file} ${server}:${file}
    echo
  done
done

for server in $servers; do
    sshpass -p $RSYNC_PASSWD  rsync -rtuzv ${server}:/root/myopenaps/autotune /root/myopenaps
done

for server in $servers; do
    sshpass -p $RSYNC_PASSWD  rsync -rtuzv /root/myopenaps/autotune ${server}:/root/myopenaps
done
