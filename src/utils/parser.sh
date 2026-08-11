#!/bin/bash

# Function to parse command-line arguments
parse_args() {
  # Check if command is provided
  if [ -z "$1" ]; then
    echo "Error: Command not provided"
    exit 1
  fi

  # Check if command is valid
  case "$1" in
    cpu)
      source ../commands/cpu_info.sh
      handle_cpu_info "$1"
      ;;
    memory)
      source ../commands/memory_info.sh
      handle_memory_info "$1"
      ;;
    disk)
      source ../commands/disk_info.sh
      handle_disk_info "$1"
      ;;
    *)
      echo "Error: Invalid command"
      exit 1
      ;;
  esac
}

# Call parse_args function
parse_args "$1"