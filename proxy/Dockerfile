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
    chmod -R 755 /vol && \
    chown -R nginx:nginx /vol && \
    chmod 755 /etc/nginx/conf.d && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chown nginx:nginx /etc/nginx/default.conf.tpl && \
    chown nginx:nginx /etc/nginx/gunicorn_headers && \
    chmod 644 /etc/nginx/default.conf.tpl && \
    chmod 644 /etc/nginx/gunicorn_headers && \
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    chmod 644 /etc/nginx/conf.d/default.conf && \
    chmod +x /run.sh && \
    # Verify permissions
    echo "Verifying nginx user and permissions:" && \
    id nginx && \
    ls -la /vol && \
    ls -la /etc/nginx/conf.d && \
    ls -la /etc/nginx

USER nginx

VOLUME /vol/static
VOLUME /vol/media

CMD ["/run.sh"]