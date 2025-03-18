provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}