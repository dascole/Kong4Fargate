[
  {
    "essential": false,
    "name": "kong-db-task-bootstrap",
    "image": "kong/kong-gateway:latest",
    "entrypoint": [
      "/docker-entrypoint.sh"
    ],
    "command": [
      "kong",
      "migrations",
      "bootstrap"
    ],
 "healthCheck": {"command": ["CMD-SHELL","ping","google.com"],
    "startPeriod": 5,
    "interval": 10,
    "timeout": 5,
    "retries": 3
  },
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_group}-${environment}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "kong-proxy"
      }
    },
    "environment": [
      {
        "name": "KONG_LICENSE_DATA_B64",
        "value": "${kong_license_base64}"
      },
      {
        "name": "KONG_PG_USER",
        "value": "${kong_pg_user}"
      },
      {
        "name": "KONG_PG_SSL_VERIFY",
        "value": "${kong_pg_ssl_verify}"
      },
      {
        "name": "KONG_PG_PORT",
        "value": "${kong_pg_port}"
      },
      {
        "name": "KONG_PG_HOST",
        "value": "${kong_pg_host}"
      },
      {
        "name": "KONG_PG_PASSWORD",
        "value": "${kong_pg_password}"
      },
      {
        "name": "KONG_PG_DATABASE",
        "value": "${kong_pg_database}"
      },
      {
        "name": "KONG_DATABASE",
        "value": "${kong_database}"
      },

      {
        "name": "KONG_PORT_MAPS",
        "value": "${kong_port_maps}"
      },
      {
        "name": "KONG_ADMIN_LISTEN",
        "value": "${kong_admin_listen}"
      },
      {
        "name": "KONG_STATUS_LISTEN",
        "value": "${kong_status_listen}"
      },
      {
       "name": "KONG_PROXY_LISTEN",
        "value": "${kong_proxy_listen}"
      },
      {
        "name": "KONG_ADMIN_ERROR_LOG",
        "value": "${kong_admin_error_log}"
      },
      {
        "name": "KONG_PROXY_ERROR_LOG",
        "value": "${kong_proxy_error_log}"
      },
      {
        "name": "KONG_PROXY_ACCESS_LOG",
        "value": "${kong_proxy_access_log}"
      },
      {
        "name": "KONG_ADMIN_ACCESS_LOG",
        "value": "${kong_admin_access_log}"
      },
      {
        "name": "KONG_ADMIN_GUI_ERROR_LOG",
        "value": "${kong_admin_gui_error_log}"
      },
      {
        "name": "KONG_PORTAL_API_ERROR_LOG",
        "value": "${kong_portal_api_error_log}"
      },
      {
        "name": "KONG_PORTAL_API_ACCESS_LOG",
        "value": "${kong_portal_api_access_log}"
      },
      {
        "name": "KONG_ADMIN_GUI_ACCESS_LOG",
        "value": "${kong_admin_gui_access_log}"
      },
      {
        "name": "KONG_NGINX_WORKER_PROCESSES",
        "value": "${kong_nginx_worker_procesess}"
      },
      {
        "name": "KONG_LUA_PACKAGE_PATH",
        "value": "${kong_lua_package_path}"
      }
    ]

  },
  {
    "environment": [
      {
        "name": "KONG_LICENSE_DATA_B64",
        "value": "${kong_license_base64}"
      },
      {
        "name": "KONG_PG_USER",
        "value": "${kong_pg_user}"
      },
      {
        "name": "KONG_PG_SSL_VERIFY",
        "value": "${kong_pg_ssl_verify}"
      },
      {
        "name": "KONG_PG_PORT",
        "value": "${kong_pg_port}"
      },
      {
        "name": "KONG_PG_HOST",
        "value": "${kong_pg_host}"
      },
      {
        "name": "KONG_PG_PASSWORD",
        "value": "${kong_pg_password}"
      },
      {
        "name": "KONG_PG_DATABASE",
        "value": "${kong_pg_database}"
      },
      {
        "name": "KONG_DATABASE",
        "value": "${kong_database}"
      },
      {
        "name": "KONG_KIC",
        "value": "off"
      },
      {
        "name": "KONG_PORT_MAPS",
        "value": "${kong_port_maps}"
      },
      {
        "name": "KONG_ADMIN_LISTEN",
        "value": "${kong_admin_listen}"
      },
      {
        "name": "KONG_STATUS_LISTEN",
        "value": "${kong_status_listen}"
      },
      {
        "name": "KONG_PROXY_LISTEN",
        "value": "${kong_proxy_listen}"
      },
      {
        "name": "KONG_ADMIN_ERROR_LOG",
        "value": "${kong_admin_error_log}"
      },
      {
        "name": "KONG_PROXY_ERROR_LOG",
        "value": "${kong_proxy_error_log}"
      },
      {
        "name": "KONG_PROXY_ACCESS_LOG",
        "value": "${kong_proxy_error_log}"
      },
      {
        "name": "KONG_ADMIN_ACCESS_LOG",
        "value": "${kong_admin_access_log}"
      },
      {
        "name": "KONG_ADMIN_GUI_ERROR_LOG",
        "value": "${kong_admin_gui_error_log}"
      },
      {
        "name": "KONG_PORTAL_API_ERROR_LOG",
        "value": "${kong_portal_api_error_log}"
      },
      {
        "name": "KONG_PORTAL_API_ACCESS_LOG",
        "value": "${kong_portal_api_access_log}"
      },
      {
        "name": "KONG_ADMIN_GUI_ACCESS_LOG",
        "value": "${kong_admin_gui_access_log}"
      },
      {
        "name": "KONG_NGINX_WORKER_PROCESSES",
        "value": "${kong_nginx_worker_procesess}"
      },
      {
        "name": "KONG_LUA_PACKAGE_PATH",
        "value": "${kong_lua_package_path}"
      }
    ],
    "essential": true,
    "image": "kong/kong-gateway:latest",
    "name": "kong-proxy",
    "entrypoint": [
      "/docker-entrypoint.sh"
    ],
            "command": [
            "kong",
            "docker-start"
        ],

  "healthCheck": {
  "command": ["CMD-SHELL","/usr/local/bin/kong health"],
    "startPeriod": 5,
    "interval": 10,
    "timeout": 5,
    "retries": 3
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
            }]
  }
]