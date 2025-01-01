server {
    listen ${LISTEN_PORT};

    location /static/static {
        alias /vol/static;
    }

    location /static/media {
        alias /vol/media;
    }

    location / {
        include              gunicorn_headers;
        proxy_redirect       off;
        proxy_pass          http://127.0.0.1:${APP_PORT};
        client_max_body_size 10M;
    }
}
