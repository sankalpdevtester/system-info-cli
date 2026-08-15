#!/bin/bash

# Cache directory
CACHE_DIR="/tmp/system_info_cache"

# Cache expiration time in seconds
CACHE_TTL=300

# Function to get cache file path
get_cache_file_path() {
  local key="$1"
  echo "${CACHE_DIR}/${key}.cache"
}

# Function to set cache
set_cache() {
  local key="$1"
  local value="$2"
  local cache_file_path=$(get_cache_file_path "$key")
  echo "$value" > "$cache_file_path"
  touch -d "+${CACHE_TTL} seconds" "$cache_file_path"
}

# Function to get cache
get_cache() {
  local key="$1"
  local cache_file_path=$(get_cache_file_path "$key")
  if [ -f "$cache_file_path" ]; then
    local modification_time=$(stat -c "%Y" "$cache_file_path")
    if [ $(( $(date +%s) - modification_time )) -lt $CACHE_TTL ]; then
      cat "$cache_file_path"
      return
    fi
  fi
  return 1
}

# Function to clear cache
clear_cache() {
  local key="$1"
  local cache_file_path=$(get_cache_file_path "$key")
  if [ -f "$cache_file_path" ]; then
    rm "$cache_file_path"
  fi
}

# Function to cache system info responses
cache_system_info() {
  local command="$1"
  local key="${command}_$(hostname)"
  if get_cache "$key"; then
    echo "Using cached response for $command"
    get_cache "$key"
  else
    local output
    case "$command" in
      cpu_info)
        output=$($src/commands/cpu_info.sh)
        ;;
      memory_info)
        output=$($src/commands/memory_info.sh)
        ;;
      disk_info)
        output=$($src/commands/disk_info.sh)
        ;;
      network_info)
        output=$($src/commands/network_info.sh)
        ;;
      os_info)
        output=$($src/commands/os_info.sh)
        ;;
    esac
    set_cache "$key" "$output"
    echo "$output"
  fi
}

# Example usage
if [ "$0" = "$BASH_SOURCE" ]; then
  cache_system_info "cpu_info"
  cache_system_info "memory_info"
  cache_system_info "disk_info"
  cache_system_info "network_info"
  cache_system_info "os_info"
fi