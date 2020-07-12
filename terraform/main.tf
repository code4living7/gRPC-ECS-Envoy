terraform {
  backend "s3" {
    bucket               = "terraform-state"
    dynamodb_table       = "terraform-lock"
    region               = "ap-southeast-2"
    key                  = "gRPC-service/terraform.tfstate"
    workspace_key_prefix = "env"
  }
}

provider "aws" {
  version = "~> 2.47"
  region  = "us-east-1"
  alias   = "aws_us"
}


module "service_layer" {
  source = "modules\/ecs"

  environment_name                = var.environment_name
  service_name                    = var.service_name
  number_of_tasks                 = var.number_of_tasks
  docker_container_url            = var.docker_container_url
  fargate_cpu                     = var.fargate_cpu
  fargate_memory                  = var.fargate_memory
  app_port                        = var.app_port
  container_name                  = var.container_name
  aws_region                      = var.aws_region
  health_check_endpoint           = var.health_check_endpoint
  http_health_check_success_codes = var.http_health_check_success_codes
  envoy_container_name            = var.envoy_container_name
  envoy_docker_container_url      = var.envoy_docker_container_url
  route53_record_appendix         = var.route53_record_appendix
  app_environments_vars           = var.app_environments_vars
  envoy_environments_vars         = var.envoy_environments_vars
  providers = {
    aws = aws.aws_us
  }
}
