locals {
  elasticache_member_clusters = tolist(data.aws_elasticache_replication_group.ds_redis.member_clusters)
}

# ====================================================================
# CWA - ElastiCache ReplicationGroup
# ====================================================================
resource "aws_cloudwatch_metric_alarm" "cwa_redis_cpu" {
  count             = 2 # primary + replicas
  alarm_name        = "${element(local.elasticache_member_clusters, count.index)}-cpu"
  alarm_description = "tf ElastiCache Replication Group"
  actions_enabled   = true

  metric_name         = "CPUUtilization"
  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 90
  period              = 60
  treat_missing_data  = "missing"
  datapoints_to_alarm = 1 # `N` out of M
  evaluation_periods  = 1 # N out of `M`

  namespace = "AWS/ElastiCache"
  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = [
    data.aws_sns_topic.ds_alarm_notify.arn
  ]

  ok_actions = [
    data.aws_sns_topic.ds_alarm_notify.arn
  ]
}
