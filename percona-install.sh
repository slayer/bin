#!/bin/sh


echo "## Percona" >>/etc/apt/sources.list
echo "deb http://repo.percona.com/apt raring main" >>/etc/apt/sources.list

gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
gpg -a --export CD2EFD2A | sudo apt-key add -

sudo apt-get update
sudo apt-get install percona-server-server-5.5 percona-server-client libmysqlclient-dev libmysqlclient18

