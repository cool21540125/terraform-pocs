data "aws_iam_role" "data_lambda_execution_role" { # Lambda - Role
  name = var.lambda_role_name
}