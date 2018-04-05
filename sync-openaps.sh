#!/bin/bash

sshpass -p $RSYNC_PASSWD rsync -rtuzv root@fido3:/root/test /root/
sshpass -p $RSYNC_PASSWD  rsync -rtuzv /root/test root@fido3:/root/

