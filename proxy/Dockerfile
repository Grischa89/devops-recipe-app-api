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
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/run && \
    # Set more permissive permissions for ECS
    chmod 777 /vol && \
    chmod 777 /vol/static && \
    chmod 777 /vol/media && \
    chmod 777 /etc/nginx && \
    chmod 777 /var/cache/nginx && \
    chmod 777 /var/run && \
    chmod +x /run.sh

USER nginx

# Remove VOLUME declarations as ECS handles this
# VOLUME /vol/static
# VOLUME /vol/media

CMD ["/run.sh"]