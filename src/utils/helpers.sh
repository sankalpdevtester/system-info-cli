#!/bin/bash

# Function to get CPU information
get_cpu_info() {
  cpu_info=$(cat /proc/cpuinfo)
  echo "$cpu_info"
}

# Function to get memory information
get_memory_info() {
  memory_info=$(cat /proc/meminfo)
  echo "$memory_info"
}

# Function to get disk information
get_disk_info() {
  disk_info=$(df -h)
  echo "$disk_info"
}

# Function to get operating system information
get_os_info() {
  os_info=$(cat /etc/os-release)
  echo "$os_info"
}

# Function to get network information
get_network_info() {
  network_info=$(ip addr show)
  echo "$network_info"
}

# Function to format system information
format_system_info() {
  cpu_info=$(get_cpu_info)
  memory_info=$(get_memory_info)
  disk_info=$(get_disk_info)
  os_info=$(get_os_info)
  network_info=$(get_network_info)

  echo "CPU Information:"
  echo "$cpu_info"
  echo ""
  echo "Memory Information:"
  echo "$memory_info"
  echo ""
  echo "Disk Information:"
  echo "$disk_info"
  echo ""
  echo "Operating System Information:"
  echo "$os_info"
  echo ""
  echo "Network Information:"
  echo "$network_info"
}

# Example usage
if [ "$0" = "$BASH_SOURCE" ]; then
  format_system_info
fi