#!/bin/sh

set -e

echo "Starting Gunicorn on port ${LISTEN_PORT:-9000}..."
echo "Number of CPU cores: $(nproc)"
gunicorn --bind 0.0.0.0:${LISTEN_PORT:-9000} --workers 4 app.wsgi
