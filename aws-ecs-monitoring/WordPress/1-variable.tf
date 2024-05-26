variable "aws_region" {
  type    = string
  default = ""
}
variable "aws_account" {
  type    = string
  default = ""
}


# =====================================================
# CloudWatch Alarm - Action
# =====================================================
variable "email_notify_topic_name" {
  default = "poc-sre-topic"
}

variable "function_name" {
  default = "tf-cwa-action-ecs-wordpress"
}
variable "lambda_role_name" {
  default = "CwaLambdaRemediationRole"
}


# =====================================================
# CloudWatch Alarm Source
# =====================================================
variable "ecs_cluster_name" {
  default = ""
}
variable "ecs_service_name" {
  default = ""
}
