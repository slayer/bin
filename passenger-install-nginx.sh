#!/bin/bash -x
set -e

gem install passenger
rbenv rehash
passenger-install-nginx-module --extra-configure-flags="--with-http_gzip_static_module --with-http_stub_status_module --with-ipv6 --with-http_realip_module"

if [ ! -d /etc/nginx ]; then
	mv /opt/nginx/conf /etc/nginx
	ln -sf /etc/nginx /opt/nginx/conf
fi

mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled

if [ ! -d /var/log/nginx ]; then
	mv /opt/nginx/logs /var/log/nginx
	ln -sf /var/log/nginx /opt/nginx/logs
fi


if ! grep "^pid" /etc/nginx/nginx.conf >/dev/null 2>&1; then
	echo "pid        /var/run/nginx.pid;" >>/etc/nginx/nginx.conf
fi

if [ ! -f /etc/systemd/system/nginx.service ]; then
cat <<\END >/etc/systemd/system/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/opt/nginx/sbin/nginx -t
ExecStart=/opt/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
END
fi


if [ ! -f /etc/logrotate.d/nginx ]; then
cat <<\END >/etc/logrotate.d/nginx
/var/log/nginx/*
{
  minsize 50M
  rotate 30
  daily
  missingok
  notifempty
  delaycompress
  compress
  postrotate
     /opt/nginx/sbin/nginx -s reload >/dev/null 2>&1 || true
  endscript
}
END
fi

