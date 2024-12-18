FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED 1

# Create system user first, before any other operations
RUN set -ex && \
    addgroup -S -g 1000 appgroup && \
    adduser -S -u 1000 -G appgroup -h /home/appuser appuser && \
    mkdir -p /vol/web/media /vol/web/static /vol/tmp && \
    chown -R appuser:appgroup /vol

COPY --chown=appuser:appgroup ./requirements.txt /tmp/requirements.txt
COPY --chown=appuser:appgroup ./requirements.dev.txt /tmp/requirements.dev.txt
COPY --chown=appuser:appgroup ./scripts /scripts
COPY --chown=appuser:appgroup ./app /app
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
    chown -R appuser:appgroup /py && \
    chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER appuser

# Define volumes after setting permissions
VOLUME ["/vol/web/static", "/vol/web/media", "/vol/tmp"]

CMD ["run.sh"]
