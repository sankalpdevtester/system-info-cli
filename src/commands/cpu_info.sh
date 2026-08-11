#!/bin/bash

# Import helpers
source ../utils/helpers.sh

# Function to get CPU information
get_cpu_info() {
  # Get CPU model
  cpu_model=$(grep "model name" /proc/cpuinfo | awk -F: '{print $2}' | head -1 | xargs)

  # Get CPU cores
  cpu_cores=$(grep "cpu cores" /proc/cpuinfo | awk -F: '{print $2}' | head -1 | xargs)

  # Get CPU threads
  cpu_threads=$(grep "siblings" /proc/cpuinfo | awk -F: '{print $2}' | head -1 | xargs)

  # Print CPU information
  echo "CPU Model: $cpu_model"
  echo "CPU Cores: $cpu_cores"
  echo "CPU Threads: $cpu_threads"
}

# Function to handle CPU information command
handle_cpu_info() {
  # Check if command is valid
  if [ "$1" == "cpu" ]; then
    get_cpu_info
  else
    echo "Invalid command"
  fi
}

# Call handle_cpu_info function
handle_cpu_info "$1"