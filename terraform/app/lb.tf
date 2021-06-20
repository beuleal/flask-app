# Creates the ALB
resource "aws_alb" "application_load_balancer" {
  name               = "api-app-lb"
  load_balancer_type = "application"
  subnets = [ 
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id,
    aws_default_subnet.default_subnet_c.id
  ]

  security_groups = [aws_security_group.load_balancer_security_group.id]
}

# Creates the ALB target group
resource "aws_lb_target_group" "target_group" {
  name        = "api-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id 
}

# Creates the ALB Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}