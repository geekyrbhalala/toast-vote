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