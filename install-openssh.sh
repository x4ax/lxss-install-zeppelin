#!/usr/bin/env bash

#==============================================================================
# Author: x4ax (Sergey Axenov)
# 
# Reinstalls openssh server in Linux Subsystem on Windows 10
#
# Note: requires sudo
#
# - Uninstalls current openssh-server
# - Installs openssh-server
# - Changes /etc/ssh/sshd_config
#    UsePrivilegeSeparation no
#    PermitRootLogin no
#    AllowUsers $runninguser
#    PasswordAuthentication yes
# - Restarts ssh server
# - Enable ssh autostart
#
#==============================================================================

sudo apt-get purge openssh-server
sudo apt-get install openssh-server
runninguser=$(whoami)

sshdconf="/etc/ssh/sshd_config"
echo "Setting [UsePrivilegeSeparation no] in $sshdconf"
sudo sed -i.bak '/UsePrivilegeSeparation/c\UsePrivilegeSeparation no' "$sshdconf"
echo "Setting [PermitRootLogin no] in $sshdconf"
sudo sed -i '/PermitRootLogin/c\PermitRootLogin no' "$sshdconf"

echo "Setting [AllowUsers $runninguser] in $sshdconf"
sudo sed -i "/PermitRootLogin no/a AllowUsers $runninguser" "$sshdconf"

echo "Setting [PasswordAuthentication yes] in $sshdconf"
sudo sed -i '/PasswordAuthentication/c\PasswordAuthentication yes' "$sshdconf"

sudo service ssh --full-restart
sudo systemctl enable ssh

