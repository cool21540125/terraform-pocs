# ==================================================================
# RDS
# ==================================================================
# resource "random_password" "rds_master_password" {
#   special = false
#   length  = 16
# }

# # ------------ RDS replica ------------
# resource "aws_db_instance" "poc_rds_replica" {

#   identifier          = "poc-sre-1234567890-replica"
#   replicate_source_db = aws_db_instance.poc_rds_single_instance.identifier

#   ### ------ Spec ------
#   instance_class       = "db.t4g.micro"
#   parameter_group_name = data.aws_db_parameter_group.tony_rds_params_group.name

#   ### ------ Spec - Storage ------
#   max_allocated_storage = 123
#   storage_type          = "gp2"

#   ### ------ Accessability ------
#   # password             = random_password.rds_master_password.result
#   publicly_accessible = true
#   # port                = 3306
#   # username             = "sre"
#   # password             = "2wsx$RFV1234zxcv"
#   availability_zone = "us-west-2b"
#   network_type      = "IPV4"
#   vpc_security_group_ids = [
#     "sg-0a627d789fef2836f" # iStore
#   ]

#   ### ------ Monitoring ------
#   monitoring_interval = 0 # 若為 1, 5, 10, 15, 30, 60 表示啟用 Enhanced Monitoring
#   # performance_insights_enabled          = true
#   # performance_insights_retention_period = 7
#   # monitoring_role_arn = ""       # 允許 Enhanced monitoring 寫入 log 到 CloudWatch
#   enabled_cloudwatch_logs_exports = [
#     "error",
#     "slowquery"
#   ]

#   ### ------ Security & Resilient ------
#   deletion_protection = false
#   multi_az            = false
#   storage_encrypted   = false # encryption of data at rest
#   # kms_key_id = ""

#   ### Backup & Snapshot
#   skip_final_snapshot         = true
#   delete_automated_backups    = false
#   auto_minor_version_upgrade  = true
#   allow_major_version_upgrade = false
#   maintenance_window          = "Mon:02:00-Mon:05:00"
#   backup_window               = "21:00-21:30"
#   backup_retention_period     = 7

#   ### Tags
#   tags = {
#     CreatedTool = "Terraform"
#   }

#   apply_immediately = true
# }


# ------------ RDS Primary ------------
resource "aws_db_instance" "poc_rds_single_instance" {

  identifier = "poc-sre-1234567890"
  db_name    = "poc_sre_db"

  ### ------ Spec ------
  engine               = "postgres"
  engine_version       = "13.11"
  instance_class       = "db.t4g.micro"
  parameter_group_name = data.aws_db_parameter_group.tony_rds_params_group.name

  ### ------ Spec - Storage ------
  allocated_storage     = 10
  max_allocated_storage = 123
  storage_type          = "gp2"
  # storage_throughput = 3000  # gp3 ONLY
  # iops = ""                  # 若 storage_type 為 gp3 | io1

  ### ------ Accessability ------
  # password             = random_password.rds_master_password.result
  publicly_accessible  = true
  port                 = 3306
  username             = "sre"
  password             = "2wsx$RFV1234zxcv"
  db_subnet_group_name = data.aws_db_subnet_group.ds_db_subnet_group.name
  availability_zone    = "us-west-2a"
  network_type         = "IPV4"
  vpc_security_group_ids = [
    "sg-0a627d789fef2836f" # iStore
  ]

  ### ------ Monitoring ------
  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7
  # performance_insights_kms_key_id       = ""
  monitoring_interval = 0 # 若為 1, 5, 10, 15, 30, 60 表示啟用 Enhanced Monitoring
  # monitoring_role_arn = ""       # 允許 Enhanced monitoring 寫入 log 到 CloudWatch
  # enabled_cloudwatch_logs_exports = [
  #   "postgresql",
  #   "upgrade"
  # ]

  ### ------ Security & Resilient ------
  deletion_protection = false
  multi_az            = false
  storage_encrypted   = false # encryption of data at rest
  # kms_key_id = ""

  ### Backup & Snapshot
  skip_final_snapshot         = true
  delete_automated_backups    = false
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  maintenance_window          = "Mon:00:00-Mon:03:00"
  backup_window               = "19:00-19:30"
  backup_retention_period     = 7

  ### Tags
  tags = {
    CreatedTool = "Terraform"
  }

  apply_immediately = true
}


# # ------------ RDS replica ------------
# resource "aws_db_instance" "poc_rds_replica2" {

#   identifier          = "poc-sre-1234567890-replica2"
#   replicate_source_db = aws_db_instance.poc_rds_single_instance.identifier

#   ### ------ Spec ------
#   instance_class       = "db.t4g.micro"
#   parameter_group_name = data.aws_db_parameter_group.tony_rds_params_group.name

#   ### ------ Spec - Storage ------
#   max_allocated_storage = 123
#   storage_type          = "gp2"

#   ### ------ Accessability ------
#   # password             = random_password.rds_master_password.result
#   publicly_accessible = true
#   # port                = 3306
#   # username             = "sre"
#   # password             = "2wsx$RFV1234zxcv"
#   availability_zone = "us-west-2a"
#   network_type      = "IPV4"
#   vpc_security_group_ids = [
#     "sg-0a627d789fef2836f" # iStore
#   ]

#   ### ------ Monitoring ------
#   monitoring_interval = 0 # 若為 1, 5, 10, 15, 30, 60 表示啟用 Enhanced Monitoring
#   # performance_insights_enabled          = true
#   # performance_insights_retention_period = 7
#   # monitoring_role_arn = ""       # 允許 Enhanced monitoring 寫入 log 到 CloudWatch
#   enabled_cloudwatch_logs_exports = [
#     "error",
#     "slowquery"
#   ]

#   ### ------ Security & Resilient ------
#   deletion_protection = false
#   multi_az            = false
#   storage_encrypted   = false # encryption of data at rest
#   # kms_key_id = ""

#   ### Backup & Snapshot
#   skip_final_snapshot         = true
#   delete_automated_backups    = false
#   auto_minor_version_upgrade  = true
#   allow_major_version_upgrade = false
#   maintenance_window          = "Mon:02:00-Mon:05:00"
#   backup_window               = "21:00-21:30"
#   backup_retention_period     = 7

#   ### Tags
#   tags = {
#     CreatedTool = "Terraform"
#   }

#   apply_immediately = true
# }