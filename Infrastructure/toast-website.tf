module "s3_bucket" {
  source         = "./modules/S3"
  aws_region     = var.aws_region
  domain_name    = var.domain_name
  index_document = local.index_document
  error_document = local.error_document
}

module "cdn_s3_distribution" {
  source         = "./modules/Cloudfront"
  domain_name    = var.domain_name
  aws_region     = var.aws_region
  index_document = local.index_document
  acm_cert_arn   = aws_acm_certificate.website_cert.arn
  zone_id        = data.aws_route53_zone.geekyrbhalala.zone_id
  depends_on     = [aws_route53_record.website_cert_validation]
}

# S3 Bucket Policy to restrict only to cdn access
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

