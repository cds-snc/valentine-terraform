resource "aws_route53_zone" "valentine" {
  name = var.domain

  tags = {
    "CostCentre" = var.billing_code
  }
}

resource "aws_route53_record" "valentine" {
  zone_id = aws_route53_zone.valentine.zone_id
  name    = aws_route53_zone.valentine.name
  type    = "A"

  alias {
    name                   = aws_lb.valentine.dns_name
    zone_id                = aws_lb.valentine.zone_id
    evaluate_target_health = false
  }
}
