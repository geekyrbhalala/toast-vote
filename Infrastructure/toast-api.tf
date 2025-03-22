# API Gateway
resource "aws_api_gateway_rest_api" "toastmasters_api" {
  name        = "ToastmastersVotingAPI"
  description = "API for voting and commenting in Toastmasters meetings"
}

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = "api.${var.domain_name}"         # Custom domain (api.xyz.com)
  regional_certificate_arn = aws_acm_certificate.api_cert.arn # ACM certificate for the custom domain

  endpoint_configuration {
    types = ["REGIONAL"] # Use a regional endpoint for the API Gateway
  }

  depends_on = [
    aws_acm_certificate.api_cert,          # Ensure the certificate is created before the domain
    aws_route53_record.api_cert_validation # Ensure DNS validation record is created before domain
  ]
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  api_id      = aws_api_gateway_rest_api.toastmasters_api.id
  stage_name  = "dev"
  domain_name = "api.${var.domain_name}"
  base_path   = var.api_gateway_stage
  depends_on = [aws_api_gateway_rest_api.toastmasters_api, aws_route53_record.api_A_record]
}

# Define Resources (Endpoints)
resource "aws_api_gateway_resource" "resources" {
  for_each    = local.api_resources
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
  parent_id   = aws_api_gateway_rest_api.toastmasters_api.root_resource_id
  path_part   = each.key
  depends_on  = [aws_api_gateway_rest_api.toastmasters_api]
}

# Define Endpoints for each HTTP method
module "endpoints" {
  for_each = local.api_map

  source        = "./modules/APIGatewayEndpoints"
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  resource_id   = aws_api_gateway_resource.resources[each.value.resource].id
  http_method   = each.value.http_method
  function_name = module.all_functions[lower("${each.value.http_method}_${each.value.resource}")].function_name
  aws_region    = var.aws_region
  account_id    = local.account_id
  stage_name    = var.api_gateway_stage
  depends_on    = [module.all_functions, aws_api_gateway_resource.resources]
}

# Deployment Stage
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    module.endpoints
  ]
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  stage_name    = var.api_gateway_stage
}






