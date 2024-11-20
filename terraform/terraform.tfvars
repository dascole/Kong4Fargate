// ----------------------------------------------------------------------
//  Metadata
// ----------------------------------------------------------------------

name                 = "Kong4Fargate"
revision             = "v00.07.24"
aws_profile          = "saml"
env                  = "dev"
additional_tags      = { 
    Name : "Kong4Fargate",
    ownerName : "lnajd",
    Application : "kong-api-gateway",
    Revision    : "v00.07.23"
    Environment : "dev"
}


// ----------------------------------------------------------------------
// Kong Configuration
// ----------------------------------------------------------------------

kong_proxy_type      = "dbless"                                          // supported: dbless,  dbfull
//image_kong_proxy     = "quay.io/containercraft/kong:b64lsup-a02-d9eccaa" // testing base64 encoded license support
image_kong_proxy     = "docker.io/kong/kong-gateway:3.8.0.0"
kong_log_level       = "debug"
kong_pg_port         = "5432"
# kong_database        = "postgres"
kong_pg_user         = ""
kong_pg_password     = ""
kong_pg_database     = ""
kong_pg_ssl_verify   = ""
kong_role             = "data_plane"
kong_database         = "off"
kong_cluster_mtls     = "pki"
kong_konnect_mode     = "on"
kong_cluster_control_plane = ""
kong_cluster_server_name = ""
kong_cluster_telemetry_endpoint = ""
kong_cluster_telemetry_server_name = ""


// ----------------------------------------------------------------------
//  AWS Configuration
// ----------------------------------------------------------------------

// AWS Region & Zones
region               = "us-east-2"
availability_zones   = ["us-east-2a", "us-east-2b", "us-east-2c"]
capabilities         = "FARGATE"        // supported: FARGATE, FARGATE_SPOT

// VPC CIDRs
cidr                 = "192.19.0.0/16"
public_subnets       = ["192.19.11.0/24", "192.19.12.0/24", "192.19.13.0/24"]
private_subnets      = ["192.19.21.0/24", "192.19.22.0/24", "192.19.23.0/24"]
