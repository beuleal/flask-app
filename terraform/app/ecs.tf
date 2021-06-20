# Creates the cluster to host the tasks
resource "aws_ecs_cluster" "api_cluster" {
  name = "api_app_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Creates the definition for each api task 
resource "aws_ecs_task_definition" "api_task_definition" {
  family                   = "api_task_definitions"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name  = "api_app_container"
      image = "<aws-account-id>.dkr.ecr.eu-west-1.amazonaws.com/api:latest"

      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# Creates the ECS Service and configure lb for requests
# Note from AWS: Fargate removes the need to provision and manage servers, 
# lets you specify and pay for resources per application, and improves 
# security through application isolation by design. Fargate allocates 
# the right amount of compute, eliminating the need to choose instances 
# and scale cluster capacity.
resource "aws_ecs_service" "api_app_service" {
  name            = "api_app_service"
  cluster         = aws_ecs_cluster.api_cluster.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.api_task_definition.arn
  depends_on      = [aws_ecs_task_definition.api_task_definition]

  load_balancer {
    container_name   = "api_app_container"
    target_group_arn = aws_lb_target_group.target_group.arn
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.service_security_group.id]
    subnets = [
      aws_default_subnet.default_subnet_a.id,
      aws_default_subnet.default_subnet_b.id,
      aws_default_subnet.default_subnet_c.id
    ]
  }
}