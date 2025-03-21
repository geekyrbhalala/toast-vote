locals {
  backend_files       = fileset("../backend", "*.py") # Get all .py files
  common_handler_name = "lambda_handler"              # Common handler function name
  common_runtime      = "python3.12"
  account_id          = data.aws_caller_identity.current.account_id
}

locals {
  api_resources = {
    "vote" = ["POST", "GET"]
    # You can add more resources and methods here
  }

  # Flatten the list and convert into a map
  api_map = {
    for idx, item in flatten([
      for resource, methods in local.api_resources : [
        for method in methods : {
          resource    = resource
          http_method = method
        }
      ]
    ]) : lower("${item.http_method}_${item.resource}") => item
  }
}

module "lambda_iam_role" {
  source             = "./modules/IAM"
  votes_table_arn    = module.toastmasters_database.votes_table_arn
  comments_table_arn = module.toastmasters_database.comments_table_arn
  meetings_table_arn = module.toastmasters_database.meetings_table_arn
}

module "all_functions" {
  for_each = { for file in local.backend_files : trimsuffix(file, ".py") => file }

  source        = "./modules/Lambda"
  function_name = each.key
  source_file   = "../backend/${each.value}"
  handler       = "${each.key}.${local.common_handler_name}"
  runtime       = local.common_runtime
  iam_role_arn  = module.lambda_iam_role.lambda_iam_role_arn
}

# API Gateway
resource "aws_api_gateway_rest_api" "toastmasters_api" {
  name        = "ToastmastersVotingAPI"
  description = "API for voting and commenting in Toastmasters meetings"
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
  stage_name    = "dev"
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
  stage_name    = "dev"
}

# Lambda Permission for API Gateway to invoke Lambda function
resource "aws_lambda_permission" "apigateway_invoke" {
  for_each      = local.api_map
  statement_id  = "AllowAPIGatewayInvoke${each.value.http_method}_${each.value.resource}"
  action        = "lambda:InvokeFunction"
  function_name = lower("${each.value.http_method}_${each.value.resource}")
  principal     = "apigateway.amazonaws.com"
  # Restrict invocation to API Gateway stage and method
  source_arn = "arn:aws:execute-api:ca-central-1:${local.account_id}:${aws_api_gateway_rest_api.toastmasters_api.id}/*/${each.value.http_method}/${each.value.resource}"
}





