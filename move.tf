################################################
## load balancer
################################################
#target group for nebula
resource "aws_lb_target_group" "es_tg" {
  name        = "travissaucier-${terraform.workspace}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_lb" "alb" {
  name               = "travissaucier-${terraform.workspace}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.public.id
  subnets            = module.subnets.public_subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket  = null
    prefix  = "travissaucier-${terraform.workspace}-alb"
    enabled = false
  }

  tags = merge(local.tags, tomap({
    Name = name ## not going to work
  }))
}


resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
