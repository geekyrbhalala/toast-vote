variable "domain_name" {}
variable "aws_region" {}
variable "index_document" {}
variable "acm_cert_arn" {}
variable "zone_id" {}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC-${var.domain_name}"
  description                       = "OAC for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Route 53 Record for CloudFront
resource "aws_route53_record" "website" {
  zone_id = var.zone_id
  name    = var.domain_name  # Your domain name, e.g., geekyrbhalala.online
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name  # This should be the CloudFront domain name, e.g., d12345abcde.cloudfront.net
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${var.domain_name}.s3.${var.aws_region}.amazonaws.com"
    origin_id   = "S3-${var.domain_name}"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = var.index_document

  # Custom domain and ACM certificate
  aliases = [var.domain_name]

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
}

output "cdn_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}