locals {
  role_name = "github-restart-cluster-role"
}

module "gh_oidc_roles" {
  source   = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=v7.4.3"
  org_name = "canada-ca"
  roles = [
    {
      name      = local.role_name
      repo_name = "valentine"
      claim     = "ref:refs/heads/main"
    }
  ]

  billing_tag_value = var.billing_code

}

data "aws_iam_policy_document" "restart_cluster" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:UpdateService"
    ]
    resources = [
      aws_ecs_service.main.id
    ]
  }
}

resource "aws_iam_policy" "cluster_restart_policy" {
  name        = "cluster_restart_policy"
  description = "Policy to allow the OIDC user to restart the cluster"
  policy      = data.aws_iam_policy_document.restart_cluster.json
}

resource "aws_iam_role_policy_attachment" "cluster_restart_attachment" {
  role       = local.role_name
  policy_arn = aws_iam_policy.cluster_restart_policy.arn
}
