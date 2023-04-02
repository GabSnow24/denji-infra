resource "aws_lb" "api-lb" {
  name                             = var.lb_data.name
  internal                         = false
  enable_cross_zone_load_balancing = true
  subnets            = [var.subnets.first, var.subnets.second]
  enable_http2                     = true
  load_balancer_type               = "application"
  security_groups                  = [var.security_group.web.id]
}

resource "aws_lb_target_group" "api-tg" {
  connection_termination             = false
  lambda_multi_value_headers_enabled = false
  load_balancing_algorithm_type      = "round_robin"
  name                               = var.tg_data.name
  port                               = var.container_data.port
  protocol                           = "HTTP"
  protocol_version                   = "HTTP1"
  tags                               = {}
  target_type                        = "instance"
  vpc_id                             = var.tg_data.network.vpc_id

    health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = var.tg_data.health_check_endpoint
    port                = var.container_data.port
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }
  
  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
  depends_on = [
    aws_lb.api-lb,
    var.tg_data
  ]
}

resource "aws_lb_listener" "api-listener-http" {
  load_balancer_arn = aws_lb.api-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [
    aws_lb.api-lb
  ]
}



resource "aws_lb_listener" "api-listener-https" {
  load_balancer_arn = aws_lb.api-lb.arn
  certificate_arn   = var.lb_data.certificate_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api-tg.arn
  }
  depends_on = [
    aws_lb.api-lb
  ]

}


