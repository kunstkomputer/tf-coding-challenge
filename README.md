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
