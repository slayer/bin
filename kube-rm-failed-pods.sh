#!/bin/sh

# kubectl get po --all-namespaces --field-selector 'status.phase==Evicted' -o json
kubectl get po --all-namespaces --field-selector 'status.phase==Failed' -o json | kubectl delete -f -
