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

for server in $servers; do
    echo 
    echo syncing $server to $(hostname)
    sshpass -p $RSYNC_PASSWD rsync -rtuzv ${user}@${server}:/root/test /root/
    echo
done

echo
echo 

for server in $servers; do
    echo 
    echo syncing $(hostname) to $server
    sshpass -p $RSYNC_PASSWD  rsync -rtuzv /root/test ${user}@${server}:/root/
    echo
done
