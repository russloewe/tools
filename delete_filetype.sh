#!/bin/bash
# Description: Delete all JSON files in subfolders
# Author: Russell Loewe
# Date: Feb 2025


FTYPE='*.json'  
BASE_FOLDER='/media/russell/Untitled/gooogle-data/Takeout/Google Photos'

# Check if the provided base folder exists
if [ ! -d "$BASE_FOLDER" ]; then
    echo "Error: The folder '$BASE_FOLDER' does not exist." >&2
    exit 1
fi

# Find and delete all files matching the file type in the base folder and its subfolders
find "$BASE_FOLDER" -type f -name "$FTYPE" -print -delete
