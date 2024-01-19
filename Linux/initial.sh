#!/bin/bash

#Initial Linux Script


#Lock root account and change administrator password
sudo passwd -l root
passwd $(whoami)

# Disables the ability to load new modules
sysctl -w kernel.modules_disabled=1
echo 'kernel.modules_disabled=1' > /etc/sysctl.conf

sudo sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
