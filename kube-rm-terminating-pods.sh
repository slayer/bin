#!/bin/sh

kubectl get pod -A | grep Terminating | while read ns pod qqq; do
  kubectl delete pod -n $ns $pod --grace-period=0 --force;
done
