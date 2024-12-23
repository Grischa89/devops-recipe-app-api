FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="londonappdeveloper.com"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./gunicorn_headers /etc/nginx/gunicorn_headers
COPY ./run.sh /run.sh

ENV LISTEN_PORT=8000
ENV APP_HOST=app
ENV APP_PORT=9000

USER root

RUN mkdir -p /vol/static && \
    mkdir -p /vol/media && \
    chmod -R 755 /vol && \
    chown -R django-user:django-user /vol && \
    mkdir -p /etc/nginx/conf.d && \
    chown -R django-user:nginx /etc/nginx/conf.d && \
    touch /etc/nginx/conf.d/default.conf && \
    chown django-user:nginx /etc/nginx/conf.d/default.conf && \
    chmod 664 /etc/nginx/conf.d/default.conf && \
    chmod +x /run.sh

USER django-user

VOLUME /vol/static
VOLUME /vol/media

CMD ["/run.sh"]
