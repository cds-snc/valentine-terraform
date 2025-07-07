resource "aws_lb_target_group" "valentine" {
  name                 = "valentine"
  port                 = 4000
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 30
  vpc_id               = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "CostCentre" = var.billing_code
  }
}

resource "aws_lb_listener" "valentine_listener" {
  depends_on = [
    aws_acm_certificate.valentine,
    aws_route53_record.valentine_certificate_validation,
    aws_acm_certificate_validation.valentine,
  ]


  load_balancer_arn = aws_lb.valentine.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-FIPS-2023-04"
  certificate_arn   = aws_acm_certificate.valentine.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.valentine.arn
  }
}

resource "aws_lb" "valentine" {

  name                       = "valentine"
  internal                   = false #tfsec:ignore:AWS005
  load_balancer_type         = "application"
  enable_deletion_protection = true
  drop_invalid_header_fields = true

  security_groups = [
    aws_security_group.valentine_load_balancer.id
  ]

  subnets = module.vpc.public_subnet_ids

  tags = {
    "CostCentre" = var.billing_code
  }
}
