resource "aws_lb" "medusa_alb" {
  name               = "medusa-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.medusa_sg.id]
  subnets            = [aws_subnet.medusa_subnet_a.id, aws_subnet.medusa_subnet_b.id]
}

resource "aws_lb_listener" "medusa_listener" {
  load_balancer_arn = aws_lb.medusa_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.medusa_tg.arn
  }
}

resource "aws_lb_target_group" "medusa_tg" {
  name     = "medusa-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.medusa_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "medusa_tg_attachment" {
  target_group_arn = aws_lb_target_group.medusa_tg.arn
  target_id        = aws_ecs_service.medusa_service.id
  port             = 80
}
