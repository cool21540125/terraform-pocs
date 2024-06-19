# ==================================================================
# RDS
# FIXME: 依舊無法使用 2024-06-14, 因有其他任務... 這邊先擺著
# ==================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version
data "aws_rds_engine_version" "poc_rds_cluster_version" {
  engine  = "aurora-mysql"
  version = "8.0.32"
}

resource "aws_rds_cluster_instance" "poc_rds_cluster_instance" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.poc_rds_cluster_cluster.id
  instance_class     = aws_rds_cluster.poc_rds_cluster_cluster.db_cluster_instance_class
  engine             = "aurora-mysql"
  engine_version     = data.aws_rds_engine_version.poc_rds_cluster_version
}


resource "aws_rds_cluster" "poc_rds_cluster_cluster" {
  database_name      = "poc-sre-aurora-mysql-demo"
  cluster_identifier = "poc-sre-1234567890"

  ### ------ Spec ------
  engine                          = "aurora-mysql"
  engine_version                  = data.aws_rds_engine_version.poc_rds_cluster_version
  db_cluster_instance_class       = "db.t3.small" # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html
  db_cluster_parameter_group_name = data.aws_db_parameter_group.tony_rds_params_group.name

  ### ------ Spec - Storage ------
  allocated_storage = 10
  storage_type      = "gp2"
  # storage_throughput = 3000  # gp3 ONLY
  # iops = ""                  # 若 storage_type 為 gp3 | io1

  ### ------ Accessability ------
  # password             = random_password.rds_master_password.result
  port                 = 3306
  master_username      = "sre"
  master_password      = "2wsx$RFV1234zxcv"
  db_subnet_group_name = data.aws_db_subnet_group.ds_db_subnet_group.name
  network_type         = "IPV4"
  availability_zones   = ["us-west-2a", "us-west-2b"]
  vpc_security_group_ids = [
    "sg-0a627d789fef2836f" # iStore
  ]

  ### ------ Monitoring ------
  enabled_cloudwatch_logs_exports = [
    "error",
    "slowquery"
  ]

  ### ------ Security & Resilient ------
  deletion_protection = false
  storage_encrypted   = false # encryption of data at rest
  # kms_key_id = ""

  ### Backup & Snapshot
  skip_final_snapshot         = true
  delete_automated_backups    = false
  allow_major_version_upgrade = false
  backup_retention_period     = 7

  ### Tags
  tags = {
    CreatedTool = "Terraform"
  }

  apply_immediately = true
}
