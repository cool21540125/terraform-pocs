
data "aws_sns_topic" "ds_redis_notification" {
  name = var.topic_name
}