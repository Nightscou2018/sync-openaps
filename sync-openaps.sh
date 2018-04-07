#!/bin/bash
#
# Syncs openaps rigs preferences.json
# All passwords must be the same and in the environment variable RSYNC_PASSWD
#
# You have to run rsync manually for the first time from this rig to the others to setup the 
# initial trust key
#
epochdate=$(date +'%s')

# user which is usually root
user="root"

# servers - list of all rig hostnames or ip addresses - add your own list of rigs here 
servers="
        eddie2
        fido0
	"

# servers - list of all files to sync - add your own list of filenames here 
files="
      /root/myopenaps/preferences.json
      /root/.bash_profile
      /etc/wpa_supplicant/wpa_supplicant.conf
      "

# save files just in case
tar -czvf ./save-$epochdate.tar.gz $files

for server in $servers; do
  for file in $files; do
    echo Debug $server -- $file
  done
done

for server in $servers; do
  for file in $files; do
    echo 
    echo syncing $file from $server to $(hostname)
    sshpass -p $RSYNC_PASSWD rsync -rtuzv ${user}@${server}:${file} ${file} 
    echo
  done
done

echo
echo 

for server in $servers; do
  for file in $files; do
    echo 
    echo syncing $file from $(hostname) to $server
    sshpass -p $RSYNC_PASSWD  rsync -rtuzv ${file} ${user}@${server}:${file}
    echo
  done
done
