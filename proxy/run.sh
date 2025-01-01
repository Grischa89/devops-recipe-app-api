#!/bin/sh

set -e

echo "Starting proxy run.sh script..."
echo "Current user: $(whoami)"
echo "Current UID: $(id -u)"
echo "Current GID: $(id -g)"
echo "Listing permissions of key directories:"
ls -la /vol/static
ls -la /etc/nginx/conf.d
ls -la /var/cache/nginx
ls -la /var/run

echo "Generating Nginx configuration..."
# Create temp file in nginx temp directory
TMP_CONF="/tmp/nginx/default.conf"
envsubst < /etc/nginx/default.conf.tpl > "$TMP_CONF"

echo "Generated configuration:"
cat "$TMP_CONF"

echo "Copying configuration..."
cp "$TMP_CONF" /etc/nginx/conf.d/default.conf

echo "Final Nginx configuration:"
cat /etc/nginx/conf.d/default.conf || echo "Failed to read config"

echo "Starting Nginx..."
nginx -g 'daemon off;'
