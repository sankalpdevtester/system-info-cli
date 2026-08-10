#!/bin/bash

# Function to display CPU information
display_cpu_info() {
  echo "CPU Information:"
  echo "Model: $(cat /proc/cpuinfo | grep 'model name' | head -n 1 | cut -d ':' -f 2-)"
  echo "Number of Cores: $(cat /proc/cpuinfo | grep 'cpu cores' | head -n 1 | cut -d ':' -f 2-)"
  echo "CPU Frequency: $(cat /proc/cpuinfo | grep 'cpu MHz' | head -n 1 | cut -d ':' -f 2-)"
}

# Function to display Memory information
display_memory_info() {
  echo "Memory Information:"
  echo "Total Memory: $(free -h | grep 'Mem:' | awk '{print $2}')"
  echo "Used Memory: $(free -h | grep 'Mem:' | awk '{print $3}')"
  echo "Available Memory: $(free -h | grep 'Mem:' | awk '{print $7}')"
}

# Function to display Disk information
display_disk_info() {
  echo "Disk Information:"
  echo "Total Disk Space: $(df -h | grep '/dev/sda1' | awk '{print $2}')"
  echo "Used Disk Space: $(df -h | grep '/dev/sda1' | awk '{print $3}')"
  echo "Available Disk Space: $(df -h | grep '/dev/sda1' | awk '{print $4}')"
}

# Function to display Network information
display_network_info() {
  echo "Network Information:"
  echo "IP Address: $(hostname -I)"
  echo "Hostname: $(hostname)"
}

# Function to display Operating System information
display_os_info() {
  echo "Operating System Information:"
  echo "OS Name: $(cat /etc/os-release | grep 'NAME=' | cut -d '=' -f 2-)"
  echo "OS Version: $(cat /etc/os-release | grep 'VERSION_ID=' | cut -d '=' -f 2-)"
}

# Main function
main() {
  display_cpu_info
  echo ""
  display_memory_info
  echo ""
  display_disk_info
  echo ""
  display_network_info
  echo ""
  display_os_info
}

# Call the main function
main