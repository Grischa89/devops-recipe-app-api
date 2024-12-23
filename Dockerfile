FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED 1

# Create system user first, before any other operations
RUN set -ex && \
    addgroup -S -g 1000 django-user && \
    adduser -S -u 1000 -G django-user -h /home/django-user django-user && \
    mkdir -p /vol/web/media /vol/web/static /vol/tmp && \
    chown -R django-user:django-user /vol

COPY --chown=django-user:django-user ./requirements.txt /tmp/requirements.txt
COPY --chown=django-user:django-user ./requirements.dev.txt /tmp/requirements.dev.txt
COPY --chown=django-user:django-user ./scripts /scripts
COPY --chown=django-user:django-user ./app /app
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
    chown -R django-user:django-user /py && \
    chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER django-user

# Define volumes after setting permissions
VOLUME ["/vol/web/static", "/vol/web/media", "/vol/tmp"]

CMD ["run.sh"]
