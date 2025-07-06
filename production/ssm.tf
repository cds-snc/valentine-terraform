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
