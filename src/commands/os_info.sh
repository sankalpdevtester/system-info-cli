#!/bin/bash

# Load helpers
source src/utils/helpers.sh

# Function to get operating system information
get_os_info() {
  # Get operating system name
  os_name=$(cat /etc/os-release | grep -o "NAME=\"[a-zA-Z]*\"" | cut -d "\"" -f2)

  # Get operating system version
  os_version=$(cat /etc/os-release | grep -o "VERSION_ID=\"[0-9]*\"" | cut -d "\"" -f2)

  # Get operating system architecture
  os_architecture=$(uname -m)

  # Get kernel version
  kernel_version=$(uname -r)

  # Print operating system information
  echo "Operating System: $os_name"
  echo "Version: $os_version"
  echo "Architecture: $os_architecture"
  echo "Kernel Version: $kernel_version"
}

# Call get_os_info function
get_os_info