variable "domain_name" {}
variable "s3_endpoint" {}

data "aws_route53_zone" "geekyrbhalala" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "website" {
  zone_id = aws_route53_zone.geekyrbhalala.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.s3_endpoint
    zone_id                = "Z3AQBSTGFYJSTF" # Fixed AWS Zone ID for S3 website endpoints
    evaluate_target_health = false
  }
}