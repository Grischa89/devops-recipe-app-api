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
    chmod -R 755 /vol && \
    chown -R nginx:nginx /vol && \
    chmod -R 755 /etc/nginx && \
    chown -R nginx:nginx /etc/nginx && \
    chmod -R 755 /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx && \
    chmod -R 755 /var/run && \
    chown -R nginx:nginx /var/run && \
    chmod +x /run.sh && \
    # Create a writable temp directory for nginx user
    mkdir -p /tmp/nginx && \
    chown -R nginx:nginx /tmp/nginx && \
    chmod -R 755 /tmp/nginx && \
    # Verify permissions
    echo "Verifying nginx user and permissions:" && \
    id nginx && \
    ls -la /vol && \
    ls -la /etc/nginx/conf.d && \
    ls -la /etc/nginx && \
    ls -la /tmp/nginx && \
    ls -la /var/cache/nginx && \
    ls -la /var/run

USER nginx

VOLUME /vol/static
VOLUME /vol/media

CMD ["/run.sh"]