resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

module "rds_cluster" {
  source = "github.com/cds-snc/terraform-modules//rds?ref=v10.8.2"
  name   = "valentine"

  database_name  = "valentine"
  engine         = "aurora-postgresql"
  engine_version = "14.17"
  instance_class = "db.t3.medium"
  instances      = 1
  username       = "valentine"
  password       = random_password.db.result
  use_proxy      = false

  backup_retention_period = 14
  preferred_backup_window = "02:00-04:00"

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  billing_tag_value = var.billing_code
}
