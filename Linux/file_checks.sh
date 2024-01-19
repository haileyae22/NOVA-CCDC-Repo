#!/bin/bash
#File Checks
#Initiate prev variables
PREV_SETXID=""
PREV_PASSWD=""
PREV_GROUP=""
PREV_SUDOERS=""
PREV_SERVICES=""
LOGFILE="file_changes_$(date +%Y%m%d_%H%M%S).log"

while true; do
    #Check for new SETUID/GID files
    SETXID=$(grep -v -f setxid.orig <(sudo find /bin/ -perm /6000))
    #Check for new passwd entries
    PASSWD=$(grep -v -f passwd.orig /etc/passwd)
    #Check for new group entries
    GROUP=$(grep -v -f group.orig /etc/group)
    #Check for sudeors modification
    SUDOERS=$(sudo grep -v -f sudoers.orig /etc/sudoers)
    #Check for added services
    SERVICES=$(grep -v -f services.orig <(sudo systemctl list-unit-files --type=service --state=enabled --no-pager))

    #Loop to check for any new entries
    if [[ "$SETXID" != "" && "$SETXID" != "$PREV_SETXID" ]]; then
        echo "$SETXID setxid entries found" | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }'
        PREV_SETXID="$SETXID"
    fi

    if [[ "$PASSWD" != "" && "$PASSWD" != "$PREV_PASSWD" ]]; then
        echo "$PASSWD passwd entries found" | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }'
        PREV_PASSWD="$PASSWD"
    fi

    if [[ "$GROUP" != "" && "$GROUP" != "$PREV_GROUP" ]]; then
        echo "$GROUP group entries found" | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }'  
        PREV_GROUP="$GROUP"
    fi

    if [[ "$SUDOERS" != "" && "$SUDOERS" != "$PREV_SUDOERS" ]]; then
        echo "$SUDOERS sudoers entries found" | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }'
        PREV_SUDOERS="$SUDOERS"
    fi

    if [[ "$SERVICES" != "" && "$SERVICES" != "$PREV_SERVICES" ]]; then
        echo "$SERVICES new service found" | awk '{ printf("%s %s\n", strftime("%c", systime()), $0) }'
        PREV_SERVICES="$SERVICES"
    fi


    sleep 1
    #Output to log file (create a new log file if one exists)
done | tee -a "$LOGFILE"
