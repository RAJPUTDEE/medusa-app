data "aws_vpc" "default" {
  default = true
}

resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

resource "aws_lb" "medusa_alb" {
  name               = "medusa-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.security_group]
}

resource "aws_lb_target_group" "medusa_tg" {
  name     = "medusa-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "medusa_listener" {
  load_balancer_arn = aws_lb.medusa_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.medusa_tg.arn
  }
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "medusa"
      image     = "lscr.io/linuxserver/medusa:latest"
      portMappings = [{
        containerPort = 8081
        hostPort      = 8081
        protocol      = "tcp"
      }],
      environment = [
        { name = "PUID", value = "1000" },
        { name = "PGID", value = "1000" },
        { name = "TZ",   value = "Etc/UTC" }
      ],
      mountPoints = [
        {
          sourceVolume  = "medusa_config"
          containerPath = "/config"
          readOnly      = false
        },
        {
          sourceVolume  = "medusa_downloads"
          containerPath = "/downloads"
          readOnly      = false
        },
        {
          sourceVolume  = "medusa_tv"
          containerPath = "/tv"
          readOnly      = false
        }
      ]
    }
  ])

  volume {
    name = "medusa_config"
  }

  volume {
    name = "medusa_downloads"
  }

  volume {
    name = "medusa_tv"
  }

  ephemeral_storage {
    size_in_gib = 21
  }
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    assign_public_ip = true
    security_groups = [var.security_group]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.medusa_tg.arn
    container_name   = "medusa"
    container_port   = 8081
  }
}

output "alb_dns" {
  value = aws_lb.medusa_alb.dns_name
}

output "cluster_name" {
  value = aws_ecs_cluster.medusa_cluster.name
}

output "service_name" {
  value = aws_ecs_service.medusa_service.name
}

output "task_family" {
  value = aws_ecs_task_definition.medusa_task.family
}

variable "execution_role_arn" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = string
}
