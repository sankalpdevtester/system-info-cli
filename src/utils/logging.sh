#!/bin/bash

# Set log file and rotation settings
LOG_FILE="system_info.log"
LOG_ROTATION_SIZE=10 # in MB
LOG_ROTATION_COUNT=5

# Set log levels
LOG_LEVEL_DEBUG=0
LOG_LEVEL_INFO=1
LOG_LEVEL_WARN=2
LOG_LEVEL_ERROR=3
LOG_LEVEL_FATAL=4

# Set current log level
CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO

# Function to log messages
log_message() {
  local level=$1
  local message=$2

  if [ $level -ge $CURRENT_LOG_LEVEL ]; then
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local log_line="$timestamp [$level] $message"

    # Check if log file needs rotation
    if [ -f "$LOG_FILE" ]; then
      local log_size=$(stat -c%s "$LOG_FILE")
      if [ $log_size -gt $((LOG_ROTATION_SIZE * 1024 * 1024)) ]; then
        # Rotate log file
        for ((i=LOG_ROTATION_COUNT; i>0; i--)); do
          local old_log_file="$LOG_FILE.$i"
          local new_log_file="$LOG_FILE.$((i+1))"
          if [ -f "$old_log_file" ]; then
            mv "$old_log_file" "$new_log_file"
          fi
        done
        mv "$LOG_FILE" "$LOG_FILE.1"
      fi
    fi

    # Append log message to file
    echo "$log_line" >> "$LOG_FILE"
  fi
}

# Function to log debug messages
log_debug() {
  log_message $LOG_LEVEL_DEBUG "$1"
}

# Function to log info messages
log_info() {
  log_message $LOG_LEVEL_INFO "$1"
}

# Function to log warn messages
log_warn() {
  log_message $LOG_LEVEL_WARN "$1"
}

# Function to log error messages
log_error() {
  log_message $LOG_LEVEL_ERROR "$1"
}

# Function to log fatal messages
log_fatal() {
  log_message $LOG_LEVEL_FATAL "$1"
}

# Example usage:
# log_debug "This is a debug message"
# log_info "This is an info message"
# log_warn "This is a warn message"
# log_error "This is an error message"
# log_fatal "This is a fatal message"