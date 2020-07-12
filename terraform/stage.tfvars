environment_name           = "stage"
service_name               = "grpc-service"
number_of_tasks            = 3
docker_container_url       = "{{ ecr_repository }}/grpc-service:latest"
envoy_docker_container_url = "{{ ecr_repository }}/envoy:latest"
fargate_cpu                = 2048
fargate_memory             = 4096
app_port                   = 443
container_name             = "grpc-service"
envoy_container_name       = "envoy-proxy"
aws_region                 = "us-east-1"
health_check_endpoint      = "/"
route53_record_appendix    = "api.example.com"
app_environments_vars = [
  {
    name  = "GRPC_PORT"
    value = "0.0.0.0:50051"
  }
]
envoy_environments_vars = [
  {
    name  = "LISTEN_PORT"
    value = "90"
  },
  {
    name  = "SERVICE_DISCOVERY_ADDRESS"
    value = "grpc-service.api.example.com"
  },
  {
    name  = "SERVICE_DISCOVERY_PORT"
    value = "50051"
  }
]
