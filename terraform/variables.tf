variable "environment_name" {
  description = "Environment (stage/prod)"
}

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "number_of_tasks" {
  description = "The number of tasks to run in the service"
}

variable "docker_container_url" {
  type        = string
  description = "The docker container address - usually housed in ECR"
}
variable "envoy_docker_container_url" {
  type        = string
  description = "The docker container address - usually housed in ECR"
}

variable "fargate_cpu" {
  description = "CPU for Fargate"
  default     = 2048
}

variable "fargate_memory" {
  description = "Memory for Fargate"
  default     = 4096
}

variable "app_port" {
  description = "Memory for Fargate"
  default     = 443
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "container_name" {
  description = "Container name on ECR"
}

variable "envoy_container_name" {
  description = "Container name on ECR"
}

variable "health_check_endpoint" {
  description = "the URL of the health check that the load balancer can call"
  default     = "/"
}

variable "http_health_check_success_codes" {
  description = "The HTTP status check code for successful responses"
  default     = "200"
}

variable "route53_record_appendix" {
  type        = string
  description = "Will be appended to the route53 record. Only used if route53_zone_id is passed also"
}


variable "app_environments_vars" {
  type        = list(map(string))
  default     = []
  description = "environment varibale needed by the application"
}

variable "envoy_environments_vars" {
  type        = list(map(string))
  default     = []
  description = "environment varibale needed by the envoy"
}