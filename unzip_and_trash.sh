#! /bin/bash
# Description: Script for unzipping multiple files in a directory
#				optionally use unzip_and_trash to delete archives
#               as they are succesfully unzipped.
# Author: Russell Loewe
# Date: February 2025


FOLDER='/media/russell/Untitled/test'

cd $FOLDER || exit 1

unzip_all () {
	find "$FOLDER" -type f -iname '*.zip' | while read -r FILE; do
		echo "Processing: $FILE"
		if unzip "$FILE" >/dev/null; then
			echo "Successfully unzipped"
		else
			echo "Failed to unzip: $FILE " >&2
		fi
	done
}

unzip_and_trash () {
	find "$FOLDER" -type f -iname '*.zip' | while read -r FILE; do
		echo "Processing: $FILE"
		if unzip "$FILE" >/dev/null; then
			echo "Successfully unzipped, deleting: $FILE"
			rm -- "$FILE"
		else
			echo "Failed to unzip: $FILE (file not deleted)" >&2
		fi
	done
}

# unzip_all
unzip_and_trash
