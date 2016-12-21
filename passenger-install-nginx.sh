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

if [ ! -f /etc/init.d/nginx ]; then
cat <<\END >/etc/init.d/nginx
#!/bin/sh

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

PATH=/opt/nginx/sbin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/nginx/sbin/nginx
NAME=nginx
DESC=nginx
PIDFILE=/var/run/nginx.pid

test -x $DAEMON || exit 0

# Include nginx defaults if available
if [ -f /etc/default/nginx ] ; then
        . /etc/default/nginx
fi

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        start-stop-daemon --start --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --pidfile $PIDFILE
        echo "$NAME."
        ;;
  restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec $DAEMON
        sleep 1
        start-stop-daemon --start --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  reload)
          echo -n "Reloading $DESC configuration: "
          start-stop-daemon --stop --signal HUP --quiet --pidfile $PIDFILE
          echo "$NAME."
          ;;
      *)
            N=/etc/init.d/$NAME
            echo "Usage: $N {start|stop|restart|reload|force-reload}" >&2
            exit 1
            ;;
    esac

    exit 0
END
  chmod a+x /etc/init.d/nginx
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
     /etc/init.d/nginx reload >/dev/null 2>&1 || true
  endscript
}
END
fi

