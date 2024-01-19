#!/bin/bash
# Initial Linux Script

# Disables the ability to load new modules
sysctl -w kernel.modules_disabled=1
echo 'kernel.modules_disabled=1' > /etc/sysctl.conf

# Edit sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
#Enable public key authentication
sudo systemctl restart sshd

# Check for NOPASSWD in sudoers
NOPASSWD_CHECK= $(sudo grep -n NOPASSWD /etc/sudoers)
if [ "$NOPASSWD_CHECK" != "" ]; then
    sudo visudo
fi

# Create and copy original files
sudo find / -perm /6000 > setxid.orig
sudo cp /etc/passwd passwd.orig
sudo cp /etc/group group.orig
sudo cp /etc/sudoers sudoers.orig
sudo cp /etc/ssh/sshd_config sshd_config.orig
sudo cp /root/.ssh/authorized_keys root_authorized_keys.orig
sudo cp ~/.ssh/authorized_keys $(whoami)_authorized_keys.orig
sudo systemctl list-unit-files --type=service --state=enabled --no-pager > enabled_services.orig
sudo tar -cvf backup.tar *.orig
chattr +i *.orig

# Lock root account and change administrator password
sudo passwd -l root
passwd $(whoami)


