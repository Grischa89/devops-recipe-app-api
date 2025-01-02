#!/bin/sh

set -e

echo "Starting proxy run.sh script..."
echo "Current user: $(whoami)"
echo "Current UID: $(id -u)"
echo "Current GID: $(id -g)"
echo "Environment variables:"
echo "APP_HOST: ${APP_HOST}"
echo "APP_PORT: ${APP_PORT}"
echo "LISTEN_PORT: ${LISTEN_PORT}"

# Check DNS resolution
echo "Testing DNS resolution:"
nslookup ${APP_HOST} || echo "DNS lookup failed for ${APP_HOST}"

# Substitute environment variables in the Nginx configuration
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

echo "Final Nginx configuration:"
cat /etc/nginx/conf.d/default.conf || echo "Failed to read config"

echo "Starting Nginx..."
nginx -g 'daemon off;'
