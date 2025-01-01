#!/bin/sh

set -e

echo "Starting run.sh script..."
echo "Current user: $(whoami)"
echo "Current UID: $(id -u)"
echo "Current GID: $(id -g)"
echo "Home directory: $HOME"
echo "Working directory: $(pwd)"

echo "Waiting for database..."
python manage.py wait_for_db

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Running migrations..."
python manage.py migrate

echo "Starting Gunicorn on port ${LISTEN_PORT:-9000}..."
echo "Number of CPU cores: $(nproc)"
gunicorn --bind :${LISTEN_PORT:-9000} --workers 4 app.wsgi
