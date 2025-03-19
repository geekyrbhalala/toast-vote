variable "function_name" {}
variable "source_file" {}
variable "handler" {}
variable "runtime" {
  default = "python3.8"
}
variable "iam_role_arn" {}
variable "timeout" {
  default = 30
}
variable "environment_variables" {
  default = {}
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${var.function_name}_payload.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.lambda.output_path
  function_name = var.function_name
  role          = var.iam_role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = var.environment_variables
  }
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}
