#!/bin/sh

file=$1

if [ ! -x  `which certutil` ]; then
  echo "please install libnss3-tools"
  exit 1
fi

certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n `basename $file` -i $file
