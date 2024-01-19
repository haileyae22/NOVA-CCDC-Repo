#!/bin/bash

while :
do
    #Check for new SETUID/GID files
    SETXID=$(grep -v -f setxid.orig <(sudo find / -perm /6000) | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }')
    #Check for new passwd entries
    PASSWD=$(grep -v -f passwd.orig /etc/passwd | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }')
    #Check for new group entries
    GROUP=$(grep -v -f group.orig /etc/group | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }')
    #Check for sudeors modification
    SUDOERS=$(sudo grep -v -f sudoers.orig /etc/sudoers | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }')
    #Check for added services
    #grep 
    #Check for added public keys

    #Loop to check for any new entries
    if [ "$SETXID" != "" ]
    then
        echo "$SETXID SETUID/GID files found"
    fi

    if [ "$PASSWD" != "" ]
    then
        echo "$PASSWD passwd entries found"
    fi

    if [ "$GROUP" != "" ]
    then
        echo "$GROUP group entries found"
    fi

    if [ "$SUDOERS" != "" ]
    then
        echo "$SUDOERS sudoers entries found"
    fi

    sleep 5
done