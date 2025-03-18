variable "stage_name" {}

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

# Methods (We will integrate with Lambda later)
resource "aws_api_gateway_method" "post_vote" {
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  resource_id   = aws_api_gateway_resource.vote.id
  http_method   = "POST"
  authorization = "NONE" # Change to Cognito or API Key if needed
}

resource "aws_api_gateway_method" "get_results" {
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  resource_id   = aws_api_gateway_resource.results.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_comment" {
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  resource_id   = aws_api_gateway_resource.comments.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_comments" {
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  resource_id   = aws_api_gateway_resource.comment_by_speaker.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_meetings" {
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  resource_id   = aws_api_gateway_resource.meetings.id
  http_method   = "GET"
  authorization = "NONE"
}

# Deployment Stage
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_method.post_vote,
    aws_api_gateway_method.get_results,
    aws_api_gateway_method.post_comment,
    aws_api_gateway_method.get_comments,
    aws_api_gateway_method.get_meetings
  ]
  
  rest_api_id = aws_api_gateway_rest_api.toastmasters_api.id
}

# API Gateway Stage
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.toastmasters_api.id
  stage_name    = var.stage_name
}