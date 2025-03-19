variable "stage_name" {}
variable "aws_region" {}
variable "function_name" {}
variable "rest_api_id" {}
variable "resource_id" {}
variable "http_method" {}
variable "account_id" {}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = var.http_method
  authorization = "NONE" # Adjust based on your auth setup (e.g., Cognito or API Key)
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = var.http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.account_id}:function:${var.function_name}/invocations"
  depends_on = [ aws_api_gateway_method.method ]
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
}

# resource "aws_api_gateway_integration_response" "integration_response" {
#   rest_api_id          = var.rest_api_id
#   resource_id          = var.resource_id
#   http_method          = aws_api_gateway_method.method.http_method
#   status_code          = aws_api_gateway_method_response.method_response.status_code
#   selection_pattern    = ""
#   response_templates   = {
#     "application/json" = ""
#   }
# }
