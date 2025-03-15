provider "aws" {
  region = var.aws_region
}

locals {
  index_document = "index.html"
  error_document = "error.html"
}

module "s3_bucket" {
  source         = "./modules/S3"
  aws_region     = var.aws_region
  domain_name    = var.domain_name
  index_document = local.index_document
  error_document = local.error_document
}

# ACM Certificate (for custom domain)
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

module "cdn_s3_distribution" {
  source         = "./modules/Cloudfront"
  domain_name    = var.domain_name
  aws_region     = var.aws_region
  index_document = local.index_document
  acm_cert_arn   = aws_acm_certificate.cert.arn
}



module "route53_with_cdn" {
  source                        = "./modules/Route53"
  domain_name                   = var.domain_name
  cdn_endpoint                  = module.cdn_s3_distribution.cdn_endpoint
  cdn_hosted_zone_id            = module.cdn_s3_distribution.cdn_hosted_zone_id
  acm_domain_validation_options = aws_acm_certificate.cert.domain_validation_options
  acm_cert_arn                  = aws_acm_certificate.cert.arn
}

# S3 Bucket Policy to restrict only to cdn access
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = module.s3_bucket.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.domain_name}/*" # referencing domain name but it is actually bucket name
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${module.cdn_s3_distribution.cdn_distribution_id}"
          }
        }
      }
    ]
  })
}