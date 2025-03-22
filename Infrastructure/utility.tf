provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "geekyrbhalala" {
  name         = var.domain_name
  private_zone = false
}