#!/bin/bash
# Description: Delete "edited" photos in google takeout subfolders
# Author: Russell Loewe
# Date: Feb 2025

# Base folder to start searching from
BASE_FOLDER='/media/russell/Untitled/gooogle-data/Takeout/Google Photos'

# Find all files ending with -edited and supported extensions
find "$BASE_FOLDER" -type f \( -iname '*-edited.jpg' -o -iname '*-edited.jpeg' \) | while read -r EDITED_FILE; do
    # Get the directory of the file
    FOLDER=$(dirname "$EDITED_FILE")
    
    # Get the base filename without the -edited suffix and original extension
    BASE_FILE="${EDITED_FILE%-edited.*}"
    
    # Check if the original file exists with any supported extension
    if [[ -f "$BASE_FILE.jpg" || -f "$BASE_FILE.JPG" || -f "$BASE_FILE.jpeg" || -f "$BASE_FILE.JPEG" ]]; then
        echo "Found pair: $BASE_FILE and $EDITED_FILE"
        echo "Deleting: $EDITED_FILE"
        rm -- "$EDITED_FILE"
    fi
done
