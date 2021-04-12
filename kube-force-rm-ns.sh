#!/bin/sh

NS=$1

if [ -z "$NS" ]; then
  echo "Usage: $0 <namespace>"
  exit 1;
fi

kubectl patch ns "${NS}" -p '{"spec":{"finalizers":null}}'

