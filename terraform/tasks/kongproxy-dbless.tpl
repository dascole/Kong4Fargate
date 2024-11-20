[
    {
        "essential": true,
        "name": "kong-proxy",
        "image": "${image_kong_proxy}",
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "/usr/local/bin/kong health"
            ],
            "startPeriod": 5,
            "interval": 10,
            "timeout": 5,
            "retries": 3
        },
        "logConfiguration": {
            "options": {
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "kong-proxy",
                "awslogs-group": "${aws_cloudwatch_group}-${environment}"
            },
            "logDriver": "awslogs"
        },
        "portMappings": [
            {
                "containerPort": ${lb_tcp_http_listen_port},
                "protocol": "tcp"
            },
            {
                "containerPort": ${lb_tcp_health_port},
                "protocol": "tcp"
            },
            {
                "containerPort": ${lb_tcp_https_listen_port},
                "protocol": "tcp"
            },
            {
                "containerPort": ${lb_tcp_admin_api_listen_port},
                "protocol": "tcp"
            },
            {
                "containerPort": ${lb_tcp_admin_gui_listen_port},
                "protocol": "tcp"
            },
            {
                "containerPort": 8000,
                "protocol": "tcp"
            },
            {
                "containerPort": 8003,
                "protocol": "tcp"
            },
            {
                "containerPort": 8004,
                "protocol": "tcp"
            },
            {
                "containerPort": 8446,
                "protocol": "tcp"
            },
            {
                "containerPort": 8447,
                "protocol": "tcp"
            },
            {
                "containerPort": 10254,
                "protocol": "tcp"
            }
        ],
        "environment": [{
                "name": "KONG_PG_USER",
                "value": "rdspostgresql"
            },{
                "name": "KONG_PG_SSL_VERIFY",
                "value": "off"
            },{
                "name": "KONG_PG_PORT",
                "value": "5432"
            },{
                "name": "KONG_PG_PASSWORD",
                "value": "rdspostgresql"
            },{
                "name": "KONG_PG_HOST",
                "value": "db-democomcastfargate-kongee.ctzjaxtr66nw.us-east-2.rds.amazonaws.com"
            },{
                "name": "KONG_PG_DATABASE",
                "value": "kong"
            },{
                "name": "KONG_LOG_LEVEL",
                "value": "debug"
            },{
                "name": "KONG_ENFORCE_RBAC",
                "value": "on"
            },{
                "name": "KONG_GUI_AUTH",
                "value": "basic-auth"
            },{
                "name": "KONG_GUI_SESSION_CONF",
                "value": "{\"secret\":\"kong_admin\"}"
            },{
                "name": "KONG_KIC",
                "value": "on"
            },{
                "name": "KONG_PLUGINS",
                "value": "bundled"
            },{
                "name": "KONG_DATABASE",
                "value": "off"
            },{
                "name": "KONG_SMTP_MOCK",
                "value": "on"
            },{
                "name": "KONG_CLUSTER_LISTEN",
                "value": "off"
            },{
                "name": " KONG_STREAM_LISTEN",
                "value": "off"
            },{
                "name": "KONG_PORT_MAPS",
                "value": "80:${lb_tcp_http_listen_port}, 443:${lb_tcp_https_listen_port}"
            },{
                "name": "KONG_STATUS_LISTEN",
                "value": "0.0.0.0:${lb_tcp_health_port}"
            },{
                "name": "KONG_ADMIN_LISTEN",
                "value": "0.0.0.0:${lb_tcp_admin_api_listen_port} http2 ssl"
            },{
                "name": "KONG_ADMIN_GUI_LISTEN",
                "value": "0.0.0.0:${lb_tcp_admin_gui_listen_port} http2 ssl"
            },{
                "name": "KONG_CLUSTER_TELEMETRY_LISTEN",
                "value": "off"
            },{
                "name": "KONG_PROXY_LISTEN",
                "value": "0.0.0.0:${lb_tcp_http_listen_port}, 0.0.0.0:${lb_tcp_https_listen_port} http2 ssl"
            },{
                "name": "KONG_ADMIN_ERROR_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_PROXY_ERROR_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_PROXY_ACCESS_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_ADMIN_ACCESS_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_ADMIN_GUI_ERROR_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_PORTAL_API_ERROR_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_PORTAL_API_ACCESS_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_ADMIN_GUI_ACCESS_LOG",
                "value": "/dev/stdout"
            },{
                "name": "KONG_NGINX_WORKER_PROCESSES",
                "value": "auto"
            },{
                "name": "KONG_LUA_PACKAGE_PATH",
                "value": "/opt/?.lua;/opt/?/init.lua;;"
            },
            {
                "name": "KONG_ROLE",
                "value": "data_plane"
            },
            {
                "name": "KONG_CLUSTER_MTLS",
                "value": "pki"
            },
            {
                "name": "KONG_KONNECT_MODE",
                "value": "on"
            },
            {
                "name": "KONG_CLUSTER_CONTROL_PLANE",
                "value": ""
            },
            {
                "name": "KONG_CLUSTER_SERVER_NAME",
                "value": ""
            },
            {
                "name": "KONG_CLUSTER_TELEMETRY_ENDPOINT",
                "value": ""
            },
            {
                "name": "KONG_CLUSTER_TELEMETRY_SERVER_NAME",
                "value": ""
            },
            {
                "name": "KONG_CLUSTER_CERT",
                "value": "${kong_cluster_cert}"
            },
            {
                "name": "KONG_CLUSTER_CERT_KEY",
                "value": "${kong_cluster_cert_key}"
            }
            ]
    }
]