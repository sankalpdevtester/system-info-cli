#!/bin/bash

# System Information CLI Tool
# A comprehensive system information gathering script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

# Function to print key-value pairs
print_info() {
    echo -e "${GREEN}$1:${NC} $2"
}

# Banner
echo -e "${BLUE}"
cat << "EOF"
 ____            _                   ___        __       
/ ___| _   _ ___| |_ ___ _ __ ___   |_ _|_ __  / _| ___  
\___ \| | | / __| __/ _ \ '_ ` _ \   | || '_ \| |_ / _ \ 
 ___) | |_| \__ \ ||  __/ | | | | |  | || | | |  _| (_) |
|____/ \__, |___/\__\___|_| |_| |_| |___|_| |_|_|  \___/ 
       |___/                                              
EOF
echo -e "${NC}"

# Operating System Information
print_header "OPERATING SYSTEM"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    print_info "OS Name" "$NAME"
    print_info "OS Version" "$VERSION"
    print_info "OS ID" "$ID"
    print_info "Kernel" "$(uname -r)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    print_info "OS Name" "macOS"
    print_info "OS Version" "$(sw_vers -productVersion)"
    print_info "Kernel" "$(uname -r)"
else
    print_info "OS" "$(uname -s)"
    print_info "Kernel" "$(uname -r)"
fi
print_info "Architecture" "$(uname -m)"
print_info "Hostname" "$(hostname)"

# CPU Information
print_header "CPU INFORMATION"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cpu_model=$(lscpu | grep "Model name" | cut -d ':' -f2 | xargs)
    cpu_cores=$(lscpu | grep "^CPU(s):" | cut -d ':' -f2 | xargs)
    cpu_threads=$(lscpu | grep "Thread(s) per core" | cut -d ':' -f2 | xargs)
    cpu_freq=$(lscpu | grep "CPU MHz" | cut -d ':' -f2 | xargs)
    
    print_info "Model" "$cpu_model"
    print_info "Cores" "$cpu_cores"
    print_info "Threads per core" "$cpu_threads"
    print_info "Current Frequency" "${cpu_freq} MHz"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cpu_model=$(sysctl -n machdep.cpu.brand_string)
    cpu_cores=$(sysctl -n hw.physicalcpu)
    cpu_threads=$(sysctl -n hw.logicalcpu)
    
    print_info "Model" "$cpu_model"
    print_info "Physical Cores" "$cpu_cores"
    print_info "Logical Cores" "$cpu_threads"
fi

# Memory Information
print_header "MEMORY INFORMATION"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    total_mem=$(free -h | awk '/^Mem:/ {print $2}')
    used_mem=$(free -h | awk '/^Mem:/ {print $3}')
    free_mem=$(free -h | awk '/^Mem:/ {print $4}')
    available_mem=$(free -h | awk '/^Mem:/ {print $7}')
    
    print_info "Total Memory" "$total_mem"
    print_info "Used Memory" "$used_mem"
    print_info "Free Memory" "$free_mem"
    print_info "Available Memory" "$available_mem"
    
    # Memory usage percentage
    mem_percent=$(free | awk '/^Mem:/ {printf("%.2f%%", $3/$2 * 100.0)}')
    print_info "Memory Usage" "$mem_percent"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    total_mem=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024 " GB"}')
    print_info "Total Memory" "$total_mem"
fi

# Disk Information
print_header "DISK INFORMATION"
echo ""
df -h | grep -E '^/dev/' | awk '{printf "%-20s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5}' | while read line; do
    echo -e "${YELLOW}$line${NC}"
done

# Network Information
print_header "NETWORK INFORMATION"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Get all network interfaces
    interfaces=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo)
    
    for iface in $interfaces; do
        echo -e "\n${YELLOW}Interface: $iface${NC}"
        
        # Get IP address
        ip_addr=$(ip addr show $iface | grep "inet " | awk '{print $2}' | cut -d/ -f1)
        if [ -n "$ip_addr" ]; then
            print_info "  IP Address" "$ip_addr"
        fi
        
        # Get MAC address
        mac_addr=$(ip link show $iface | awk '/link\/ether/ {print $2}')
        if [ -n "$mac_addr" ]; then
            print_info "  MAC Address" "$mac_addr"
        fi
        
        # Get state
        state=$(ip link show $iface | grep -oP 'state \K\w+')
        print_info "  State" "$state"
    done
elif [[ "$OSTYPE" == "darwin"* ]]; then
    interfaces=$(networksetup -listallhardwareports | grep "Device:" | awk '{print $2}')
    
    for iface in $interfaces; do
        echo -e "\n${YELLOW}Interface: $iface${NC}"
        
        ip_addr=$(ifconfig $iface | grep "inet " | awk '{print $2}')
        if [ -n "$ip_addr" ]; then
            print_info "  IP Address" "$ip_addr"
        fi
        
        mac_addr=$(ifconfig $iface | grep "ether " | awk '{print $2}')
        if [ -n "$mac_addr" ]; then
            print_info "  MAC Address" "$mac_addr"
        fi
    done
fi

# Uptime
print_header "SYSTEM UPTIME"
print_info "Uptime" "$(uptime -p 2>/dev/null || uptime)"

# Load Average
print_header "LOAD AVERAGE"
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    print_info "Load Average" "$load_avg"
fi

# Top Processes by CPU
print_header "TOP 5 PROCESSES BY CPU"
echo ""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ps aux --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "%-10s %-6s %-6s %s\n", $1, $2, $3, $11}' | while read line; do
        echo -e "${YELLOW}$line${NC}"
    done
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ps aux -r | head -n 6 | tail -n 5 | awk '{printf "%-10s %-6s %-6s %s\n", $1, $2, $3, $11}' | while read line; do
        echo -e "${YELLOW}$line${NC}"
    done
fi

# Top Processes by Memory
print_header "TOP 5 PROCESSES BY MEMORY"
echo ""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ps aux --sort=-%mem | head -n 6 | tail -n 5 | awk '{printf "%-10s %-6s %-6s %s\n", $1, $2, $4, $11}' | while read line; do
        echo -e "${YELLOW}$line${NC}"
    done
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ps aux -m | head -n 6 | tail -n 5 | awk '{printf "%-10s %-6s %-6s %s\n", $1, $2, $4, $11}' | while read line; do
        echo -e "${YELLOW}$line${NC}"
    done
fi

# System Summary
print_header "QUICK SUMMARY"
echo ""
echo -e "${GREEN}✓${NC} System scan complete!"
echo -e "${GREEN}✓${NC} All information gathered successfully"
echo ""
