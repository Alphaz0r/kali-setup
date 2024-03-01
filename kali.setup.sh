#!/bin/bash

# 1. Check if the script is launched with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with root privileges. Use sudo."
    exit 1
fi

# Ask for the username
read -p "Enter the username: " username

# Check if the user exists
if id "$username" >/dev/null 2>&1; then
    echo "User $username exists. Using existing user."
else
    # Create the user with a password
    useradd -m -s /bin/bash -p "$(openssl passwd -1)" "$username"
    echo "User $username created."
fi

# 4. apt-get update 
apt-get update

# 5. apt-get install -y feroxbuster terminator 
apt-get install -y feroxbuster terminator

# 6. Create a directory in /opt/ named "tools" and owned by the specified user
mkdir -p /opt/tools
chown "$username":"$username" /opt/tools

# 7. Download files into /opt/tools directory using curl
cd /opt/tools
curl -O https://raw.githubusercontent.com/21y4d/nmapAutomator/master/nmapAutomator.sh 
curl -LO https://github.com/carlospolop/PEASS-ng/releases/download/20240226-e0f9d47b/linpeas.sh
curl -LO https://github.com/carlospolop/PEASS-ng/releases/download/20240226-e0f9d47b/winPEASany.exe
curl -LO https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_windows_amd64.gz
curl -LO https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz
curl -LO https://github.com/int0x33/nc.exe/raw/master/nc64.exe
curl -LO https://github.com/int0x33/nc.exe/raw/master/nc.exe

# 7a. Extract chisel for Linux
gunzip chisel_1.9.1_linux_amd64.gz

# 7b. Extract chisel for Windows
gunzip chisel_1.9.1_windows_amd64.gz

# 7c. Remove the compressed files
rm chisel_1.9.1_linux_amd64.gz chisel_1.9.1_windows_amd64.gz

# 8. Change permissions and ownership of the entire /opt/tools directory to the specified user
chmod +x linpeas.sh nmapAutomator.sh
chown -R "$username":"$username" /opt/tools

# 9. mkdir /home/$USER/Documents/HTB
mkdir -p /home/"$username"/Documents/HTB

# 10. mkdir /home/$USER/Documents/THM
mkdir -p /home/"$username"/Documents/THM

# 11. Change ownership of the /home/$USER/Documents directory to the specified user
chown -R "$username":"$username" /home/"$username"/Documents

# 12. Change the keyboard layout to AZERTY (France) and make it permanent
echo 'XKBLAYOUT="fr"' >> /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration

# 13. Change the timezone to Paris
timedatectl set-timezone Europe/Paris

# 14. Additional command: su -l $USER -c '/usr/bin/pip install pwncat-cs'
su -l "$username" -c '/usr/bin/pip install pwncat-cs'

echo "Script execution completed."
