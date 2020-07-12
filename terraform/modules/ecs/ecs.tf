data "aws_ecs_cluster" "main" {
  cluster_name = var.environment_name
}


resource "aws_ecs_task_definition" "task_def" {
  family = "${var.service_name}-api-${lower(var.environment_name)}"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  task_role_arn = "<task-iam-role>"
  execution_role_arn = "<task-iam-role>"

  container_definitions = <<DEFINITION
[
  {
   "image": "${var.envoy_docker_container_url}",
    "name": "${var.envoy_container_name}",
    "esssential": true,
    "portMappings": [
      {
        "containerPort": 50051,
        "protocol": "tcp",
        "hostPort": 50051
      },
      {
        "containerPort": 8081,
        "protocol": "tcp",
        "hostPort": 8081
      }
    ],
    "environment": [
      { "name" : "LISTEN_PORT", "value" : "50051" },
      { "name" : "SERVICE_DISCOVERY_ADDRESS", "value" : "0.0.0.0" },
      { "name" : "SERVICE_DISCOVERY_PORT", "value" : "50051" }
      ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": [],
      "options": {
        "awslogs-group": "${var.environment_name}-Deploy-${var.service_name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.service_name}"
      }
    }
  },
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.docker_container_url}",
    "memory": ${var.fargate_memory},
    "name": "${var.container_name}",
    "esssential": true,
    "environment": ${jsonencode(var.app_environments_vars)},
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": [],
      "options": {
        "awslogs-group": "${var.environment_name}-Deploy-${var.service_name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.service_name}"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_task_definition" "load_balacer_task_def" {
  family = "${var.service_name}-proxy-${lower(var.environment_name)}"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  task_role_arn = "<task-iam-role>"
  execution_role_arn = "<task-iam-role>"

  container_definitions = <<DEFINITION
[
  {
    "image": "${var.envoy_docker_container_url}",
    "name": "${var.envoy_container_name}",
    "esssential": true,
    "portMappings": [
      {
        "containerPort": 90,
        "protocol": "tcp",
        "hostPort": 90
      },
      {
        "containerPort": 8081,
        "protocol": "tcp",
        "hostPort": 8081
      }
    ],
    "environment": ${jsonencode(var.envoy_environments_vars)},
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": [],
      "options": {
        "awslogs-group": "${var.environment_name}-Deploy-${var.service_name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.service_name}"
      }
    }
  }
]
DEFINITION
}

resource aws_service_discovery_private_dns_namespace envoy-ssl {
  name = var.route53_record_appendix
  description = "Private namespace for the gRPC Service"
  vpc = "vpc-1"
}


resource aws_service_discovery_service envoy-ssl {
  name = "${var.service_name}.app"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.envoy-ssl.id

    dns_records {
      ttl = 900
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

resource aws_service_discovery_service load_balancer {
  name = "${var.service_name}.proxy"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.envoy-ssl.id

    dns_records {
      ttl = 900
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}


resource "aws_ecs_service" "envoy_load_balance" {
  name = "${var.service_name}-proxy"
  cluster = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.load_balacer_task_def.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [
      "sg_010100101"]
    subnets = [
      "subnet1"]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.load_balancer.arn
  }

}


resource "aws_ecs_service" "main" {
  name = "${var.service_name}-api"
  cluster = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count = var.number_of_tasks
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [
      "sg_010100101"]
    subnets = [
      "subnet1"]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.envoy-ssl.arn
  }
}
