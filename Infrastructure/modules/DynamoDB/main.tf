# DynamoDB Tables
resource "aws_dynamodb_table" "votes" {
  name         = "Votes"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "meeting_id"
  range_key    = "category"

  attribute {
    name = "meeting_id"
    type = "S"
  }
  
  attribute {
    name = "category"
    type = "S"
  }
  
  attribute {
    name = "speaker_id"
    type = "S"
  }
  
  global_secondary_index {
    name            = "speaker_index"
    hash_key        = "speaker_id"
    range_key       = "category"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "comments" {
  name         = "Comments"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "meeting_id"
  range_key    = "speaker_id"

  attribute {
    name = "meeting_id"
    type = "S"
  }
  
  attribute {
    name = "speaker_id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "meetings" {
  name         = "Meetings"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "meeting_id"

  attribute {
    name = "meeting_id"
    type = "S"
  }
}

output "votes_table_arn" {
  value = aws_dynamodb_table.votes.arn
}

output "comments_table_arn" {
  value = aws_dynamodb_table.comments.arn
}

output "meetings_table_arn" {
  value = aws_dynamodb_table.meetings.arn
}
