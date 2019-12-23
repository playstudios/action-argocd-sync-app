#!/bin/sh -l

set -e

echo "==> Fetching argocd cli..."
curl -sSL -o /usr/local/bin/argocd https://${ARGOCD_SERVER}/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

echo "==> Syncing app..."
argocd app sync $1 --grpc-web

echo "==> Waiting for app to become healthy..."
argocd app wait $1 --grpc-web

echo "==> Generating app env url output..."
env_url=$(argocd app get $1 --grpc-web -o json | jq -r '.status.summary.externalURLs | sort_by(length) | .[0]')
echo "::set-output name=env_url::${env_url}"
