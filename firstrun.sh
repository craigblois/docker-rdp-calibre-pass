#!/bin/bash

mkdir -p /config/config
ln -s /config/config /nobody/.config/calibre
chown -R nobody:users /config
chmod -R g+rw /config

if [ ! "$EDGE" = "1" ]; then
  echo "EDGE not requested, keeping stable version"
else
  echo "EDGE requested, updating to latest version"
  wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
fi

if [ -z "$LIBRARYINTERNALPATH" ]; then
  LIBRARYINTERNALPATH=/config
fi

if [ -z "$USERNAME" ]; then
  USERNAME=calibre
fi

if [ -z "$PASSWORD" ]; then
  PASSWORD=
fi

if [ -z "$URLPREFIX" ]; then
  URLPREFIX=
fi

/sbin/setuser nobody calibre-server --with-library=$LIBRARYINTERNALPATH --port 8081 --url-prefix=$URLPREFIX --username=$USERNAME --password=$PASSWORD --daemonize &
