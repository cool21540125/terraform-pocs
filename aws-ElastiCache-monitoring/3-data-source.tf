# =====================================================
# ElastiCache - Standalone
# =====================================================
data "aws_elasticache_replication_group" "ds_redis" {
  replication_group_id = ""
}


# =====================================================
# SNS
# =====================================================
data "aws_sns_topic" "ds_alarm_notify" {
  name = var.email_notify_topic_name
}