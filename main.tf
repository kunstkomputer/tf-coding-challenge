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
  region = "eu-central-1"
}
variable "create_resources" {
  type    = bool
  default = true
}

# roles
resource "aws_iam_role" "lambda_execution" {
  name  = "iam_for_kunstkomputer_lambda"
  count = var.create_resources ? 1 : 0

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

# lambda auto-creates loggroup not managed by tf
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
  role   = aws_iam_role.lambda_execution[count.index].id
  policy = data.aws_iam_policy_document.lambda_execution_role_policy.json
  count  = var.create_resources ? 1 : 0
}

# function
resource "aws_lambda_function" "kunstkomputer_lambda" {
  filename      = "deployment_package.zip"
  function_name = "python_hello_world"
  role          = aws_iam_role.lambda_execution[count.index].arn
  handler       = "function_code.main.lambda_handler"

  source_code_hash = filebase64sha256("deployment_package.zip")

  runtime = "python3.9"
  count   = var.create_resources ? 1 : 0

}

# cron trigger
resource "aws_cloudwatch_event_rule" "cron_trigger" {
  name                = "cron_trigger_for_kunstkomputer_lambda"
  description         = "Fires every minute"
  schedule_expression = "cron(* * * * ? *)"
  count               = var.create_resources ? 1 : 0
}

resource "aws_cloudwatch_event_target" "trigger_kunstkomputer_lambda" {
  rule  = aws_cloudwatch_event_rule.cron_trigger[count.index].name
  arn   = aws_lambda_function.kunstkomputer_lambda[count.index].arn
  count = var.create_resources ? 1 : 0
}

resource "aws_lambda_permission" "trigger_execution_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kunstkomputer_lambda[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_trigger[count.index].arn
  count         = var.create_resources ? 1 : 0
}

output "deployed_region" {
  value = data.aws_region.current.name
}
