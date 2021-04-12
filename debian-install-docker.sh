#!/bin/bash -e


sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo apt clean

# sudo apt install -y python-pip3
# sudo pip install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


exit 0

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

sudo sed -i s/DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY="ACCEPT"/ /etc/default/ufw

# /etc/ufw/before.rules
sudo tee -a /etc/ufw/before.rules <<NATRULE

*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -o docker0 -s 172.16.0.0/12 -j MASQUERADE
COMMIT
NATRULE


sudo ufw reload
'
