variable "domain_name" {}
variable "cdn_endpoint" {}

data "aws_route53_zone" "geekyrbhalala" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "website" {
  zone_id = data.aws_route53_zone.geekyrbhalala.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300

  alias {
    name = var.cdn_endpoint
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}