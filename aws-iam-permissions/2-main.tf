# locals {
#   remediate_ecs_policy = jsondecode(file("config/CwaRemediateEcsPolicy.json"))
# }

# ===============================================================================================
# Role && Policy FIXME: 偵測 Policy.json 的 md5
# ===============================================================================================
resource "aws_iam_role" "cwa_lambda_remediation_role" {
  name        = "CwaLambdaRemediationRole"
  description = "Allows Lambda functions to do remediate, because of CloudWatch Alarm has beed triggered. Created by SRE on 2024-05-24"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# resource "aws_iam_role_policy" "cwa_remediate_ecs_policy_old" {
#   name   = "CwaRemediateEcsPolicy"
#   role   = aws_iam_role.cwa_lambda_remediation_role.id
#   policy = file("config/CwaRemediateEcsPolicy.json")
# }

data "aws_iam_policy_document" "cwa_remediate_ecs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:UpdateService",
      "ecs:List*",
      "ecs:Describe*"
    ]
    resources = [
      "arn:aws:ecs:*:*:service/*/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }
}
