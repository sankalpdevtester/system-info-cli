#!/bin/bash

# Import helpers
source ../utils/helpers.sh

# Function to get disk information
get_disk_info() {
  # Get disk usage
  disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//g')

  # Get total disk space
  total_disk_space=$(df -h / | awk 'NR==2 {print $2}')

  # Get used disk space
  used_disk_space=$(df -h / | awk 'NR==2 {print $3}')

  # Get free disk space
  free_disk_space=$(df -h / | awk 'NR==2 {print $4}')

  # Print disk information
  echo "Disk Usage: $disk_usage%"
  echo "Total Disk Space: $total_disk_space"
  echo "Used Disk Space: $used_disk_space"
  echo "Free Disk Space: $free_disk_space"
}

# Function to handle disk information command
handle_disk_info() {
  # Check if command is valid
  if [ "$1" == "disk" ]; then
    get_disk_info
  else
    echo "Invalid command"
  fi
}

# Call handle_disk_info function
handle_disk_info "$1"