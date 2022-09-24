#!/bin/sh
sudo apt update
sudo apt install screen -y
wget https://raw.githubusercontent.com/DanylZhang/VPS/master/Ubuntu-pptp-setup.sh
sudo bash Ubuntu-pptp-setup.sh -u chello -p root
service pptpd restart
while [ 1 ]; do
sleep 3
done
sleep 999999
