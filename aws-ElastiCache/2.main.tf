
# # ====================================================================
# # ElastiCache - Cluster(Disabled) - Standalone
# # ====================================================================
# resource "aws_elasticache_cluster" "demo_standalone_redis" {
#   cluster_id           = "tf-redis-standalone"
#   engine               = "redis"
#   node_type            = "cache.t2.micro"
#   num_cache_nodes      = 3
#   parameter_group_name = "default.redis7"

#   engine_version = "7.0"
#   port           = 6379

#   log_delivery_configuration {
#     destination      = aws_cloudwatch_log_group.redis_standalone_engine_log.name
#     destination_type = "cloudwatch-logs"
#     log_format       = "text"
#     log_type         = "engine-log"
#   }
#   log_delivery_configuration {
#     destination      = aws_cloudwatch_log_group.redis_standalone_slow_log.name
#     destination_type = "cloudwatch-logs"
#     log_format       = "text"
#     log_type         = "slow-log"
#   }

#   auto_minor_version_upgrade = true
#   apply_immediately          = true
#   notification_topic_arn     = data.aws_sns_topic.ds_redis_notification.arn
#   maintenance_window         = "wed:20:00-wed:21:00"
#   snapshot_window            = "18:00-19:00"
#   snapshot_retention_limit   = 1
# }

# resource "aws_cloudwatch_log_group" "redis_standalone_engine_log" { # ElastiCache - Engine - Log Group
#   name              = "/aws/redis/demo_redis_standelone_engine"
#   retention_in_days = 7
#   skip_destroy      = false
# }
# resource "aws_cloudwatch_log_group" "redis_standalone_slow_log" { # ElastiCache - Engine - Log Group
#   name              = "/aws/redis/demo_redis_standelone_slow"
#   retention_in_days = 7
#   skip_destroy      = false
# }


# ====================================================================
# ElastiCache - Cluster(Disabled)
# ReplicationGroup
# ====================================================================
resource "aws_elasticache_replication_group" "demo_replication_group" { # ElastiCache - ReplicationGroup
  replication_group_id = "YOUR_CLUSTER"
  description          = "demo"

  node_type          = "cache.t2.micro"
  num_cache_clusters = 2
  # lifecycle {
  #   ignore_changes = [
  #     num_cache_clusters,
  #   ]
  # }

  parameter_group_name = "default.redis7"
  port                 = 6379
  engine_version       = "7.0"

  # log_delivery_configuration {
  #   destination      = aws_cloudwatch_log_group.redis_replication_engine_log.name
  #   destination_type = "cloudwatch-logs"
  #   log_format       = "text"
  #   log_type         = "engine-log"
  # }
  # log_delivery_configuration {
  #   destination      = aws_cloudwatch_log_group.redise_replication_slow_log.name
  #   destination_type = "cloudwatch-logs"
  #   log_format       = "text"
  #   log_type         = "slow-log"
  # }

  automatic_failover_enabled = true
  auto_minor_version_upgrade = true
  apply_immediately          = true

  notification_topic_arn   = data.aws_sns_topic.ds_redis_notification.arn
  # maintenance_window       = "wed:20:00-wed:21:00"
  # snapshot_window          = "18:00-19:00"
  # snapshot_retention_limit = 1
}

# resource "aws_elasticache_cluster" "replica" { # ElastiCache - replica  # WARNING: 這個好像有 BUG, 每次異動都會告知 notification_topic_arn 即將刪除
#   count = 1

#   replication_group_id = aws_elasticache_replication_group.demo_replication_group.id
#   cluster_id           = "tf-redis-replica-${count.index}"
# }

# resource "aws_cloudwatch_log_group" "redis_replication_engine_log" { # ElastiCache - Engine - Log Group
#   name              = "/aws/redis/demo_redis_replication_engine"
#   retention_in_days = 7
#   skip_destroy      = false
# }
# resource "aws_cloudwatch_log_group" "redise_replication_slow_log" { # ElastiCache - Engine - Log Group
#   name              = "/aws/redis/demo_redis_replication_slow"
#   retention_in_days = 7
#   skip_destroy      = false
# }

