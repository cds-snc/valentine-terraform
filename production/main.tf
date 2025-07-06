provider "aws" {
  region              = "ca-central-1"
  allowed_account_ids = ["686255955988"]
}

provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  allowed_account_ids = ["686255955988"]
}


data "aws_caller_identity" "current" {}
