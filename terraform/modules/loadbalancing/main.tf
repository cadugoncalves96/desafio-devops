resource "aws_lb" "load_balancer" {
  name                       = "lb-${var.app}-${var.env}"
  internal                   = "false"
  load_balancer_type         = "application"
  security_groups            = [var.lb_sec_group]
  subnets                    = var.target_subnet_ids
  enable_deletion_protection = false

  tags = {
    Env     = var.env
    Name    = "lb-${var.app} - ${var.env}"
    App     = "${var.app}"
  }
}

resource "aws_lb_listener" "loadbalancer_listener" {
  load_balancer_arn   = "${aws_lb.load_balancer.arn}"
  port                = "80"
  protocol            = "HTTP"

  default_action {
    target_group_arn  = "${aws_lb_target_group.target_group.arn}"
    type              = "forward"
  }
}

resource "aws_lb_listener_rule" "lb_listener_rule" {
  listener_arn = "${aws_lb_listener.loadbalancer_listener.arn}"

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field             = "host-header"
    values            = ["${var.api_name}.${var.domain_name}"]
  }

}

resource "aws_lb_listener" "loadbalancer_listener_ssl" {
  load_balancer_arn   = aws_lb.load_balancer.arn
  port                = "443"
  protocol            = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-2016-08"
  certificate_arn     =  var.lb_certificate

  default_action {
    target_group_arn  = aws_lb_target_group.target_group.arn
    type              = "forward"
  }
}

resource "aws_lb_listener_rule" "lb_listener_rule_ssl" {
  listener_arn        = aws_lb_listener.loadbalancer_listener_ssl.arn
  priority            = 20

  action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.target_group.arn
  }

  condition {
    field             = "host-header"
    values            = ["${var.api_name}.${var.domain_name}"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "tg-${var.app}-${var.env}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    port                = 8080
    protocol            = "HTTP"
    path                = "/ping"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-499"
  }

  tags = {
    Env     = var.env
    Name    = "tg-${var.app} - ${var.env}"
    App     = "${var.app}"
  }

}

resource "aws_route53_record" "app_route" {
  zone_id = var.zone_id
  name    = "${var.api_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.load_balancer.dns_name}"
    zone_id                = "${aws_lb.load_balancer.zone_id}"
    evaluate_target_health = true
  }
}
