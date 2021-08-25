terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.55.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "eu-central-1"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "deployment_package.zip"
  function_name = "python_hello_world"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "function_code.main.lambda_handler"

  source_code_hash = filebase64sha256("deployment_package.zip")

  runtime = "python3.9"

  }
