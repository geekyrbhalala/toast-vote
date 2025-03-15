variable "domain_name" {}
variable "s3_endpoint" {}

data "aws_route53_zone" "geekyrbhalala" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "website" {
  zone_id = data.aws_route53_zone.geekyrbhalala.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [var.s3_endpoint]
}