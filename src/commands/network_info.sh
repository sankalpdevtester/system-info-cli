#!/bin/bash

# Load helpers
source src/utils/helpers.sh

# Function to get network information
get_network_info() {
  # Get network interfaces
  interfaces=$(ip link show | grep -o "^[0-9]*:" | cut -d ":" -f1)

  # Initialize network info array
  declare -A network_info

  # Loop through each interface
  for interface in $interfaces; do
    # Get interface name
    interface_name=$(ip link show $interface | grep -o "^[0-9]*:" | cut -d ":" -f2-)

    # Get interface IP address
    ip_address=$(ip addr show $interface | grep -o "inet [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | cut -d " " -f2)

    # Get interface subnet mask
    subnet_mask=$(ip addr show $interface | grep -o "netmask [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | cut -d " " -f2)

    # Get interface broadcast address
    broadcast_address=$(ip addr show $interface | grep -o "broadcast [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | cut -d " " -f2)

    # Store interface information in array
    network_info[$interface_name]="IP Address: $ip_address, Subnet Mask: $subnet_mask, Broadcast Address: $broadcast_address"
  done

  # Print network information
  for interface in "${!network_info[@]}"; do
    echo "$interface: ${network_info[$interface]}"
  done
}

# Call get_network_info function
get_network_info