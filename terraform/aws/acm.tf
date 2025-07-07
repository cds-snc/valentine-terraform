resource "aws_acm_certificate" "valentine" {
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  tags = {
    "CostCentre" = var.billing_code
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "valentine_certificate_validation" {
  zone_id = aws_route53_zone.valentine.zone_id

  for_each = {
    for dvo in aws_acm_certificate.valentine.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type

  ttl = 60
}

resource "aws_acm_certificate_validation" "valentine" {
  certificate_arn         = aws_acm_certificate.valentine.arn
  validation_record_fqdns = [for record in aws_route53_record.valentine_certificate_validation : record.fqdn]
}
