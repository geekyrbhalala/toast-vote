variable "aws_region" {
  description = "The AWS region to create resources"
}

variable "domain_name" {
  description = "Custom domain name"
  type        = string
}

variable "api_gateway_stage" {
  type = string
}
