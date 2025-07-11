resource "aws_ecs_cluster" "valentine" {
  name = "valentine-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "valentine" {
  template = file("./templates/valentine.json.tpl")

  vars = {
    awslogs-group            = aws_cloudwatch_log_group.valentine_group.name
    awslogs-region           = var.region
    awslogs-stream-prefix    = "ecs-valentine"
    image                    = "public.ecr.aws/cds-snc/valentine:latest"
    fargate_cpu              = var.fargate_cpu
    fargate_memory           = var.fargate_memory
    aws_region               = var.region
    AZURE_OPENAI_ENDPOINT    = aws_ssm_parameter.azure_openai_endpoint.arn
    AZURE_OPENAI_KEY         = aws_ssm_parameter.azure_openai_key.arn
    COGNITO_DOMAIN           = var.create_cognito_user_pool ? aws_ssm_parameter.cognito_domain[0].arn : ""
    COGNITO_CLIENT_ID        = var.create_cognito_user_pool ? aws_ssm_parameter.cognito_client_id[0].arn : ""
    COGNITO_CLIENT_SECRET    = var.create_cognito_user_pool ? aws_ssm_parameter.cognito_client_secret[0].arn : ""
    COGNITO_USER_POOL_ID     = var.create_cognito_user_pool ? aws_ssm_parameter.cognito_user_pool_id[0].arn : ""
    COGNITO_AWS_REGION       = var.create_cognito_user_pool ? aws_ssm_parameter.cognito_aws_region[0].arn : ""
    CREATE_COGNITO_USER_POOL = var.create_cognito_user_pool
    CREATE_GOOGLE_AUTH       = var.create_google_auth
    DATABASE_URL             = aws_ssm_parameter.database_url.arn
    GOOGLE_CLIENT_ID         = var.create_google_auth ? aws_ssm_parameter.google_client_id[0].arn : ""
    GOOGLE_CLIENT_SECRET     = var.create_google_auth ? aws_ssm_parameter.google_client_secret[0].arn : ""
    PHX_HOST                 = aws_acm_certificate.valentine.domain_name
    SECRET_KEY_BASE          = aws_ssm_parameter.secret_key_base.arn
  }
}

resource "aws_ecs_task_definition" "valentine" {
  family                   = "valentine-task"
  execution_role_arn       = aws_iam_role.valentine.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.valentine.rendered
  task_role_arn            = aws_iam_role.valentine.arn
}

resource "aws_ecs_service" "main" {
  name             = "valentine-service"
  cluster          = aws_ecs_cluster.valentine.id
  task_definition  = aws_ecs_task_definition.valentine.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  propagate_tags   = "SERVICE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = module.vpc.private_subnet_ids
    assign_public_ip = false
  }

  depends_on = [
    aws_lb_listener.valentine_listener,
    aws_iam_role_policy_attachment.ecs_task_execution
  ]

  load_balancer {
    target_group_arn = aws_lb_target_group.valentine.arn
    container_name   = "valentine"
    container_port   = 4000
  }

  tags = {
    "CostCentre" = var.billing_code
  }
}

resource "aws_cloudwatch_log_group" "valentine_group" {
  name              = "/ecs/valentine-app"
  retention_in_days = 30

  tags = {
    Name = "valentine-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "valentine_stream" {
  name           = "valentine-log-stream"
  log_group_name = aws_cloudwatch_log_group.valentine_group.name
}
