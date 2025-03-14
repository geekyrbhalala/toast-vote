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


module "map_domain_with_s3" {
  source = "./modules/Route53"
  domain_name = var.domain_name
  s3_endpoint = module.frontend.website_url
}