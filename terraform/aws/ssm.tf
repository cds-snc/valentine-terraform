resource "aws_ssm_parameter" "azure_openai_endpoint" {
  name  = "azure_openai_endpoint"
  type  = "SecureString"
  value = var.azure_openai_endpoint

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }

}

resource "aws_ssm_parameter" "azure_openai_key" {
  name  = "azure_openai_key"
  type  = "SecureString"
  value = var.azure_openai_key

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "cognito_domain" {
  name  = "cognito_domain"
  type  = "SecureString"
  value = var.create_cognito_user_pool ? "${aws_cognito_user_pool_domain.domain[0].domain}.auth.${var.region}.amazoncognito.com" : ""

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name  = "cognito_client_id"
  type  = "SecureString"
  value = var.create_cognito_user_pool ? aws_cognito_user_pool_client.client[0].id : ""

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "cognito_client_secret" {
  name  = "cognito_client_secret"
  type  = "SecureString"
  value = var.create_cognito_user_pool ? aws_cognito_user_pool_client.client[0].client_secret : ""

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "cognito_user_pool_id"
  type  = "SecureString"
  value = var.create_cognito_user_pool ? aws_cognito_user_pool.valentine_user_pool[0].id : ""

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "cognito_aws_region" {
  name  = "cognito_aws_region"
  type  = "SecureString"
  value = var.create_cognito_user_pool ? var.region : ""

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "database_url" {
  name  = "database_url"
  type  = "SecureString"
  value = "ecto://valentine:${random_password.db.result}@${module.rds_cluster.rds_cluster_endpoint}/valentine"

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "google_client_id" {
  name  = "google_client_id"
  type  = "SecureString"
  value = var.google_client_id

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "google_client_secret" {
  name  = "google_client_secret"
  type  = "SecureString"
  value = var.google_client_secret

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_ssm_parameter" "secret_key_base" {
  name  = "secret_key_base"
  type  = "SecureString"
  value = var.secret_key_base

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}
