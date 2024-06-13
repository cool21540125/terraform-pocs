# ================================================================================
# Lambda Function
# ================================================================================
resource "aws_lambda_function" "cwa_ecs_wordpress_redeploy" { # Lambda - Function
  function_name = var.function_name
  description   = "tf-CloudWatch Alarm Action - redeploy ECS Wordpress"

  filename         = "out/python.zip"
  source_code_hash = filebase64sha256("out/python.zip")

  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"]
  memory_size   = 256
  timeout       = 60

  ephemeral_storage {
    size = 512
  }
  tracing_config {
    mode = "PassThrough"
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_log_group.name
  }

  role = data.aws_iam_role.data_lambda_execution_role.arn
}

resource "aws_lambda_permission" "cwa_lambda_permission" { # Lambda - ResourceBasedPolicy
  action        = "lambda:InvokeFunction"
  principal     = "lambda.alarms.cloudwatch.amazonaws.com"
  function_name = var.function_name
}

resource "aws_cloudwatch_log_group" "lambda_log_group" { # Lambda - LogGroup
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 90
  skip_destroy      = false

  tags = {
    CreatedTool = "Terraform"
    Usage       = "CloudWatch Alarm trigger Lambda Function to restart ECS wordpress/blog task"
  }
}


# ================================================================================
# CloudWatch Alarm
# ================================================================================

module "cwa-exampleWordpress" {
  source             = "../modules/wordpress"
  # alarm_name_pattern = "cluster.exampleWordpress"

  ecs_lb_arn_suffix = "app/cluster-server/cffdf30aea0860f3"
  ecs_tg_arn_suffix = "targetgroup/ecs-takeor-exampleWordpress/1qaz2wsx3edc4rfv"
  ecs_cluster_name  = "cluster"
  ecs_service_name  = "exampleWordpress"

  email_notify_topic_name = var.email_notify_topic_name
  function_name           = var.function_name
}
