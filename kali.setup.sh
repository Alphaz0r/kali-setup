#!/bin/bash

# 1) Check if the script is launched with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with root privileges. Use sudo."
    exit 1
fi

# 4) apt-get update 
apt-get update

# 5) apt-get install -y feroxbuster terminator 
apt-get install -y feroxbuster terminator

# 6) Create a directory in /opt/ named "tools" and owned by user flo
mkdir -p /opt/tools
chown flo:flo /opt/tools

# 7) Download files into /opt/tools directory
cd /opt/tools
wget https://raw.githubusercontent.com/21y4d/nmapAutomator/master/nmapAutomator.sh 
wget https://github.com/carlospolop/PEASS-ng/releases/download/20240226-e0f9d47b/linpeas.sh
wget https://github.com/carlospolop/PEASS-ng/releases/download/20240226-e0f9d47b/winPEASany.exe
wget https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_windows_amd64.gz
wget https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz
wget https://github.com/int0x33/nc.exe/raw/master/nc64.exe
wget https://github.com/int0x33/nc.exe/raw/master/nc.exe

# 8) Change ownership of the entire /opt/tools directory to flo
chown -R flo:flo /opt/tools

# 9) mkdir /home/flo/Documents/HTB
mkdir -p /home/flo/Documents/HTB

# 10) mkdir /home/flo/Documents/THM
mkdir -p /home/flo/Documents/THM

# 11) Change ownership of the /home/flo/Documents directory to flo
chown -R flo:flo /home/flo/Documents

# 12) Change the keyboard layout to AZERTY (France) and make it permanent
echo 'XKBLAYOUT="fr"' >> /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration

# 13) Change the timezone to Paris
timedatectl set-timezone Europe/Paris

echo "Script execution completed."
