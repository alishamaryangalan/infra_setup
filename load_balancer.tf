resource "aws_lb" "application_load_balancer" {
  name                       = "application-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.load_balancer_security_group.id]
  subnets                    = aws_subnet.public.*.id
  enable_deletion_protection = false
  tags = {
    Name = "application-loadbalancer"
  }
}

resource "aws_lb_target_group" "alb_group" {
  name        = "webapp-lb-target-group"
  port        = var.webapp_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_demo.id
  health_check {
    port                = var.webapp_port
    protocol            = "HTTP"
    interval            = 100
    timeout             = 50
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = "/healthz"
    matcher             = "200"
  }
}

# resource "aws_autoscaling_attachment" "asg_attachment_bar" {
#   autoscaling_group_name = aws_autoscaling_group.webapp_autoscaling_group.id
#   alb_target_group_arn   = aws_lb_target_group.alb_group.arn
# }

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  # port              = "80"
  # protocol          = "HTTP"
  port            = 443
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:us-east-1:916955218910:certificate/8ec495d2-4a3f-4489-bdde-a34a606d0345"

  default_action {
    target_group_arn = aws_lb_target_group.alb_group.arn
    type             = "forward"
  }
}