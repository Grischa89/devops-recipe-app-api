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
# Create temp file in /tmp directory
TMP_CONF="/tmp/default.conf"
envsubst < /etc/nginx/default.conf.tpl > "$TMP_CONF"

# Try to copy the file using cat redirection
if [ -w /etc/nginx/conf.d/default.conf ]; then
    echo "Writing config directly..."
    cat "$TMP_CONF" > /etc/nginx/conf.d/default.conf
else
    echo "Using alternative write method..."
    # Try to write to the file descriptor instead
    echo "$(cat $TMP_CONF)" > /proc/self/fd/1
    echo "$(cat $TMP_CONF)" > /etc/nginx/conf.d/default.conf
fi

echo "Nginx configuration:"
cat /etc/nginx/conf.d/default.conf || echo "Failed to read config"

echo "Starting Nginx..."
nginx -g 'daemon off;'
