variable "aws_region" {}
variable "index_document" {}
variable "error_document" {} 
variable "domain_name" {}


resource "aws_s3_bucket" "bucket_with_website" {
  bucket = var.domain_name
}

resource "aws_s3_bucket_ownership_controls" "frontend_ownership" {
  bucket = aws_s3_bucket.bucket_with_website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_access" {
  bucket = aws_s3_bucket.bucket_with_website.id

  block_public_acls       = true
  block_public_policy     = false  # Allow bucket policy for CloudFront
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.bucket_with_website.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

output "s3_bucket_id" {
  value = aws_s3_bucket.bucket_with_website.id
}