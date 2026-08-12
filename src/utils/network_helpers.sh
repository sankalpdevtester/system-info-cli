#!/bin/bash

# Function to get default gateway
get_default_gateway() {
  # Use ip route command to get default gateway
  default_gateway=$(ip route show default | grep -o "via [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | cut -d " " -f2)

  # Print default gateway
  echo "$default_gateway"
}

# Function to get DNS servers
get_dns_servers() {
  # Use resolvectl command to get DNS servers
  dns_servers=$(resolvectl status | grep -o "Current DNS Server: [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | cut -d ":" -f2-)

  # Print DNS servers
  echo "$dns_servers"
}

# Function to get network interface speeds
get_interface_speeds() {
  # Use ethtool command to get interface speeds
  interface_speeds=$(ethtool -i | grep -o "speed: [0-9]*" | cut -d ":" -f2-)

  # Print interface speeds
  echo "$interface_speeds"
}