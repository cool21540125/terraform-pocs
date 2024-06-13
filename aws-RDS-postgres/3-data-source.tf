data "aws_db_subnet_group" "ds_db_subnet_group" {
  name = "db"
}


data "aws_db_parameter_group" "tony_rds_params_group" {
  name = "default.postgres13"  # 2024.06 的現在, 依然沒有 14 版以上的 parameter group?!
}