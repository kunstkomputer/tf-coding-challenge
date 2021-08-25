import json
import os


def lambda_handler(event, context):
    print("Hello from CodingChallenge")
    print(os.environ)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from CodingChallenge!')
    }
