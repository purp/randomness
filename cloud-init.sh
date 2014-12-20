#!/bin/bash

# disable ssh passwords and restart sshd
sed -i -e 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && service sshd restart
# update system packages & install some things
yum update -y
yum groupinstall "Development Tools"
yum install bind-utils

# Install rbenv and ruby-build for all users a la http://blakewilliams.me/blog/system-wide-rbenv-install
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
chgrp -R staff rbenv
chmod -R g+rwxXs rbenv

cat <<RBENV_SH
export RBENV_ROOT=/usr/local/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"
RBENV_SH > /etc/profile.d/rbenv.sh

cd /usr/local/rbenv
mkdir plugins
cd plugins
git clone git://github.com/sstephenson/ruby-build.git
chgrp -R staff ruby-build
chmod -R g+rwxs ruby-build



# Set up non-root user
adduser purp --groups wheel --password '$1$JGqmDake$B8nv8GHvD5sPw92txYIe4/'
chage -d 0 purp
mkdir ~purp/.ssh && cp -p ~/.ssh/authorized_keys ~purp/.ssh/. && chown -R purp:purp ~purp/.ssh && chmod -R go-rwx ~purp/.ssh
