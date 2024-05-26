# =====================================================
# AWS
# =====================================================
data "aws_region" "ds_region" {}
data "aws_caller_identity" "ds_caller" {}


# =====================================================
# ECS
# =====================================================
data "aws_ecs_cluster" "ds_ecs_cluster" {
  cluster_name = var.ecs_cluster_name
}
data "aws_ecs_service" "ds_ecs_service" {
  service_name = var.ecs_service_name
  cluster_arn  = "arn:aws:ecs:${data.aws_region.ds_region.name}:${data.aws_caller_identity.ds_caller.account_id}:cluster/${var.ecs_cluster_name}"
}

# =====================================================
# ALB && TG
# =====================================================
data "aws_lb" "ds_ecs_alb" {
  arn  = "arn:aws:elasticloadbalancing:${data.aws_region.ds_region.name}:${data.aws_caller_identity.ds_caller.account_id}:loadbalancer/${var.ecs_lb_arn_suffix}"
  name = var.ecs_lb_arn_suffix
}
data "aws_lb_target_group" "ds_ecs_alb_tg" {
  arn  = "arn:aws:elasticloadbalancing:${data.aws_region.ds_region.name}:${data.aws_caller_identity.ds_caller.account_id}:${var.ecs_tg_arn_suffix}"
  name = var.ecs_tg_arn_suffix
}



# =====================================================
# SNS
# =====================================================
data "aws_sns_topic" "ds_alarm_email_notify_topic" {
  name = var.email_notify_topic_name
}

# =====================================================
# Lambda
# =====================================================
data "aws_lambda_function" "ds_alarm_action_lambda" {
  function_name = var.function_name
}