terraform {
  source = "../..//aws"
}

locals {
  billing_code = "valentine"
  region       = "ca-central-1"
}

# DO NOT CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING

inputs = {
  account_id               = "686255955988"
  billing_code             = local.billing_code
  create_cognito_user_pool = false
  create_gh_oidc_roles     = false
  create_google_auth       = true
  domain                   = "valentine.cds-snc.ca"
  region                   = local.region
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt             = true
    bucket              = "${local.billing_code}-tf"
    dynamodb_table      = "terraform-state-lock-dynamo"
    region              = local.region
    key                 = "./terraform.tfstate"
    s3_bucket_tags      = { CostCenter : local.billing_code }
    dynamodb_table_tags = { CostCenter : local.billing_code }
  }
}