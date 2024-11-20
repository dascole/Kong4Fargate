variable "name" {
    description = "Deployment Name"
    default = "kong4fargate"
}
variable "revision" {
    description = "Deployment Revision"
    default = "v00.07"
}
variable "env" {
    default = "prod"
}
variable "kong_proxy_type" {
    description = "Kong Proxy DB enabled or disabled"
    default = "dbless"
}
variable "image_kong_proxy" {
    description = "Kong Proxy Image"
    default = "kong/kong-gateway:2.4-alpine"
}
variable "additional_tags" {
    description = "Extra AWS Resource tags"
    default = { 
        "Name" : "Kong4Fargate",
        "Application" : "kong-api-gateway",
        "Environment" : "dev"
    }
}
variable "region" {
    description = "AWS Region"
    default = "us-east-2"
}
variable "capabilities" {
    description = "AWS Fargate Type | FARGATE, FARGATE_SPOT"
    default = "FARGATE"
}
variable "availability_zones" {
    description = "AWS VPC Availability Zones"
    default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
variable "aws_profile" {
    description = "AWS User Profile"
    default = "default"
}
variable "ecs_service_security_groups" {
    default = []
}
variable "cidr" {
    description = "AWS VPC Subnet Allocation"
    default = "192.19.0.0/16"
}
variable "public_subnets" {
    description = "Public | AWS Availability Zone Subnet CIDR List"
    default = ["192.19.0.0/24", "192.19.1.0/24", "192.19.2.0/24"]
}
variable "private_subnets" {
    description = "Private | AWS Availability Zone Subnet CIDR List"
    default = ["192.19.10.0/24", "192.19.11.0/24", "192.19.12.0/24"]
}
variable "aws_cloudwatch_group" {
    description = "AWS CloudWatch Group"
    default = "awslogs-fargate-kong"
}
variable "lb_tcp_health_port" {
    default = "8100"
}
variable "lb_tcp_http_listen_port" {
    default = "8080"
}
variable "lb_tcp_https_listen_port" {
    default = "8443"
}
variable "lb_tcp_admin_api_listen_port" {
    default = "8444"
}
variable "lb_tcp_admin_gui_listen_port" {
    default = "8445"
}
variable "kong_log_level" {
    default = "info"
}
/////
variable "kong_cluster_mtls" {
    default = "pki"
}
variable "kong_konnect_mode" {
    default = "on"
}
variable "kong_cluster_control_plane" {
    default = ""
}
variable "kong_cluster_server_name" {
    default = ""
}
variable "kong_cluster_telemetry_endpoint" {
    default = ""
}
variable "kong_cluster_telemetry_server_name" {
    default = ""
}
//////
variable "kong_role" {
    default = "data_plane"
}
variable "kong_pg_port" {
    default = "5432"
}
variable "kong_database" {
    default = "off"
}
variable "kong_pg_user" {
    default = "kong"
}
variable "kong_pg_host" {
    default = ""
}
variable "kong_pg_password" {
    default = "kong"
}
variable "kong_pg_database" {
    default = "kong"
}
variable "kong_pg_ssl_verify" {
    default = "on"
}
variable "rds_storage" {
    description = "Storage size for DB instance"
    default = 40
}
variable "rds_class" {
    description = "The instance type of the RDS instance"
    default = "db.t3.micro"
}
variable "rds_engine_version" {
    description = "DB Version"
    default = "10.19"
}
variable "rds_username" {
    description = "Username for the master DB user"
    default = "postgres"
}
variable "rds_password" {
    description = "Password for the master DB user"
    default = "kongstrong"
}
variable "rds_id" {
    description = "The name of the RDS instance"
    default = "kong-db-edu"
}
variable "rds_access" {
    description = "Bool to control if instance is publicly accessible"
    default = "true"
}
variable "kong_port_maps" {
    default = "80:8080, 443:8443"
}
variable "kong_admin_listen" {
    description = "Admin API listen port"
    default = "0.0.0.0:8444 http2 ssl"
}
variable "kong_status_listen" {
    description = "Status listen port"
    default = "0.0.0.0:8100"
}
variable "kong_proxy_listen" {
    description = "Proxy listen port"
    default = "0.0.0.0:8001, 0.0.0.0:8443 http2 ssl"
}
variable "kong_admin_error_log" {
    description = "Admin API error log location"
    default = "/dev/stderr"
}
variable "kong_proxy_error_log" {
    description = "Proxy error log location"
    default = "/dev/stderr"
}
variable "kong_proxy_access_log" {
    description = "Proxy access log location"
    default = "/dev/stdout"
}
variable "kong_admin_access_log" {
    description = "Admin API access log location"
    default = "/dev/stdout"
}
variable "kong_admin_gui_error_log" {
    description = "Admin GUI error log location"
    default = "/dev/stderr"
}
variable "kong_portal_api_error_log" {
    description = "Portal API error log location"
    default = "/dev/stderr"
}
variable "kong_portal_api_access_log" {
    description = "Portal API access log location"
    default = "/dev/stdout"
}
variable "kong_admin_gui_access_log" {
    description = "Admin GUI access log location"
    default = "/dev/stdout"
}
variable "kong_nginx_worker_procesess" {
    description = "Number of nginx worker processes"
    default = "auto"
}
variable "kong_lua_package_path" {
    description = "Sets the Lua module search path"
    default = "/opt/?.lua;/opt/?/init.lua;;"
}