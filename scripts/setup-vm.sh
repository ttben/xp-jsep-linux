#!/bin/bash

sudo apt update
suo apt upgrade
sudo apt install -yy && \
debconf-utils dpkg-dev debhelper build-essential && \
libncurses5-dev libssl-dev bison flex libelf-dev coccinelle git && \
htop iotop

cd
git clone https://github.com/torvalds/linux.git
chmod u+x run-xps.sh
./run-xps.sh
