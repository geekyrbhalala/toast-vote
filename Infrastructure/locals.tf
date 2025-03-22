locals {
  backend_files       = fileset("../backend", "*.py") # Get all .py files
  common_handler_name = "lambda_handler"              # Common handler function name
  common_runtime      = "python3.12"
  account_id          = data.aws_caller_identity.current.account_id

  index_document = "index.html"
  error_document = "error.html"

  api_resources = {
    "vote" = ["POST", "GET"]
  }

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