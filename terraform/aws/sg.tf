resource "aws_security_group" "valentine_load_balancer" {
  name        = "Valentine load balancer"
  description = "Ingress - Valentine Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow inbound traffic from the internet on port 443"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  egress {
    description = "Allow outbound traffic to the ECS task"
    protocol    = "tcp"
    from_port   = 4000
    to_port     = 4000
    cidr_blocks = ["${module.vpc.cidr_block}"] #tfsec:ignore:AWS008
  }

  tags = {
    "CostCentre" = var.billing_code
  }

}

resource "aws_security_group" "ecs_tasks" {
  name        = "valentine-security-group"
  description = "Allow inbound and outbout traffic for Valentine"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow inbound traffic from the load balancer"
    protocol    = "tcp"
    from_port   = 4000
    to_port     = 4000
    cidr_blocks = ["${module.vpc.cidr_block}"]
  }

  egress {
    description = "Allow outbound traffic to the internet"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "CostCentre" = var.billing_code
  }
}

#
# Database
#
resource "aws_security_group_rule" "valentine_database_ingress_ecs" {
  description              = "Ingress from ECS task to database"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.rds_cluster.cluster_security_group_id
  source_security_group_id = aws_security_group.ecs_tasks.id
}
