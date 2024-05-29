variable "aws_region" {
  default = ""
}
variable "aws_account" {
  default = ""
}

# =====================================================
# CloudWatch Alarm - Action
# =====================================================
variable "email_notify_topic_name" {
  description = "Web Console > SNS > Topics > Name"
  type        = string
  default     = "mail-topic"
}