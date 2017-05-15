#!/bin/bash -e


PACKAGES="docker.io python-pip"

sudo apt-get -y install $PACKAGES
sudo apt-get clean


sudo pip install docker-compose

echo "You may wish to modify /etc/docker/daemon.json:"
echo 'tee -a <<END >/tmp/daemon.json
{
  "bip": "172.17.0.1/16",
  "log-driver": "json-file",
  "log-opts": {"max-size": "5m", "max-file": "10"},
  "storage-driver": "overlay",
  "iptables": false
}
END

# sudo mv /tmp/daemon.json /etc/docker/
sudo systemctl stop docker
# rm -rf /var/lib/docker
sudo systemctl start docker

sudo usermod -aG docker `whoami`

sudo sed -i 's/DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY="ACCEPT"' /etc/default/ufw
sudo ufw reload
'
