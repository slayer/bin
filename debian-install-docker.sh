#!/bin/bash -e


PACKAGES="docker.io python-pip"

sudo apt-get -y install $PACKAGES
sudo apt-get clean


pip install docker-compose

echo "You can wish to modify /etc/docker/daemon.json:"
echo
echo '
{
  "bip": "172.17.0.1/16",
  "log-driver": "json-file",
  "log-opts": {"max-size": "5m", "max-file": 10},
  "storage-driver": "overlay"
}
'
