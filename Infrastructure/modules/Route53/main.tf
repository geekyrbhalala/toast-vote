variable "domain_name" {}
variable "cdn_endpoint" {}

data "aws_route53_zone" "geekyrbhalala" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "website" {
  zone_id = data.aws_route53_zone.geekyrbhalala.zone_id
  name    = var.domain_name  # Your domain name, e.g., geekyrbhalala.online
  type    = "A"

  alias {
    name                   = var.cdn_endpoint  # This should be the CloudFront domain name, e.g., d12345abcde.cloudfront.net
    zone_id                = "Z2FDTNDATAQYW2"  # CloudFront hosted zone ID
    evaluate_target_health = false
  }
}
