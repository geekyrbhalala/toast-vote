provider "aws" {
  region = var.aws_region
}

module "frontend" {
  source = "./modules/S3"
  aws_region = var.aws_region
  bucket_name = var.domain_name
  index_document = "home.html"
  error_document = "error.html"
}
