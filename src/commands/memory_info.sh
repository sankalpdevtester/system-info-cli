#!/bin/bash

# Import helpers
source ../utils/helpers.sh

# Function to get memory information
get_memory_info() {
  # Get total memory
  total_memory=$(grep "MemTotal" /proc/meminfo | awk '{print $2}' | xargs)

  # Get free memory
  free_memory=$(grep "MemFree" /proc/meminfo | awk '{print $2}' | xargs)

  # Get used memory
  used_memory=$((total_memory - free_memory))

  # Calculate memory usage percentage
  memory_usage_percentage=$((used_memory * 100 / total_memory))

  # Print memory information
  echo "Total Memory: $total_memory KB"
  echo "Free Memory: $free_memory KB"
  echo "Used Memory: $used_memory KB"
  echo "Memory Usage: $memory_usage_percentage%"
}

# Function to handle memory information command
handle_memory_info() {
  # Check if command is valid
  if [ "$1" == "memory" ]; then
    get_memory_info
  else
    echo "Invalid command"
  fi
}

# Call handle_memory_info function
handle_memory_info "$1"