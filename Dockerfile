FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED 1

ARG UID=1000
ARG GID=1000

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    echo "Creating django-user..." && \
    addgroup -g $GID django-group && \
    adduser -u $UID -G django-group -D -h /home/django-user django-user && \
    echo "Creating directories..." && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    mkdir -p /tmp && \
    echo "Setting ownership..." && \
    chown -R django-user:django-group /vol && \
    chown -R django-user:django-group /tmp && \
    chown -R django-user:django-group /home/django-user && \
    chown -R django-user:django-group /scripts && \
    echo "Setting permissions..." && \
    chmod -R 755 /vol && \
    chmod -R 755 /tmp && \
    chmod -R +x /scripts/* && \
    echo "Verifying directories and permissions:" && \
    ls -la /scripts && \
    ls -la /scripts/* && \
    echo "Verifying user and permissions:" && \
    id django-user && \
    ls -la /vol/web && \
    ls -la /tmp && \
    ls -la /home/django-user

ENV PATH="/scripts:/py/bin:$PATH"

USER django-user

# Add verification of environment after user switch
RUN echo "Verifying environment as django-user:" && \
    echo "Current user: $(whoami)" && \
    echo "Current UID: $(id -u)" && \
    echo "Current GID: $(id -g)" && \
    echo "Home directory: $HOME" && \
    echo "PATH: $PATH" && \
    echo "Python location: $(which python)" && \
    python --version && \
    # Verify scripts directory and run.sh
    echo "Verifying scripts access:" && \
    ls -la /scripts && \
    ls -la /scripts/* && \
    which run.sh

VOLUME ["/vol/web/media", "/vol/web/static", "/tmp"]

CMD ["run.sh"]