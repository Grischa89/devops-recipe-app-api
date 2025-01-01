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
# Create temp file in a directory we know we have write access to
TMP_CONF="/tmp/default.conf.tmp"
envsubst < /etc/nginx/default.conf.tpl > "$TMP_CONF"
# Use sudo to copy the file to its final location
if [ -w /etc/nginx/conf.d/default.conf ]; then
    mv "$TMP_CONF" /etc/nginx/conf.d/default.conf
else
    echo "Warning: Cannot write directly to nginx conf directory"
    cat "$TMP_CONF" > /etc/nginx/conf.d/default.conf
fi

echo "Nginx configuration:"
cat /etc/nginx/conf.d/default.conf

echo "Starting Nginx..."
nginx -g 'daemon off;'
