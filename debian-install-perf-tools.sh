#!/bin/sh

sudo apt-get install -y atop htop iotop
sudo apt-get install -y powertop itop

# Networking
sudo apt-get install -y iftop nethogs iptstate iptraf
sudo apt-get install -y dnstop jnettop


# Perf
sudo apt-get install -y linux-tools-common linux-tools-`uname -r`
# perf record -a -g sleep 10  # record system for 10s
# perf report --sort comm,dso # display report

# App
sudo apt-get install -y apachetop

# sudo apt-get install -y kerneltop
# sudo apt-get install -y ptop # postgresql
# sudo apt-get install -y mytop # mysql

sudo apt-get clean
