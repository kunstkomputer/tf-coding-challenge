# tf-coding-challenge

Sample terraform config providing a lambda function, which is triggered via a cron expression.


## Prerequesites

- Setup your aws CLI and username either as environment vars or via `~/.aws/credentials`

- the IAM user executing terraform requires the following capabilities to apply this configuration successfully:
  - `iam:CreateRole`
  - `iam:GetInstanceProfile`
  - `iam:CreateRole`
  - `iam:PutRolePolicy`
  - `iam:AttachRolePolicy`
  - `lambda:CreateFunction`
  - `lambda:InvokeAsync`
  - `lambda:InvokeFunction`
  - `iam:PassRole`
  - `lambda:UpdateAlias`
  - `lambda:CreateAlias`
  - `lambda:GetFunctionConfiguration`
  - `lambda:AddPermissio`


## Caveates

If this configuration is applied, the lambda automatically creates a loggroup in CloudWatch for this function.
The loggroup is not managed by Terraform, thus the it won't be removed in case this plan is destroyed.