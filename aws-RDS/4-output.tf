output "out_rds_paimary_url" {
  value = aws_db_instance.poc_rds_single_instance.endpoint
}

# output "out_rds_replica1_url" {
#   value = aws_db_instance.poc_rds_replica.endpoint
# }