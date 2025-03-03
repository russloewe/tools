#!/bin/bash
# Description: Script for backing up local files to multiple locations
# Author: Russ Loewe
# Date: Sept 2023
# Notes: use crontab to run on a schedule

# >crontab -e
## m h  dom mon dow   command
#  */10 * * * *    /home/russell/Dropbox/code/home_server/backup_home.sh >> /home/russell/backup_home.log 2>&1

# Set the source and destination directories
SOURCE_DIR="/home/russell"
REMOTE_BK="/var/www/russell"
LOCAL_EXT="/media/russell/Untitled/russell"
HOST=10.0.0.144
LOCKFILE="/tmp/my_backup_lockfile"

check_and_create_lockfile() {
  if [ -f "$LOCKFILE" ]; then
    echo "Lockfile exists. Another backup process might be running. Exiting."
    exit 1
  else
    touch "$LOCKFILE"
    echo "Lockfile created."
  fi
}

delete_lockfile() {
  if [ -f "$LOCKFILE" ]; then
    rm "$LOCKFILE"
    echo "Lockfile deleted."
  else
    echo "Lockfile not found."
  fi
}

upload_with_skip_existing() {
    local source_path="$1"
    local remote_path="$2"

    rsync -av --update "$source_path" "root@${HOST}:${remote_path}"
}

remote_command () {
    ssh root@${HOST} $1
}

backup_folders_to_server_hd () {
    echo
    echo "-----> Backing up to remote server INTERNAL hard drive"
    echo
    upload_with_skip_existing "$SOURCE_DIR/Documents/"            "$REMOTE_BK/Documents/"
    upload_with_skip_existing "$SOURCE_DIR/Dropbox/"              "$REMOTE_BK/Dropbox/"
    upload_with_skip_existing "$SOURCE_DIR/Desktop/"              "$REMOTE_BK/Desktop/"
    upload_with_skip_existing "$SOURCE_DIR/Pictures/"             "$REMOTE_BK/Pictures/"
    upload_with_skip_existing "$SOURCE_DIR/Music/"                "$REMOTE_BK/Music/"
    upload_with_skip_existing "$SOURCE_DIR/.config/"              "$REMOTE_BK/.config/"
    
    # backup calibre from external hd to server
    upload_with_skip_existing "$LOCAL_EXT/Calibre Library/"      "$REMOTE_BK/Calibre Library/" 
    
    # set proper ownership and permissions
    remote_command "chown -R www-data:www-data $REMOTE_BK"
    remote_command "chmod -R 750 $REMOTE_BK"
}

backup_local_external () {
    echo
    echo "-----> Backing up to local EXTERNAL hard drive"
    echo
    rsync -av --update "$SOURCE_DIR/Documents/"                  "$LOCAL_EXT/Documents/"
    rsync -av --update "$SOURCE_DIR/Dropbox/"                    "$LOCAL_EXT/Dropbox/"
    rsync -av --update "$SOURCE_DIR/Desktop/"                    "$LOCAL_EXT/Desktop/"
    rsync -av --update "$SOURCE_DIR/Pictures/"                   "$LOCAL_EXT/Pictures/"
    rsync -av --update "$SOURCE_DIR/Music/"                      "$LOCAL_EXT/Music/"
    rsync -av --update "$SOURCE_DIR/.config/"                    "$LOCAL_EXT/.config/"

}

check_and_create_lockfile
backup_folders_to_server_hd
backup_local_external
delete_lockfile

