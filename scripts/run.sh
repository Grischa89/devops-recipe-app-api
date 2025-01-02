#!/bin/sh

set -e

python manage.py wait_for_db
python manage.py migrate
python manage.py collectstatic --noinput
gunicorn app.wsgi:application --bind 0.0.0.0:9000
