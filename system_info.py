#!/usr/bin/env python3
"""
System Information CLI Tool (Python version)
Cross-platform system information gathering tool
"""

import platform
import psutil
import socket
import datetime
from typing import Dict, List

class SystemInfo:
    """Collects and displays comprehensive system information"""
    
    def __init__(self):
        self.uname = platform.uname()
        
    def print_header(self, title: str):
        """Print formatted section header"""
        print(f"\n{'='*50}")
        print(f"  {title}")
        print('='*50)
    
    def print_info(self, label: str, value: str):
        """Print formatted key-value pair"""
        print(f"{label:.<30} {value}")
    
    def get_size(self, bytes: int, suffix: str = "B") -> str:
        """Convert bytes to human readable format"""
        factor = 1024
        for unit in ["", "K", "M", "G", "T", "P"]:
            if bytes < factor:
                return f"{bytes:.2f}{unit}{suffix}"
            bytes /= factor
    
    def show_os_info(self):
        """Display operating system information"""
        self.print_header("OPERATING SYSTEM")
        self.print_info("System", self.uname.system)
        self.print_info("Node Name", self.uname.node)
        self.print_info("Release", self.uname.release)
        self.print_info("Version", self.uname.version)
        self.print_info("Machine", self.uname.machine)
        self.print_info("Processor", self.uname.processor or platform.processor())
        
    def show_cpu_info(self):
        """Display CPU information"""
        self.print_header("CPU INFORMATION")
        self.print_info("Physical cores", str(psutil.cpu_count(logical=False)))
        self.print_info("Total cores", str(psutil.cpu_count(logical=True)))
        
        cpufreq = psutil.cpu_freq()
        if cpufreq:
            self.print_info("Max Frequency", f"{cpufreq.max:.2f}Mhz")
            self.print_info("Min Frequency", f"{cpufreq.min:.2f}Mhz")
            self.print_info("Current Frequency", f"{cpufreq.current:.2f}Mhz")
        
        self.print_info("CPU Usage", f"{psutil.cpu_percent(interval=1)}%")
        
        # Per-core usage
        print("\nPer-Core Usage:")
        for i, percentage in enumerate(psutil.cpu_percent(percpu=True, interval=1)):
            print(f"  Core {i}: {percentage}%")
    
    def show_memory_info(self):
        """Display memory information"""
        self.print_header("MEMORY INFORMATION")
        
        # RAM
        svmem = psutil.virtual_memory()
        self.print_info("Total", self.get_size(svmem.total))
        self.print_info("Available", self.get_size(svmem.available))
        self.print_info("Used", self.get_size(svmem.used))
        self.print_info("Percentage", f"{svmem.percent}%")
        
        # Swap
        print("\nSwap Memory:")
        swap = psutil.swap_memory()
        self.print_info("Total", self.get_size(swap.total))
        self.print_info("Free", self.get_size(swap.free))
        self.print_info("Used", self.get_size(swap.used))
        self.print_info("Percentage", f"{swap.percent}%")
    
    def show_disk_info(self):
        """Display disk information"""
        self.print_header("DISK INFORMATION")
        
        partitions = psutil.disk_partitions()
        for partition in partitions:
            print(f"\nDevice: {partition.device}")
            self.print_info("  Mountpoint", partition.mountpoint)
            self.print_info("  File system type", partition.fstype)
            
            try:
                partition_usage = psutil.disk_usage(partition.mountpoint)
                self.print_info("  Total Size", self.get_size(partition_usage.total))
                self.print_info("  Used", self.get_size(partition_usage.used))
                self.print_info("  Free", self.get_size(partition_usage.free))
                self.print_info("  Percentage", f"{partition_usage.percent}%")
            except PermissionError:
                print("  [Permission Denied]")
        
        # Disk I/O statistics
        disk_io = psutil.disk_io_counters()
        if disk_io:
            print("\nDisk I/O Statistics:")
            self.print_info("Total read", self.get_size(disk_io.read_bytes))
            self.print_info("Total write", self.get_size(disk_io.write_bytes))
    
    def show_network_info(self):
        """Display network information"""
        self.print_header("NETWORK INFORMATION")
        
        # Hostname and IP
        hostname = socket.gethostname()
        try:
            ip_address = socket.gethostbyname(hostname)
        except:
            ip_address = "Unable to get IP address"
        
        self.print_info("Hostname", hostname)
        self.print_info("IP Address", ip_address)
        
        # Network interfaces
        print("\nNetwork Interfaces:")
        if_addrs = psutil.net_if_addrs()
        for interface_name, interface_addresses in if_addrs.items():
            print(f"\n{interface_name}:")
            for address in interface_addresses:
                if str(address.family) == 'AddressFamily.AF_INET':
                    self.print_info("  IP Address", address.address)
                    self.print_info("  Netmask", address.netmask)
                elif str(address.family) == 'AddressFamily.AF_PACKET':
                    self.print_info("  MAC Address", address.address)
        
        # Network I/O statistics
        net_io = psutil.net_io_counters()
        print("\nNetwork I/O Statistics:")
        self.print_info("Bytes Sent", self.get_size(net_io.bytes_sent))
        self.print_info("Bytes Received", self.get_size(net_io.bytes_recv))
    
    def show_boot_time(self):
        """Display system boot time"""
        self.print_header("SYSTEM UPTIME")
        boot_time_timestamp = psutil.boot_time()
        boot_time = datetime.datetime.fromtimestamp(boot_time_timestamp)
        self.print_info("Boot Time", boot_time.strftime("%Y-%m-%d %H:%M:%S"))
        
        # Calculate uptime
        uptime = datetime.datetime.now() - boot_time
        self.print_info("Uptime", str(uptime).split('.')[0])
    
    def show_top_processes(self):
        """Display top processes by CPU and memory"""
        self.print_header("TOP PROCESSES")
        
        print("\nTop 5 by CPU:")
        processes = []
        for proc in psutil.process_iter(['pid', 'name', 'cpu_percent']):
            try:
                processes.append(proc.info)
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                pass
        
        top_cpu = sorted(processes, key=lambda x: x['cpu_percent'] or 0, reverse=True)[:5]
        for proc in top_cpu:
            print(f"  PID {proc['pid']}: {proc['name']} - {proc['cpu_percent']}%")
        
        print("\nTop 5 by Memory:")
        processes = []
        for proc in psutil.process_iter(['pid', 'name', 'memory_percent']):
            try:
                processes.append(proc.info)
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                pass
        
        top_mem = sorted(processes, key=lambda x: x['memory_percent'] or 0, reverse=True)[:5]
        for proc in top_mem:
            print(f"  PID {proc['pid']}: {proc['name']} - {proc['memory_percent']:.2f}%")
    
    def show_all(self):
        """Display all system information"""
        print("\n" + "="*50)
        print("    SYSTEM INFORMATION CLI TOOL")
        print("="*50)
        
        self.show_os_info()
        self.show_cpu_info()
        self.show_memory_info()
        self.show_disk_info()
        self.show_network_info()
        self.show_boot_time()
        self.show_top_processes()
        
        print("\n" + "="*50)
        print("  Scan complete!")
        print("="*50 + "\n")

def main():
    """Main entry point"""
    try:
        sys_info = SystemInfo()
        sys_info.show_all()
    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
