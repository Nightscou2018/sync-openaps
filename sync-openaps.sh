#!/bin/bash
#
# Syncs openaps rigs preferences.json
# All passwords must be the same and in the environment variable RSYNC_PASSWD
#
# You have to run rsync manually for the first time from this rig to the others to setup the 
# initial trust key
#

# user which is usually root
user="root"

# servers - list of all rig hostnames or ip addresses with spaces in between
servers="eddie2 fido0"

file="/root/test/preferences.json"

for server in $servers; do
    echo 
    echo syncing $server to $(hostname)
    sshpass -p $RSYNC_PASSWD rsync -rtuzv ${user}@${server}:${file} ${file} 
    echo
done

echo
echo 

for server in $servers; do
    echo 
    echo syncing $(hostname) to $server
    sshpass -p $RSYNC_PASSWD  rsync -rtuzv ${file} ${user}@${server}:${file}
    echo
done
