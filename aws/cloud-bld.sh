#!/bin/bash
cd ~

if [ -f jc ]; then
 echo 'jc already exists!'
 #exit 1
fi

# install j
rm j9.4_linux64.tar.gz
wget -nv www.jsoftware.com/download/j9.4/install/j9.4_linux64.tar.gz
tar -zxf j9.4_linux64.tar.gz

# update j
rm jc
ln -s j9.4/bin/jconsole jc
./jc -js "load'pacman'" "'update'jpkg''" "'install'jpkg'all'" "exit''"

# put default self-signed certificates in .ssh
sudo cp j9.4/addons/ide/jhs/node/key.pem  .ssh
sudo cp j9.4/addons/ide/jhs/node/cert.pem .ssh
sudo chmod 644 .ssh/key.pem
sudo chmod 644 .ssh/cert.pem

# install nodejs
sudo yum -y install nodejs
echo `which node` > nodebin


