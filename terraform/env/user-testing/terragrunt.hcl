terraform {
  source = "../..//aws"
}

locals {
  billing_code = "valentine-user-testing"
  region       = "ca-central-1"
}

# DO NOT CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING

inputs = {
  account_id                            = "975050085632"
  billing_code                          = local.billing_code
  create_cognito_user_pool              = true
  create_gh_oidc_ecs_service_role       = true
  create_gh_oidc_terraform_release_role = false
  create_google_auth                    = false
  domain                                = "valentine-dev.cdssandbox.xyz"
  region                                = local.region
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