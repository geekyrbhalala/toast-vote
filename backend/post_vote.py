import json
import boto3
import uuid
import time
from datetime import datetime

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Votes')

def lambda_handler(event, context):
    """
    Lambda function to store votes into DynamoDB.
    """
    # try:
    #     # Parse incoming request (API Gateway Event)
    #     body = json.loads(event.get("body", "{}"))

    #     # Validate required fields
    #     required_fields = ['meeting_id','category', 'speaker_id']

    return {
        "statusCode": 200,
        "body": "Post Vote Function"
    }