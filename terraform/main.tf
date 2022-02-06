// -----------------------------------------------
// Kong 4 Fargate Supporting Infrastructure
// -----------------------------------------------
provider "aws" {
  region = var.region
  profile = var.aws_profile
}
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = var.additional_tags
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = var.additional_tags
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = var.additional_tags
}
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = var.additional_tags
}
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  tags = var.additional_tags
}
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
resource "aws_route" "private" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true
}
resource "aws_nat_gateway" "main" {
  count = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  depends_on = [aws_internet_gateway.main]
}
resource "aws_ecs_cluster" "main" {
  name = "${var.name}-${var.env}-cluster"
  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
  default_capacity_provider_strategy {
      capacity_provider = "FARGATE_SPOT"
  }
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  tags = var.additional_tags
}
resource "aws_lb" "main" {
  name                       = "${var.name}-${var.env}-lb"
  tags                       = var.additional_tags
  subnets                    = aws_subnet.public.*.id
  load_balancer_type         = "network"
  enable_deletion_protection = false
  internal                   = false

}
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecsTaskExecutionRole"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_cloudwatch_log_group" "main" {
  name = "${var.aws_cloudwatch_group}-${var.env}"
  tags                     = merge(
    var.additional_tags,
    { 
      Name : "kong-fargate-${var.env}",
    },
  )  
}