# ===============================================================================================
# CloudWatch - Alarm
# ===============================================================================================

### ECS Service 的 CPU 達到 70% -> notify
resource "aws_cloudwatch_metric_alarm" "wordpress-high-CPU-notify" {
  alarm_name        = "tf-ECS-${data.aws_ecs_cluster.ds_ecs_cluster.cluster_name}.${data.aws_ecs_service.ds_ecs_service.service_name}-70%-CPU-notify"
  alarm_description = "Average CPU > 70%"
  actions_enabled   = true

  metric_name         = "CPUUtilization"
  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 70
  period              = 60
  treat_missing_data  = "ignore"
  datapoints_to_alarm = 1 # `N` out of M
  evaluation_periods  = 1 # N out of `M`

  namespace = "AWS/ECS"
  dimensions = {
    ClusterName = data.aws_ecs_cluster.ds_ecs_cluster.cluster_name
    ServiceName = data.aws_ecs_service.ds_ecs_service.service_name
  }

  alarm_actions = [
    data.aws_sns_topic.ds_alarm_email_notify_topic.arn
  ]

  ok_actions = [
    data.aws_sns_topic.ds_alarm_email_notify_topic.arn
  ]
}

# ### TG 的 Tasks 有不健康的狀況 -> notify  (NOTE:因為只有 1 個 Task, 因此這一包監控不需要)
# # https:#docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-cloudwatch-metrics.html
# resource "aws_cloudwatch_metric_alarm" "wordpress-ecs-task-unhealthy-notify" {
#   alarm_name        = "tf-ECS-${data.aws_ecs_cluster.ds_ecs_cluster.cluster_name}.${data.aws_ecs_service.ds_ecs_service.service_name}-unhealthy-notify"
#   alarm_description = "One of wordpress ECS task is unhealthy"
#   actions_enabled   = true

#   metric_name         = "UnHealthyHostCount"
#   statistic           = "Maximum"
#   comparison_operator = "GreaterThanThreshold"
#   threshold           = 0
#   period              = 60
#   treat_missing_data  = "missing"
#   datapoints_to_alarm = 1 # `N` out of M
#   evaluation_periods  = 1 # N out of `M`

#   namespace = "AWS/ApplicationELB"
#   dimensions = {
#     TargetGroup  = var.ecs_tg_arn_suffix
#     LoadBalancer = var.ecs_lb_arn_suffix
#   }

#   alarm_actions = [
#     data.aws_sns_topic.ds_alarm_email_notify_topic.arn
#   ]

#   ok_actions = [
#     data.aws_sns_topic.ds_alarm_email_notify_topic.arn
#   ]
# }

# ### TG 的 Tasks 死光了 -> redeploy (暫時無此需求, 因為 WordPress 都只有一個 Task, 上面那個監控已經足夠)
resource "aws_cloudwatch_metric_alarm" "tko-wordpress-tasks-all-dead-repair" {
  alarm_name        = "tf-ECS-${data.aws_ecs_cluster.ds_ecs_cluster.cluster_name}.${data.aws_ecs_service.ds_ecs_service.service_name}-tasks-all-dead-repair"
  alarm_description = "All wordpress ECS tasks are unhealthy"
  actions_enabled   = true

  metric_name         = "HealthyHostCount"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  period              = 60
  treat_missing_data  = "ignore"
  datapoints_to_alarm = 1 # `N` out of M
  evaluation_periods  = 1 # N out of `M`

  namespace = "AWS/ApplicationELB"
  dimensions = {
    TargetGroup  = var.ecs_tg_arn_suffix
    LoadBalancer = var.ecs_lb_arn_suffix
  }

  alarm_actions = [
    data.aws_sns_topic.ds_alarm_email_notify_topic.arn,
    data.aws_lambda_function.ds_alarm_action_lambda.arn
  ]

  ok_actions = [
    data.aws_sns_topic.ds_alarm_email_notify_topic.arn
  ]
}

