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

resource "aws_iam_role" "lambda_execution" {
  name = "iam_for_kunstkomputer_lambda"

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

data "aws_iam_policy_document" "lambda_execution_role_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_execution_role" {
  role   = aws_iam_role.lambda_execution.id
  policy = data.aws_iam_policy_document.lambda_execution_role_policy.json
}


resource "aws_lambda_function" "kunstkomputer_lambda" {
  filename      = "deployment_package.zip"
  function_name = "python_hello_world"
  role          = aws_iam_role.lambda_execution.arn
  handler       = "function_code.main.lambda_handler"

  source_code_hash = filebase64sha256("deployment_package.zip")

  runtime = "python3.9"

  }


output "function_name" {
  value = aws_lambda_function.kunstkomputer_lambda.function_name
}
