locals {
  votes_handler_lambda_function_name = "vote-handler"
  account_id                         = data.aws_caller_identity.current.account_id
}

module "lambda_iam_role" {
  source             = "./modules/IAM"
  votes_table_arn    = module.toastmasters_database.votes_table_arn
  comments_table_arn = module.toastmasters_database.comments_table_arn
  meetings_table_arn = module.toastmasters_database.meetings_table_arn
}

# API Gateway
resource "aws_api_gateway_rest_api" "toastmasters_api" {
  name        = "ToastmastersVotingAPI"
  description = "API for voting and commenting in Toastmasters meetings"
}

# Define Resources (Endpoints)
resource "aws_api_gateway_resource" "vote" {
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
  parent_id   = aws_api_gateway_rest_api.toastmasters_api.root_resource_id
  path_part   = "vote"
}

resource "aws_api_gateway_resource" "results" {
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
  parent_id   = aws_api_gateway_rest_api.toastmasters_api.root_resource_id
  path_part   = "results"
}

resource "aws_api_gateway_resource" "comments" {
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
  parent_id   = aws_api_gateway_rest_api.toastmasters_api.root_resource_id
  path_part   = "comments"
}

resource "aws_api_gateway_resource" "comment_by_speaker" {
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
  parent_id   = aws_api_gateway_resource.comments.id
  path_part   = "{speakerId}"
}

resource "aws_api_gateway_resource" "meetings" {
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
  parent_id   = aws_api_gateway_rest_api.toastmasters_api.root_resource_id
  path_part   = "meetings"
}

module "toastmasters-vote-handler-function" {
  source        = "./modules/Lambda"
  function_name = local.votes_handler_lambda_function_name
  source_file   = "../backend/votes/post-new-vote.py" # Path to your first Lambda function code
  handler       = "${local.votes_handler_lambda_function_name}.lambda_handler"
  runtime       = "python3.8" # You can change the runtime if needed
  iam_role_arn  = module.lambda_iam_role.lambda_iam_role_arn
}

# Reuse the module for each endpoint
module "vote_endpoint" {
  source               = "./modules/APIGatewayEndpoints"
  rest_api_id          = aws_api_gateway_rest_api.toastmasters_api.id
  resource_id          = aws_api_gateway_resource.vote.id
  http_method          = "POST"
  lambda_function_name = local.votes_handler_lambda_function_name
  aws_region           = var.aws_region
  account_id           = local.account_id
  stage_name           = "dev"
}

# module "results_endpoint" {
#   source             = "./modules/APIGatewayEndpoints"
#   rest_api_id       = aws_api_gateway_rest_api.toastmasters_api.id
#   resource_id       = aws_api_gateway_resource.results.id
#   http_method       = "GET"
#   lambda_function_name = var.lambda_function_name
#   aws_region        = var.aws_region
#   stage_name = "dev"
# }

# module "comments_endpoint" {
#   source             = "./modules/APIGatewayEndpoints"
#   rest_api_id       = aws_api_gateway_rest_api.toastmasters_api.id
#   resource_id       = aws_api_gateway_resource.comments.id
#   http_method       = "POST"
#   lambda_function_name = var.lambda_function_name
#   aws_region        = var.aws_region
#   stage_name = "dev"
# }

# module "comment_by_speaker_endpoint" {
#   source             = "./modules/APIGatewayEndpoints"
#   rest_api_id       = aws_api_gateway_rest_api.toastmasters_api.id
#   resource_id       = aws_api_gateway_resource.comment_by_speaker.id
#   http_method       = "GET"
#   lambda_function_name = var.lambda_function_name
#   aws_region        = var.aws_region
#   stage_name = "dev"
# }

# module "meetings_endpoint" {
#   source             = "./modules/APIGatewayEndpoints"
#   rest_api_id       = aws_api_gateway_rest_api.toastmasters_api.id
#   resource_id       = aws_api_gateway_resource.meetings.id
#   http_method       = "GET"
#   lambda_function_name = var.lambda_function_name
#   aws_region        = var.aws_region
#   stage_name = "dev"
# }

# Deployment Stage
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    module.vote_endpoint,
    # module.results_endpoint,
    # module.comments_endpoint,
    # module.comment_by_speaker_endpoint,
    # module.meetings_endpoint
  ]

  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
}

# API Gateway Stage
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  stage_name    = "dev"
}