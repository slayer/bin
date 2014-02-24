#!/bin/sh

file=$1

certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n `basename $file` -i $file
