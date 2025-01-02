server {
    listen ${LISTEN_PORT};

    # Debug log the environment variables and DNS settings
    error_log /dev/stdout debug;
    access_log /dev/stdout combined;

    # Print environment variables for debugging
    set $debug_dns_server ${DNS_SERVER};
    set $debug_app_host ${APP_HOST};
    set $debug_app_port ${APP_PORT};

    # Use DNS_SERVER from environment with fallback
    resolver ${DNS_SERVER:-127.0.0.11} valid=5s ipv6=off;
    
    # Set upstream variables with proper variable names
    set $upstream_host ${APP_HOST};
    set $upstream_port ${APP_PORT};

    # Log DNS resolution attempts
    log_format debug_dns '$time_local [$level] '
                        'DNS_SERVER="$debug_dns_server" '
                        'APP_HOST="$debug_app_host" '
                        'APP_PORT="$debug_app_port" '
                        'upstream="$upstream_host:$upstream_port" '
                        'host=$host '
                        'upstream_addr="$upstream_addr"';
    access_log /dev/stdout debug_dns;

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
        
        # Add debug headers to see what's being passed
        add_header X-Debug-Host $upstream_host always;
        add_header X-Debug-Port $upstream_port always;
        add_header X-Debug-Resolver $debug_dns_server always;

        proxy_pass          http://$upstream_host:$upstream_port;
        
        # Log upstream connection attempts
        error_log /dev/stdout debug;
        
        client_max_body_size 10M;
    }

    location = /favicon.ico {
        return 204;
        access_log off;
        log_not_found off;
    }
}
