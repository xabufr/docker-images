#!/bin/bash
set -e

SECRET_BASE=ssl-secret
SECRET_NAME=$SECRET_BASE-$(date '+%s')

OLD_SECRET_NAME=$(kubectl get secret -l "name=$SECRET_BASE" --template="{{.metadata.name}}")
if ! kubectl get secret "$OLD_SECRET_NAME"; then
    OLD_SECRET_NAME=""
fi

SECRET_NAME="$OLD_SECRET_NAME" /reverse-proxy-deployment.yml.sh
if kubectl get -f /reverse-proxy-deployment.yml; then
    kubectl apply -f /reverse-proxy-deployment.yml
    sleep 15
else
    kubectl create -f /reverse-proxy-deployment.yml
    sleep 30
fi

if [ "$DEBUG" ]; then
    TEST_CERT="--test-cert"
fi
/letsencrypt.ini.sh
/letsencrypt/letsencrypt-auto certonly --config /letsencrypt.ini --agree-tos $TEST_CERT --renew-by-default
ROOT=/etc/letsencrypt/live/*/
kubectl create secret generic $SECRET_NAME --from-file $ROOT/fullchain.pem --from-file $ROOT/privkey.pem
kubectl label secret "$SECRET_NAME" "name=$SECRET_BASE"

if [ "$OLD_SECRET_NAME" ]; then
    kubectl delete secret "$OLD_SECRET_NAME"
fi

SECRET_NAME="$SECRET_NAME" /reverse-proxy-deployment.yml.sh
kubectl apply -f /reverse-proxy-deployment.yml
