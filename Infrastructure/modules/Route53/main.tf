variable "domain_name" {}
variable "cdn_endpoint" {}
variable "cdn_hosted_zone_id" {}
variable "acm_domain_validation_options" {}
variable "acm_cert_arn" {}


data "aws_route53_zone" "geekyrbhalala" {
  name         = var.domain_name
  private_zone = false
}

# Route 53 Record for Certificate Validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in var.acm_domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.geekyrbhalala.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

#TODO : Add the certificate verification to the ACM
# # Validate the ACM certificate
# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = var.acm_cert_arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

#   depends_on = [ aws_route53_record.cert_validation ]
# }

# Route 53 Record for CloudFront
resource "aws_route53_record" "website" {
  zone_id = data.aws_route53_zone.geekyrbhalala.zone_id
  name    = var.domain_name  # Your domain name, e.g., geekyrbhalala.online
  type    = "A"

  alias {
    name                   = var.cdn_endpoint  # This should be the CloudFront domain name, e.g., d12345abcde.cloudfront.net
    zone_id                = var.cdn_hosted_zone_id
    evaluate_target_health = false
  }
}