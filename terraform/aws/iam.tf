data "aws_iam_policy_document" "valentine" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "valentine_secrets_manager" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
    ]
    resources = concat(
      [
        aws_ssm_parameter.azure_openai_endpoint.arn,
        aws_ssm_parameter.azure_openai_key.arn,
        aws_ssm_parameter.database_url.arn,
        aws_ssm_parameter.secret_key_base.arn
      ],
      (var.create_cognito_user_pool ?
        [
          aws_ssm_parameter.cognito_domain[0].arn,
          aws_ssm_parameter.cognito_client_id[0].arn,
          aws_ssm_parameter.cognito_client_secret[0].arn,
          aws_ssm_parameter.cognito_user_pool_id[0].arn,
          aws_ssm_parameter.cognito_aws_region[0].arn,
      ] : []),
      (var.create_google_auth ?
        [
          aws_ssm_parameter.google_client_id[0].arn,
          aws_ssm_parameter.google_client_secret[0].arn,
      ] : [])
    )
  }
}

resource "aws_iam_policy" "valentine_secrets_manager" {
  name   = "valentineSecretsManagerKeyRetrieval"
  path   = "/"
  policy = data.aws_iam_policy_document.valentine_secrets_manager.json
}

resource "aws_iam_role" "valentine" {
  name = "valentine-ecs-role"

  assume_role_policy = data.aws_iam_policy_document.valentine.json

  tags = {
    "CostCentre" = var.billing_code
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.valentine.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "secrets_manager" {
  role       = aws_iam_role.valentine.name
  policy_arn = aws_iam_policy.valentine_secrets_manager.arn
}
