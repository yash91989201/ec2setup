#!/bin/bash
# Author: Yashraj Jaiswal
# Description: ec2 initial setup
# Updated On: 09/08/2023

sudo hostnamectl set-hostname "$1"

echo "root:root" | sudo chpasswd
echo "ubuntu:ubuntu" | sudo chpasswd

sudo echo -e "ClientAliveInterval 60\nClientAliveCountMax 3" >> /etc/ssh/sshd_config
sudo echo -e "PasswordAuthentication yes\nPermitRootLogin yes" >> /etc/ssh/sshd_config

sudo reboot


