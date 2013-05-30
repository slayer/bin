#!/bin/sh -e

cd /tmp; rm -rf /tmp/fwlib
git clone https://github.com/slayer/fwlib.git
cd /tmp/fwlib
cp fwlib fw /etc/network


echo -n "Do you want to install fw symlink to /etc/rc2.d ? (y/any): "
if read a && [ "x$a" = "xy" ]; then
	cd /etc/rc2.d && ln -s /etc/network/fw S90fw
fi
