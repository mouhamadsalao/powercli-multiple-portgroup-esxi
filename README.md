# VMware ESXi Port Group Creation Script

![VMware](https://img.shields.io/badge/VMware-ESXi-159ced)
![PowerCLI](https://img.shields.io/badge/PowerCLI-Script-orange)
![License](https://img.shields.io/badge/license-MIT-green)

This PowerShell script simplifies the process of creating multiple port groups on VMware ESXi hosts using VMware's PowerCLI. It's a handy tool for VMware administrators and DevOps teams who manage networking in their virtualized environments.

## Features

- Create multiple port groups on one or more ESXi hosts.
- Configure the necessary settings for each port group, such as VLAN, vSwitch, and more.
- Easily customizable for your specific networking requirements.

## Prerequisites

- VMware PowerCLI must be installed on your system. You can download it from [VMware's official website](https://developer.vmware.com/powercli/).
- Access to your VMware ESXi host(s) with appropriate permissions.
- PowerShell 5.1 or later.

## Installation

1. Clone or download this repository to your local machine.
2. Open a PowerShell session and navigate to the project directory.

## Usage

1. Open a PowerShell terminal.
2. Navigate to the project directory.
3. Create a csv file(semi-colon separation) with two rows named: portgroup and vlan
4. Run the script using the following command:

   ```powershell
   ./Create-PortGroups.ps1
