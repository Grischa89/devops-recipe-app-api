server {
    listen ${LISTEN_PORT};

    # Increase header buffer size
    large_client_header_buffers 4 32k;
    client_header_buffer_size 32k;
    
    # Increase proxy buffer sizes
    proxy_buffer_size 128k;
    proxy_buffers 4 256k;
    proxy_busy_buffers_size 256k;

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
        
        # Simple proxy headers
        proxy_set_header    X-Real-IP $remote_addr;
        
        # Timeouts
        proxy_connect_timeout 600;
        proxy_send_timeout    600;
        proxy_read_timeout    600;
        send_timeout         600;
        
        client_max_body_size 10M;
    }

    # Handle favicon.ico separately
    location = /favicon.ico {
        return 204;
        access_log off;
        log_not_found off;
    }
}
