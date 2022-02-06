// ----------------------------------------------------------------------
//  Metadata
// ----------------------------------------------------------------------

name                 = "Kong4Fargate"
revision             = "v00.07.24"
aws_profile          = "default"
env                  = "dev"
additional_tags      = { 
    Name : "Kong4Fargate",
    ownerName : "jdasc",
    Application : "kong-api-gateway",
    Revision    : "v00.07.23"
    Environment : "dev"
}


// ----------------------------------------------------------------------
// Kong Configuration
// ----------------------------------------------------------------------

kong_proxy_type      = "dbfull"                                          // supported: dbless,  dbfull
image_kong_proxy     = "quay.io/containercraft/kong:b64lsup-a02-d9eccaa" // testing base64 encoded license support
#image_kong_proxy     = "docker.io/kong/kong-gateway:2.4-alpine"
kong_log_level       = "debug"
kong_pg_port         = "5432"
kong_database        = "postgres"
kong_pg_user         = "postgres"
kong_pg_password     = "kongstrong"
kong_pg_database     = "kong"
kong_pg_ssl_verify   = "off"



// ----------------------------------------------------------------------
//  AWS Configuration
// ----------------------------------------------------------------------

// AWS Region & Zones
region               = "us-east-1"
availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
capabilities         = "FARGATE"        // supported: FARGATE, FARGATE_SPOT

// VPC CIDRs
cidr                 = "192.19.0.0/16"
public_subnets       = ["192.19.11.0/24", "192.19.12.0/24", "192.19.13.0/24"]
private_subnets      = ["192.19.21.0/24", "192.19.22.0/24", "192.19.23.0/24"]
