provider "aws" {
  region              = "ca-central-1"
  allowed_account_ids = ["975050085632"]
}

provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  allowed_account_ids = ["975050085632"]
}


data "aws_caller_identity" "current" {}
