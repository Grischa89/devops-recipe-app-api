server {
    listen ${LISTEN_PORT};

    # Debug log the environment variables
    error_log /dev/stdout debug;
    access_log /dev/stdout combined;

    # Add resolver for ECS service discovery
    resolver ${DNS_SERVER} valid=10s ipv6=off;
    set $upstream_host ${APP_HOST};
    set $upstream_port ${APP_PORT};

    # Enhanced logging format to debug DNS resolution
    log_format debug_format '$time_local [$level] '
                          'upstream="$upstream_host:$upstream_port" '
                          'resolver="$resolver" '
                          'host=$host '
                          'request="$request" '
                          'upstream_addr="$upstream_addr" '
                          'upstream_status="$upstream_status"';
    access_log /dev/stdout debug_format;

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
        
        # Enhanced debug headers
        add_header X-Debug-Host $upstream_host always;
        add_header X-Debug-Port $upstream_port always;
        add_header X-Debug-Resolver $resolver always;
        add_header X-Debug-Upstream-Addr $upstream_addr always;

        # Log attempt before proxy pass
        error_log /dev/stdout debug;
        
        proxy_pass          http://$upstream_host:$upstream_port;
        
        # Log after proxy pass
        add_header X-Upstream-Status $upstream_status always;
        
        client_max_body_size 10M;
    }

    location = /favicon.ico {
        return 204;
        access_log off;
        log_not_found off;
    }
}
