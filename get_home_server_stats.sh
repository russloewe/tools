#!/bin/bash
# Description: Gets system stats from remote server using ssh
#              Run with genmon panel widget 
# Author: Russell Loewe
# Date: 2024
# Notes: 1) assumes SSH keys are installed. if not run this command:
#        ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''
#        2) Troubleshooting: check lockfile

# Define variables
DRIVE_NAME=/dev/mapper/ubuntu--vg-ubuntu--lv
LOCKFILE="/tmp/my_stats_lockfile"
HOST=10.0.0.144

check_and_create_lockfile() {
  if [ -f "$LOCKFILE" ]; then
    exit 1
  else
    touch "$LOCKFILE"
  fi
}

delete_lockfile() {
  if [ -f "$LOCKFILE" ]; then
    rm "$LOCKFILE"
  fi
}

check_and_create_lockfile

# Fetch memory usage information via SSH and calculate used memory percentage
#MEMORY_USAGE=$(ssh root@$HOST 'free | grep Mem' | awk '{printf "%.2f", $3/$2 * 100}')

# Fetch load information via SSH and calculate remaining load percentage
LOAD_SIZE=$(ssh root@$HOST 'sar -u 1 3 | tail -n 1' | awk '{print $NF}')
if [ ${#LOAD_SIZE} -ge 1 ]; then
   LOAD_PERCENT=$(echo "100 - $LOAD_SIZE" | bc)
else
   LOAD_PERCENT="FAIL"
fi

# Fetch drive size information via SSH
DRIVE_SIZE=$(ssh root@$HOST "df -h" | grep $DRIVE_NAME | awk '{print $4}')

# Check if DRIVE_SIZE is less than one (empty or invalid)
if [ ${#DRIVE_SIZE} -lt 1 ]; then
    # Retry the command once more
    DRIVE_SIZE=$(ssh root@$HOST "df -h" | grep $DRIVE_NAME | awk '{print $4}')
fi

# Set DRIVE_AVAILABLE based on the final value of DRIVE_SIZE
if [ ${#DRIVE_SIZE} -ge 1 ]; then
   DRIVE_AVAILABLE=$DRIVE_SIZE
else
   DRIVE_AVAILABLE="FAIL"
fi

# Define fixed lengths for each substring
MEMORY_LENGTH=8
LOAD_LENGTH=9
DRIVE_LENGTH=9


# Display the combined information with fixed lengths

#printf "Mem: %-${MEMORY_LENGTH}s | Load: %-${LOAD_LENGTH}s | Drive: %-${DRIVE_LENGTH}s \n" \
       #"${MEMORY_USAGE}% " "${LOAD_PERCENT}%" "${DRIVE_AVAILABLE}" 

printf "| Load: %-${LOAD_LENGTH}s | Drive: %-${DRIVE_LENGTH}s \n" \
        "${LOAD_PERCENT}%" "${DRIVE_AVAILABLE}" 
       
delete_lockfile
