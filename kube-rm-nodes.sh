#!/bin/sh

nodes=$@

for node in ${nodes}; do
  kubectl cordon ${node}
done

for node in ${nodes}; do
  kubectl drain --delete-local-data --ignore-daemonsets ${node}
done

for node in ${nodes}; do
  kubectl delete node ${node}
done
