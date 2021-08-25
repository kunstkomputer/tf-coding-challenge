# tf-coding-challenge

Sample terraform config providing a lambda function, which is triggered via a cron expression.

### Usage

The configuration files can be sourced without creating resources by setting the `create_resources` var to `False`
This can be done on module level via a .tfvars or on cli level e.g.:
```
❯ terraform apply -var create_resources=false
```
The lambda source code is deployed via a zip file of the code. To package the code use:

```
❯ zip -r deployment_package.zip function_code/*.py
```
The zipfile creation and uploading of code to an S3 Bucket is something that may be automated using a CI pipeline
like github actions. For brevity of this challenge, a zipfile is included in the repo.

#### How to use this config

This config is intended to be sourced from a root module.
Sample Code:
```
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

module "tf-coding-challenge" {
  source = "git@github.com:kunstkomputer/tf-coding-challenge.git?ref=after_submission"
}
```
You may specify the git ref of this module by changing the `ref` querystring parameter of the github URL to a desired value (e.g. `main`,`develop`).

In case you omit the parameter terraform will source the default branch (`main` in this case).

> **_NOTE:_**  Caution, you may run `terraform init` prior to any other command, to fetch the module under the git ref. If the ref in the repo is changing, a re-init of your local tf workdir is required, to pull the changes.

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
  - `events:PutRule`


## Caveates

If this configuration is applied, the lambda automatically creates a loggroup in CloudWatch for this function.
The loggroup is not managed by Terraform, thus the it won't be removed in case this plan is destroyed.
