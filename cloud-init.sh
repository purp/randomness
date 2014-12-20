#!/bin/bash

# disable ssh passwords and restart sshd
sed -i -e 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && service sshd restart
# update system packages & install some things
yum update -y
yum groupinstall "Development Tools"
yum install bind-utils

# Set up non-root user
adduser purp --groups wheel --password '$1$JGqmDake$B8nv8GHvD5sPw92txYIe4/'
chage -d 0 purp
mkdir ~purp/.ssh && cp -p ~/.ssh/authorized_keys ~purp/.ssh/. && chown -R purp:purp ~purp/.ssh && chmod -R go-rwx ~purp/.ssh
