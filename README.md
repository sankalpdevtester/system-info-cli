# System Information CLI Tool
[![Language](https://img.shields.io/badge/Language-Bash-blue)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-MIT-green)](https://opensource.org/licenses/MIT)

## What it does
The System Information CLI Tool is a command-line utility that provides detailed information about a system's hardware and software configuration. It is designed to be useful for system administrators and developers who need to quickly gather information about a system. The tool provides a comprehensive overview of the system's CPU, memory, disk, network, and operating system.

## Features
* CPU information: architecture, model, number of cores, and clock speed
* Memory information: total memory, available memory, and memory usage
* Disk information: total disk space, available disk space, and disk usage
* Network information: IP address, subnet mask, and default gateway
* Operating System information: name, version, and kernel version

## Requirements
The System Information CLI Tool requires the following:
* Bash 4.0 or later
* GNU coreutils 8.23 or later
* Linux kernel 3.10 or later

## Installation
To install the System Information CLI Tool, follow these steps:
```bash
wget https://raw.githubusercontent.com/user/system_info/master/system_info.sh
chmod +x system_info.sh
```

## Usage
To use the System Information CLI Tool, simply run the script:
```bash
./system_info.sh
```
This will display a detailed report of the system's hardware and software configuration. For example:
```
CPU Information:
  Architecture: x86_64
  Model: Intel Core i7
  Number of Cores: 4
  Clock Speed: 2.5 GHz

Memory Information:
  Total Memory: 16 GB
  Available Memory: 8 GB
  Memory Usage: 50%

Disk Information:
  Total Disk Space: 1 TB
  Available Disk Space: 500 GB
  Disk Usage: 50%

Network Information:
  IP Address: 192.168.1.100
  Subnet Mask: 255.255.255.0
  Default Gateway: 192.168.1.1

Operating System Information:
  Name: Ubuntu
  Version: 20.04
  Kernel Version: 5.4.0-42-generic
```

## Environment Variables
The System Information CLI Tool uses the following environment variables:
| Variable | Description |
| --- | --- |
| `LANG` | The language to use for the report |
| `LC_ALL` | The locale to use for the report |
| `PATH` | The path to the system's executable files |

## Project Structure
The System Information CLI Tool has the following project structure:
```
system_info
├── system_info.sh
├── README.md
└── LICENSE
```

## Contributing
To contribute to the System Information CLI Tool, please fork the repository and submit a pull request. All contributions are welcome, including bug fixes, new features, and documentation improvements.

## License
The System Information CLI Tool is licensed under the MIT License. See the LICENSE file for details.