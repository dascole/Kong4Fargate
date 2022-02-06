locals {
  kong_license_base64  = base64encode(file("${path.module}/license"))
  kong_license_file  = jsonencode(file("${path.module}/license"))
}


// ---------------------------------------------------------
// Create a RDS Postgres Instance
// ---------------------------------------------------------
resource "aws_db_instance" "kongdb" {
  allocated_storage    = "${var.rds_storage}"
  engine               = "postgres"
  engine_version       = "${var.rds_engine_version}"
  instance_class       = "${var.rds_class}"
  name                 = "kong"
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
  skip_final_snapshot  = true
  identifier           = "${var.rds_id}"
  publicly_accessible  = "${var.rds_access}"
}


// ---------------------------------------------------------
// HTTP TCP Trafic | map:80:8080
// ---------------------------------------------------------
resource "aws_lb_listener" "kong_http" {
  port     = 80
  protocol = "TCP"
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kong_http.arn
  }
  depends_on = [aws_lb_target_group.kong_http]
}
resource "aws_lb_target_group" "kong_http" {
  name            = "${var.name}-${var.env}-tcp-http"
  tags            = var.additional_tags
  vpc_id          = aws_vpc.main.id
  port            = var.lb_tcp_http_listen_port
  protocol        = "TCP"
  target_type     = "ip"
  health_check {
    port                = var.lb_tcp_health_port
    enabled             = true
    protocol            = "TCP"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  depends_on      = [aws_lb.main]
}


// ---------------------------------------------------------
// HTTPS TCP Trafic | map:443:8443
// ---------------------------------------------------------
resource "aws_lb_listener" "kong_https" {
  port     = 443
  protocol = "TCP"
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kong_https.arn
  }
  depends_on = [aws_lb_target_group.kong_https]
}
resource "aws_lb_target_group" "kong_https" {
  name            = "${var.name}-${var.env}-tcp-https"
  tags            = var.additional_tags
  vpc_id          = aws_vpc.main.id
  port            = var.lb_tcp_https_listen_port
  protocol        = "TCP"
  target_type     = "ip"
  health_check {
    port                = var.lb_tcp_health_port
    protocol            = "TCP"
    enabled             = true
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  depends_on      = [aws_lb.main]
}


// ---------------------------------------------------------
// Kong Admin API TCP Trafic
// ---------------------------------------------------------
resource "aws_lb_listener" "kong_admin_api" {
  port     = var.lb_tcp_admin_api_listen_port
  protocol = "TCP"
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kong_admin_api.arn
  }
  depends_on = [aws_lb_listener.kong_admin_api]
}
resource "aws_lb_target_group" "kong_admin_api" {
  name            = "${var.name}-${var.env}-tcp-admin-api"
  tags            = var.additional_tags
  vpc_id          = aws_vpc.main.id
  port            = var.lb_tcp_admin_api_listen_port
  protocol        = "TCP"
  target_type     = "ip"
  health_check {
    port                = var.lb_tcp_health_port
    protocol            = "TCP"
    enabled             = true
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  depends_on = [aws_lb.main]
}


// ---------------------------------------------------------
// Kong Admin GUI TCP Trafic
// ---------------------------------------------------------
resource "aws_lb_listener" "kong_admin_gui" {
  port     = var.lb_tcp_admin_gui_listen_port
  protocol = "TCP"
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kong_admin_gui.arn
  }
  depends_on = [aws_lb_target_group.kong_admin_gui]
}
resource "aws_lb_target_group" "kong_admin_gui" {
  name            = "${var.name}-${var.env}-tcp-admin-gui"
  tags            = var.additional_tags
  vpc_id          = aws_vpc.main.id
  port            = var.lb_tcp_admin_gui_listen_port
  protocol        = "TCP"
  target_type     = "ip"
  health_check {
    port                = var.lb_tcp_health_port
    protocol            = "TCP"
    enabled             = true
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  depends_on = [aws_lb.main]
}



// ---------------------------------------------------------
// ECS Fargate Task Definition -- Proxy
// ---------------------------------------------------------
data template_file td_proxy {
  template = file("${path.module}/tasks/kongproxy-${var.kong_proxy_type}.tpl")
  vars = {
    region                        = var.region
    environment                   = var.env
    image_kong_proxy              = var.image_kong_proxy
    kong_license_base64           = local.kong_license_base64
    kong_license                  = ""
    aws_cloudwatch_group          = var.aws_cloudwatch_group
    lb_tcp_health_port            = var.lb_tcp_health_port
    lb_tcp_http_listen_port       = var.lb_tcp_http_listen_port
    lb_tcp_https_listen_port      = var.lb_tcp_https_listen_port
    lb_tcp_admin_api_listen_port  = var.lb_tcp_admin_api_listen_port
    lb_tcp_admin_gui_listen_port  = var.lb_tcp_admin_gui_listen_port
    kong_log_level                = var.kong_log_level
    kong_pg_port                  = var.kong_pg_port
    kong_database                 = var.kong_database
    kong_pg_user                  = var.kong_pg_user
    kong_pg_host                  = var.kong_pg_host
    kong_pg_password              = var.kong_pg_password
    kong_pg_database              = var.kong_pg_database
    kong_pg_ssl_verify            = var.kong_pg_ssl_verify
    kong_pg_host                  = aws_db_instance.kongdb.address
    kong_pg_port                  = aws_db_instance.kongdb.port
    kong_port_maps                = var.kong_port_maps
    kong_admin_listen             = var.kong_admin_listen
    kong_status_listen            = var.kong_status_listen
    kong_proxy_listen             = var.kong_proxy_listen
    kong_admin_error_log          = var.kong_admin_error_log
    kong_proxy_error_log          = var.kong_proxy_error_log
    kong_proxy_access_log         = var.kong_proxy_access_log
    kong_admin_access_log         = var.kong_admin_access_log
    kong_admin_gui_error_log      = var.kong_admin_gui_error_log
    kong_portal_api_error_log     = var.kong_portal_api_error_log
    kong_portal_api_access_log    = var.kong_portal_api_access_log
    kong_admin_gui_access_log     = var.kong_admin_gui_access_log
    kong_nginx_worker_procesess   = var.kong_nginx_worker_procesess
    kong_lua_package_path         = var.kong_lua_package_path
  }
}
resource "aws_ecs_task_definition" "main" {
  family                   = "kong-api-gateway"
  network_mode             = "awsvpc"
  requires_compatibilities = ["${var.capabilities}"]
  cpu                      = 256
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.td_proxy.rendered
  depends_on = [aws_db_instance.kongdb]
  tags                     = merge(
    var.additional_tags,
    { 
      DeployDate : formatdate("YYYYMMDDhhmmss", timestamp()),
    },
  )  
}


// ---------------------------------------------------------
// ECS Fargate Service
// ---------------------------------------------------------
data "aws_ecs_task_definition" "main" {task_definition = "${aws_ecs_task_definition.main.family}"}

resource "aws_ecs_service" "main" {
  name                               = "${var.name}-${var.env}-gateway"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = "${aws_ecs_task_definition.main.family}:${max("${aws_ecs_task_definition.main.revision}", "${data.aws_ecs_task_definition.main.revision}")}"
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
 
  network_configuration {
    security_groups  = [
      aws_security_group.kong_gateway.id,
    ]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }
 
  load_balancer {
    target_group_arn = aws_lb_target_group.kong_http.arn
    container_name   = "kong-proxy"
    container_port   = var.lb_tcp_http_listen_port
  }
 
  load_balancer {
    target_group_arn = aws_lb_target_group.kong_https.arn
    container_name   = "kong-proxy"
    container_port   = var.lb_tcp_https_listen_port
  }
 
  load_balancer {
    target_group_arn = aws_lb_target_group.kong_admin_api.arn
    container_name   = "kong-proxy"
    container_port   = var.lb_tcp_admin_api_listen_port
  }
 
  load_balancer {
    target_group_arn = aws_lb_target_group.kong_admin_gui.arn
    container_name   = "kong-proxy"
    container_port   = var.lb_tcp_admin_gui_listen_port
  }
 
  tags                     = merge(
    var.additional_tags,
    { 
      DeployDate : formatdate("YYYYMMDDhhmmss", timestamp()),
    }
  )

  depends_on = [
    aws_lb_listener.kong_http,
    aws_lb_listener.kong_https,
    aws_ecs_task_definition.main,
    aws_lb_listener.kong_admin_api,
    aws_lb_listener.kong_admin_gui,
    aws_security_group.kong_gateway
  ]
}


// ---------------------------------------------------------
// Fargate Kong API Gateway Security Group
// ---------------------------------------------------------
resource "aws_security_group" "kong_gateway" {
  name   = "${var.name}-${var.env}"
  vpc_id = aws_vpc.main.id
 
  ingress {
   protocol         = "tcp"
   to_port          = var.lb_tcp_http_listen_port
   from_port        = var.lb_tcp_http_listen_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   description      = "proxy http listener port"
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = var.lb_tcp_https_listen_port
   to_port          = var.lb_tcp_https_listen_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   description      = "proxy https listener port"
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = var.lb_tcp_admin_api_listen_port
   to_port          = var.lb_tcp_admin_api_listen_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   description      = "proxy admin api listener port"
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = var.lb_tcp_admin_gui_listen_port
   to_port          = var.lb_tcp_admin_gui_listen_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   description      = "proxy admin gui listener port"
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = var.lb_tcp_health_port
   to_port          = var.lb_tcp_health_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   description      = "status check"
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = "5432"
   to_port          = "5432"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   description      = "status check"
  }
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.additional_tags
}