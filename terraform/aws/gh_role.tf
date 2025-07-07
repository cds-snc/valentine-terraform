locals {
  github_restart_cluster_role = "github-restart-cluster-role"
  terraform_release_role      = "valentine-terraform-release"
}

#
# OIDC role to update the ECS service
#
module "gh_oidc_roles" {
  count = var.create_gh_oidc_ecs_service_role ? 1 : 0

  source   = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=v10.6.2"
  org_name = "canada-ca"
  roles = [
    {
      name      = local.github_restart_cluster_role
      repo_name = "navigator"
      claim     = "ref:refs/heads/main"
    }
  ]

  billing_tag_value = var.billing_code
}

data "aws_iam_policy_document" "restart_cluster" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]
    resources = [
      aws_ecs_service.main.id
    ]
  }
}

resource "aws_iam_policy" "cluster_restart_policy" {
  count = var.create_gh_oidc_ecs_service_role ? 1 : 0

  name        = "cluster_restart_policy"
  description = "Policy to allow the OIDC user to restart the cluster"
  policy      = data.aws_iam_policy_document.restart_cluster.json
}

resource "aws_iam_role_policy_attachment" "cluster_restart_attachment" {
  count = var.create_gh_oidc_ecs_service_role ? 1 : 0

  role       = local.github_restart_cluster_role
  policy_arn = aws_iam_policy.cluster_restart_policy[0].arn
}

#
# OIDC role to run Terraform apply when new releases are published
#
module "gh_oidc_terraform_release" {
  count = var.create_gh_oidc_terraform_release_role ? 1 : 0

  source   = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=v10.6.2"
  org_name = "cds-snc"
  roles = [
    {
      name      = local.terraform_release_role
      repo_name = "valentine-terraform"
      claim     = "ref:refs/tags/v*"
    }
  ]

  billing_tag_value = var.billing_code
}

resource "aws_iam_role_policy_attachment" "gh_oidc_terraform_release" {
  count = var.create_gh_oidc_terraform_release_role ? 1 : 0

  role       = local.terraform_release_role
  policy_arn = data.aws_iam_policy.admin.arn

  depends_on = [
    module.gh_oidc_terraform_release[0]
  ]
}

data "aws_iam_policy" "admin" {
  name = "AdministratorAccess"
}