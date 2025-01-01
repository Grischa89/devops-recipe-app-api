#!/bin/sh

set -e

echo "Starting proxy run.sh script..."
echo "Current user: $(whoami)"
echo "Current UID: $(id -u)"
echo "Current GID: $(id -g)"
echo "Listing permissions of key directories:"
ls -la /vol/static
ls -la /etc/nginx/conf.d

echo "Generating Nginx configuration..."
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

echo "Nginx configuration:"
cat /etc/nginx/conf.d/default.conf

echo "Starting Nginx..."
nginx -g 'daemon off;'
